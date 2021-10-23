import re

from pathlib import Path
from struct import unpack
from typing import List, Union

EXPORT_TABLE_FORMAT_STRING = "{0:<10}{1:<17}{2:<13}{3:>20}     {4:<40}"
IMPORT_TABLE_FORMAT_STRING = "{0:<10}{1:<17}{2:<40}"
LOG_SEPARATOR = "-" * 100
GFX_REGEX = re.compile(b"GFX")
XCOM_VERSION = 845

def offset_to_address(offset: int) -> str:
    hex_digits = hex(offset)[2:]
    return "0x" + hex_digits.zfill(8)

class UpkHeader:
    def __init__(self):
        self.header_size = -1
        self.folder_name = ""
        self.export_table_length = -1
        self.export_table_byte_offset = -1
        self.import_table_length = -1
        self.import_table_byte_offset = -1
        self.name_table_length = -1
        self.name_table_byte_offset = -1

        self.containing_content = None # Populated after all parsing is done

    def log(self, raw_data=False):
        print(f"Folder name: {self.folder_name}")
        print(f"Name table length: {self.name_table_length}")
        print(f"Import table length: {self.import_table_length}")
        print(f"Export table length: {self.export_table_length}")

class UpkNameTableEntry:
    def __init__(self):
        self.index = -1
        self.name = ""
        self.name_table_pos_bytes = -1

    def log(self, raw_data=False):
        pass

class UpkExport:
    def __init__(self):
        self.data_pos_bytes = -1
        self.data_size = -1
        self.export_table_pos_bytes = -1
        self.index = 0
        self.name_table_index = -1
        self.obj_name_count = -1
        self.obj_type_ref = 0
        self.owner_ref = 0
        self.parent_class_ref = 0

        self.containing_content = None # Populated after all parsing is done

    def log(self):
        mem_offset_hex = offset_to_address(self.export_table_pos_bytes)
        data_offset_hex = offset_to_address(self.data_pos_bytes)

        print(EXPORT_TABLE_FORMAT_STRING.format(self.index, mem_offset_hex, data_offset_hex, self.data_size, self.fully_qualified_name))

    def save_to_file(self, path: Path):
        data = self.serialized_data

        # SwfMovie objects are imported into UE with their first 3 characters changed to GFX, as part of the Scaleform
        # integration. To be usable in Flash, those characters need to be replaced with valid Flash signature values.
        if self.type.name == "SwfMovie":
            match = GFX_REGEX.search(data)

            if match is None:
                raise ValueError(f"Could not find 'GFX' string in {self}. This object may be corrupted.")

            # Bytes 4 through 8 contain the total file size of the SWF
            fla_size = unpack("<I", data[match.start() + 4: match.start() + 8])[0]

            # F indicates the file is uncompressed; W and S are fixed
            data = b"FWS" + data[match.start() + 3:match.start() + fla_size]

        path.write_bytes(data)

    def __str__(self):
        return self.fully_qualified_name

    def get_fully_qualified_name(self):
        name_str = self.name
        owner = self.owner
        type = self.type

        if owner is not None and type is not None:
            return f"{type.name}'{owner.name}.{name_str}'"
        elif owner is not None:
            return f"{owner.name}.{name_str}"
        elif type is not None:
            return f"{type.name}'{name_str}'"
        else:
            return name_str

    def get_name(self):
        if self.containing_content is None:
            return "Unknown"

        name_val = self.containing_content.resolve_name_index(self.name_table_index)

        if self.obj_name_count > 0:
            return name_val + "_" + str(self.obj_name_count - 1)

        return name_val

    def get_owner(self):
        return None if self.containing_content is None else self.containing_content.resolve_ref(self.owner_ref)

    def get_serialized_data(self) -> bytes:
        return self.containing_content.bytes_data[self.data_pos_bytes:self.data_pos_bytes + self.data_size]

    def get_type(self) -> Union["UpkExport", "UpkImport"]:
        return None if self.containing_content is None else self.containing_content.resolve_ref(self.obj_type_ref)

    fully_qualified_name = property(get_fully_qualified_name)
    name = property(get_name)
    owner = property(get_owner)
    serialized_data = property(get_serialized_data)
    type = property(get_type)

class UpkImport:
    def __init__(self):
        self.import_table_pos_bytes = -1
        self.index = 0
        self.name_table_index = -1
        self.obj_type_name_table_index = 0
        self.owner_ref = 0
        self.pkg_name_table_index = 0

        self.containing_content = None # Populated after all parsing is done

    def log(self):
        mem_offset_hex = offset_to_address(self.import_table_pos_bytes)
        print(IMPORT_TABLE_FORMAT_STRING.format(self.index, mem_offset_hex, self.fully_qualified_name))

    def __str__(self):
        return self.fully_qualified_name

    def get_fully_qualified_name(self):
        name_str = self.name
        owner = self.owner
        type_str = self.type

        if owner is not None:
            return f"{type_str}'{owner.name}.{name_str}'"
        else:
            return f"{type_str}'{name_str}'"

    def get_name(self):
        return "Unknown" if self.containing_content is None else self.containing_content.resolve_name_index(self.name_table_index)

    def get_owner(self):
        return None if self.containing_content is None else self.containing_content.resolve_ref(self.owner_ref)

    def get_package_name(self):
        if self.type == "Package":
            return "N/A"

        return "Unknown" if self.containing_content is None else self.containing_content.resolve_name_index(self.pkg_name_table_index)

    def get_type(self):
        return "Unknown" if self.containing_content is None else self.containing_content.resolve_name_index(self.obj_type_name_table_index)

    fully_qualified_name = property(get_fully_qualified_name)
    name = property(get_name)
    owner = property(get_owner)
    package = property(get_package_name)
    type = property(get_type)

class UpkContent:
    def __init__(self, bytes_data: bytes, header: UpkHeader, names: List[UpkNameTableEntry], exports: List[UpkExport], imports: List[UpkImport]):
        self.bytes_data = bytes_data
        self.header = header
        self.names = names
        self.exports = exports
        self.imports = imports

        # Format strings for logging; determined dynamically based on data
        self.export_table_format_string = ""
        self.TABLE_FORMAT_STRING = ""
        self.name_table_format_string = ""

        # Give a reference to this to each of the components
        header.containing_content = self

        for exp in self.exports:
            if exp is not None:
                exp.containing_content = self

        for imp in self.imports:
            if imp is not None:
                imp.containing_content = self

    def get_exports_by_type(self, obj_type: str) -> List[UpkExport]:
        matches = []

        for exp in self.exports:
            if exp is not None and exp.type.name == obj_type:
                matches.append(exp)

        return matches

    def log(self):
        print()
        print("UPK package header data")
        self.header.log()
        print()

        # For imports/exports, remember to account for the first entry being null
        print()
        print(LOG_SEPARATOR)
        print(" " * 34 + f"Import table ({len(self.imports) - 1} entries)")
        print(LOG_SEPARATOR)
        print(IMPORT_TABLE_FORMAT_STRING.format("Index", "Table offset", "Fully qualified name"))
        print(LOG_SEPARATOR)

        for i in range(1, len(self.imports)):
            self.imports[i].log()

        print()
        print(LOG_SEPARATOR)
        print(" " * 34 + f"Export table ({len(self.exports) - 1} entries)")
        print(LOG_SEPARATOR)
        print(EXPORT_TABLE_FORMAT_STRING.format("Index", "Table offset", "Data offset", "Data size (bytes)", "Fully qualified name"))
        print(LOG_SEPARATOR)

        for i in range(1, len(self.exports)):
            self.exports[i].log()

    def resolve_name_index(self, name_index: int) -> str:
        return "" if name_index < 0 or name_index >= len(self.names) else self.names[name_index].name

    def resolve_ref(self, ref_index: int) -> Union[UpkExport, UpkImport]:
        return None if ref_index == 0 else self.exports[ref_index] if ref_index > 0 else self.imports[abs(ref_index)]

def parse_upk_data(upk_bytes: bytes) -> UpkContent:
    header = parse_upk_header(upk_bytes)
    names = parse_upk_names(upk_bytes, header)
    exports = parse_upk_exports(upk_bytes, header, names)
    imports = parse_upk_imports(upk_bytes, header)

    upkContent = UpkContent(upk_bytes, header, names, exports, imports)

    return upkContent

def parse_upk_exports(upk_bytes: bytes, header: UpkHeader, names: List[str]) -> List[UpkExport]:
    exports = []
    cur_pos = header.export_table_byte_offset

    # The first entry in the table is null
    exports.append(None)

    for i in range(1, header.export_table_length + 1):
        export_obj = UpkExport()

        export_obj.export_table_pos_bytes = cur_pos
        export_obj.index = i

        # References are signed integers, where positive values are indices in the export table,
        # and negative values are indices in the import table
        export_obj.obj_type_ref = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little", signed=True)
        cur_pos += 4

        export_obj.parent_class_ref = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little", signed=True)
        cur_pos += 4

        export_obj.owner_ref = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little", signed=True)
        cur_pos += 4

        export_obj.name_table_index = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
        cur_pos += 4

        export_obj.obj_name_count = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
        cur_pos += 4

        # Skip three integers
        cur_pos += 12

        # How large the serialized object is
        export_obj.data_size = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
        cur_pos += 4

        # Where in the file the serialized object begins
        export_obj.data_pos_bytes = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
        cur_pos += 4

        # Skip one integer
        cur_pos += 4

        num_additional_fields = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
        cur_pos += 4

        # There are 5 fixed integer fields, then a variable number of integer fields, then the start of the next object
        cur_pos += 5 * 4 + num_additional_fields * 4

        exports.append(export_obj)

    return exports

def parse_upk_header(upk_bytes: bytes):
    header_obj = UpkHeader()
    cur_pos = 0

    # First 4 bytes should be the UPK file signature
    if int.from_bytes(upk_bytes[cur_pos:cur_pos + 4], "little") != 0x9E2A83C1:
        raise ValueError(f"File does not appear to be a UPK file. Leading 4 bytes are {upk_bytes[0:4]}")

    cur_pos += 4

    # Next 2 bytes are the Unreal version
    version = unpack("<H", upk_bytes[cur_pos:cur_pos+2])[0]
    cur_pos += 2

    if version != XCOM_VERSION:
        raise RuntimeError(f"Version in header is {version}, which doesn't match XCOM's version ({XCOM_VERSION}). The UPK may be compressed.")

    # Following 2 bytes are the "Licensee Version"; not sure what that means but we don't need it
    cur_pos += 2

    # Next 4 bytes specify the size of the package header
    header_obj.header_size = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
    cur_pos += 4

    # Bytes 12 through 15 give the length of the following string field
    folder_name_length = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
    cur_pos += 4

    # Variable length string
    if folder_name_length > 0:
        header_obj.folder_name = upk_bytes[cur_pos:cur_pos + folder_name_length - 1].decode()
        cur_pos += folder_name_length

    # Next 4 bytes are package flags, irrelevant to us
    cur_pos += 4

    # Next 4 bytes: number of names stored in the name table
    header_obj.name_table_length = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
    cur_pos += 4

    # Next 4 bytes: absolute offset of the name table in the UPK file
    header_obj.name_table_byte_offset = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
    cur_pos += 4

    # Next 4 bytes: number of entries in the export table
    header_obj.export_table_length = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
    cur_pos += 4

    # Next 4 bytes: absolute offset of the export table in the UPK file
    header_obj.export_table_byte_offset = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
    cur_pos += 4

    # Next 4 bytes: number of entries in the import table
    header_obj.import_table_length = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
    cur_pos += 4

    # Next 4 bytes: absolute offset of the import table in the UPK file
    header_obj.import_table_byte_offset = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
    cur_pos += 4

    return header_obj

def parse_upk_imports(upk_bytes: bytes, header: UpkHeader) -> List[UpkImport]:
    imports = []
    cur_pos = header.import_table_byte_offset

    # The first entry in the table is null
    imports.append(None)

    for i in range(1, header.import_table_length + 1):
        import_obj = UpkImport()

        import_obj.import_table_pos_bytes = cur_pos
        import_obj.index = -1 * i

        # First 4 bytes: name index of the containing package
        import_obj.pkg_name_table_index = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
        cur_pos += 4

        # Next 4 bytes unused
        cur_pos += 4

        # Next 4 bytes: name index of the object's class
        import_obj.obj_type_name_table_index = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
        cur_pos += 4

        # Next 4 bytes unused
        cur_pos += 4

        # Next 4 bytes: reference to the object's owner
        import_obj.owner_ref = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little", signed=True)
        cur_pos += 4

        # Next 4 bytes: name index of this object
        import_obj.name_table_index = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
        cur_pos += 4

        # Last 4 bytes unused
        cur_pos += 4

        imports.append(import_obj)

    return imports

def parse_upk_names(upk_bytes: bytes, header: UpkHeader) -> List[str]:
    names: List[UpkNameTableEntry] = []
    cur_pos = header.name_table_byte_offset

    for i in range(header.name_table_length):
        name_entry = UpkNameTableEntry()

        name_entry.name_table_pos_bytes = cur_pos

        # Each name entry starts with the name's length
        name_length = int.from_bytes(upk_bytes[cur_pos:cur_pos+4], "little")
        cur_pos += 4

        # Name is null-terminated, so drop that character when reading it
        name_entry.name = upk_bytes[cur_pos:cur_pos + name_length - 1].decode()
        cur_pos += name_length

        # There are two integers after the name value that we don't care about, then the next name
        cur_pos += 8

        names.append(name_entry)

    return names