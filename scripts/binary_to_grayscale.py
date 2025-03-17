import os
import numpy as np
from PIL import Image
import argparse

def load_binary_image(binary_image_path, image_shape):
    """Loads a binary file and reshapes it into a grayscale image array."""
    # Read the binary file and reshape into the original image shape (e.g., 512x512)
    binary_img = np.fromfile(binary_image_path, dtype=np.uint8)  # Read the binary data
    img = binary_img.reshape(image_shape)  # Reshape into the original image dimensions (e.g., 512x512)
    return img

def save_image_from_binary(image_array, output_path):
    """Saves the NumPy array as a grayscale image (.png)."""
    img = Image.fromarray(image_array)  # Convert the NumPy array back to a PIL Image
    img.save(output_path)  # Save the image as PNG

def process_binary_images(input_folder, output_folder, image_shape):
    """Process all binary image files in the input folder and save them as PNG images."""
    # Ensure the output folder exists
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Loop through all files in the input folder
    for filename in os.listdir(input_folder):
        if filename.endswith('.txt'):  # Assuming binary files have .txt extension
            binary_image_path = os.path.join(input_folder, filename)
            
            # Load the binary image and convert it back to a NumPy array
            img_array = load_binary_image(binary_image_path, image_shape)
            
            # Prepare the output file path
            output_filename = os.path.splitext(filename)[0] + '.png'
            output_path = os.path.join(output_folder, output_filename)
            
            # Save the image as a PNG file
            save_image_from_binary(img_array, output_path)
            print(f"Converted {filename} back to PNG and saved to {output_filename}")

parser = argparse.ArgumentParser(description="Process input and output file paths.")
parser.add_argument("-i", "--input", required=True, help="Path to the input file")
parser.add_argument("-o", "--output", required=True, help="Path to the output file")
    
args = parser.parse_args()
    
print(f"Input file: {args.input}")
print(f"Output file: {args.output}")

input_folder = args.input
output_folder = args.output
image_shape = (512, 512)  

process_binary_images(input_folder, output_folder, image_shape)
