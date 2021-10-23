import argparse

from pathlib import Path

from py_modules.upk_objects import parse_upk_data

def extract_swf_files_from_upk(upk_path: Path, output_dir: Path, verbose: bool):
    upk_bytes = upk_path.read_bytes()
    upk_content = parse_upk_data(upk_bytes)

    for export in upk_content.get_exports_by_type("SwfMovie"):
        out_path = output_dir

        if export.owner is not None:
            out_path = out_path.joinpath(export.owner.name)
            out_path.mkdir(exist_ok=True)

        out_path = out_path.joinpath(f"{export.name}.swf")
        export.save_to_file(out_path)

def main():
    parser = argparse.ArgumentParser(description="Extracts objects from a UPK into an output directory.")
    parser.add_argument("upk", type=Path, help="Path to the UPK file to extract from")

    args = parser.parse_args()

    upk_bytes = args.upk.read_bytes()
    upk_content = parse_upk_data(upk_bytes)
    upk_content.log()

if __name__ == "__main__":
    main()