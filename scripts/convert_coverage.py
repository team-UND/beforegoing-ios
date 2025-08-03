import json
import sys
import xml.etree.ElementTree as ET

def convert_coverage(input_file, output_file):
    try:
        with open(input_file, 'r') as f:
            coverage_data = json.load(f)
        
        # Convert to SonarCloud Generic Coverage XML format
        root = ET.Element('coverage', version="1")
        
        for target in coverage_data.get('targets', []):
            for file_data in target.get('files', []):
                file_elem = ET.SubElement(root, 'file', path=file_data['path'])
                
                for line_coverage in file_data.get('lines', []):
                    ET.SubElement(file_elem, 'lineToCover', 
                                lineNumber=str(line_coverage['lineNumber']),
                                covered=str(line_coverage['executionCount'] > 0).lower())
        
        tree = ET.ElementTree(root)
        tree.write(output_file, encoding='utf-8', xml_declaration=True)
        print(f"Successfully converted {input_file} to {output_file}")

    except FileNotFoundError:
        print(f"Error: Input file not found at '{input_file}'", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: Failed to decode JSON from '{input_file}'. The file might be corrupted or not in JSON format.", file=sys.stderr)
        sys.exit(1)
    except (KeyError, IndexError) as e:
        print(f"Error: Unexpected data structure in '{input_file}'. Missing key or index: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 convert_coverage.py <input_json_file> <output_xml_file>", file=sys.stderr)
        sys.exit(1)
    convert_coverage(sys.argv[1], sys.argv[2])
