from PIL import Image
import numpy as np
import argparse

def txt_to_png(txt_file, png_file, width=512, height=512):
    data = []
    invalid_count = 0
    with open(txt_file, 'r') as f:
        for line_num, line in enumerate(f, start=1):
            line = line.strip()
            if len(line) == 8 and all(c in "01" for c in line):
                data.append(int(line, 2))
            else:
                print(f"Warning: Replacing invalid line {line_num} with 0")
                data.append(0)  # Replace invalid entries with 0 (black pixel)
                if (line_num <= 262144): invalid_count += 1              
    print("Number of invalid pixels =", invalid_count)

    # Ensure data has exactly width * height elements
    if len(data) != width * height:
        print(f"Warning: Adjusting pixel count from {len(data)} to {width * height}")
        data = data[:width * height] + [0] * (width * height - len(data))

    # Convert to numpy array and reshape
    image_array = np.array(data, dtype=np.uint8).reshape((height, width))

    # Create and save the image
    image = Image.fromarray(image_array, mode='L')  # 'L' mode for grayscale
    image.save(png_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process input and output file paths.")
    parser.add_argument("-i", "--input", required=True, help="Path to the input file")
    parser.add_argument("-o", "--output", required=True, help="Path to the output file")
    
    args = parser.parse_args()
    txt_to_png(args.input, args.output)
