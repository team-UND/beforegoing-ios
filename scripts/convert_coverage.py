import json
import sys
import xml.etree.ElementTree as ET

def convert_coverage(input_file, output_file):
    with open(input_file, 'r') as f:
        coverage_data = json.load(f)
    
    # Convert to SonarCloud Generic Coverage XML format
    root = ET.Element('coverage', version="1")
    
    for target in coverage_data.get('targets', []):
        for file_data in target.get('files', []):
            file_elem = ET.SubElement(root, 'file', path=file_data['path'])
            
            for line_coverage in file_data.get('functions', []):
                ET.SubElement(file_elem, 'lineToCover', 
                            lineNumber=str(line_coverage['line']),
                            covered=str(line_coverage['executionCount'] > 0).lower())
    
    tree = ET.ElementTree(root)
    tree.write(output_file, encoding='utf-8', xml_declaration=True)

if __name__ == "__main__":
    convert_coverage(sys.argv[1], sys.argv[2])