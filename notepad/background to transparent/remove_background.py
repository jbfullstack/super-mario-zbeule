import cv2
import numpy as np
from PIL import Image
import os

def remove_background_with_color(image_path, output_path, background_color=(255, 0, 255)):
    b, g, r = background_color
    image = cv2.imread(image_path, cv2.IMREAD_UNCHANGED)

    if image.shape[2] < 4:
        print(f"Skipping {image_path}: No alpha channel found.")
        return

    # Convert to RGBA
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGBA)
    h, w, _ = image.shape

    # Create a mask for the background color
    lower_bound = np.array([b - 10, g - 10, r - 10, 0])  # Adjust tolerance
    upper_bound = np.array([b + 10, g + 10, r + 10, 255])

    background_mask = cv2.inRange(image, lower_bound, upper_bound)

    # Set the alpha channel of the masked background to 0 (fully transparent)
    for i in range(h):
        for j in range(w):
            if background_mask[i, j] > 0:
                image[i, j, 3] = 0

    # Save the image
    Image.fromarray(image).save(output_path)

def process_folder(input_folder, output_folder, background_color=(255, 0, 255)):
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    for filename in os.listdir(input_folder):
        if filename.lower().endswith('.png'):
            input_path = os.path.join(input_folder, filename)
            output_path = os.path.join(output_folder, filename)
            remove_background_with_color(input_path, output_path, background_color)

if __name__ == "__main__":
    input_folder = "./from"  # Replace with your folder containing PNGs
    output_folder = "./to"  # Replace with your output folder
    background_color = (255, 0, 255)  # Pink background to be removed

    process_folder(input_folder, output_folder, background_color)
    print("All images processed!")
