import argparse

from pathlib import Path

from py_modules.upk_objects import parse_upk_data

def extract_swf_files_from_upk(upk_path: Path, output_dir: Path):
    upk_bytes = upk_path.read_bytes()
    upk_content = parse_upk_data(upk_bytes)
    num_extracted = 0
    num_objects = 0

    for export in upk_content.get_exports_by_type("SwfMovie"):
        num_objects += 1
        out_path = output_dir

        if export.owner is not None:
            out_path = out_path.joinpath(export.owner.name)
            out_path.mkdir(exist_ok=True, parents=True)

        out_path = out_path.joinpath(f"{export.name}.swf")

        try:
            export.save_to_file(out_path)
        except ValueError as err:
            print(f"Failed to export object {export}")
            print(f"Error: {err}")
            continue

        num_extracted += 1

    print(f"Extracted {num_extracted} of {num_objects} objects successfully.")

def main():
    parser = argparse.ArgumentParser(description="Extracts objects from a UPK into an output directory.")

    parser.add_argument("upk", type=Path, help="Path to the UPK file to extract from")
    parser.add_argument("--output-dir", type=Path, default="./output", help="Path that objects should be extracted to")

    args = parser.parse_args()

    extract_swf_files_from_upk(args.upk, args.output_dir)

if __name__ == "__main__":
    main()