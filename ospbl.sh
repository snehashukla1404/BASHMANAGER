#!/bin/bash

# Function to process images
process_image() {
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <input_image>"
        exit 1
    fi
    input_image="$1"

    # Check if input file exists
    if [ ! -f "$input_image" ]; then
        echo "Input image $input_image not found!"
        exit 1
    fi

    # Perform image processing
    output_image="processed_$input_image"

    # Example processing: Convert to grayscale
    convert "$input_image" -colorspace Gray "$output_image"

    # Check if processing is successful
    if [ $? -eq 0 ]; then
        echo "Processing successful. Output file: $output_image"
    else
        echo "Processing failed!"
        exit 1
    fi
}

# Function to check syntax of a shell script
check_syntax() {
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <shell_script>"
        exit 1
    fi
    im="$1"
    if [ -f "$im" ]; then
        echo "Checking syntax of $im ..."
        shellcheck "$im"
        echo "Completed."
    else
        echo "Error: $im not found."
        exit 1
    fi
}

# Function to extract compressed files
extract_compressed() {
# Check if the required argument is provid ed
    if [ $# -ne 1 ]; then
       echo "Usage: $0 <compressed_file>"
        exit 1
    fi

    # Assign argument to variable
    compressed_file="$1"

    # Check if input file exists
    if [ ! -f "$compressed_file" ]; then
        echo "Compressed file $compressed_file not found!"
        exit 1
    fi
echo "hi"
    # Extract compressed file based on extension
    # Extract compressed file based on extension
    if [ "${compressed_file##*.}" = "zip" ]; then
        unzip "$compressed_file"
    elif [ "${compressed_file##*.}" = "rar" ]; then
        unrar x "$compressed_file"
    else
        echo "Unsupported compression format."
        exit 1
    fi
    # Check if extraction is successful
    if [ $? -eq 0 ]; then
        echo "Extraction successful."
    else
        echo "Extraction failed!"
        exit 1
    fi
}

# Function to convert files using ffmpeg
convert_file() {
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <input_file> <output_format>"
        exit 1
    fi
    input_file="$1"
    output_format="$2"

    # Check if input file exists
    if [ ! -f "$input_file" ]; then
        echo "Input file $input_file not found!"
        exit 1
    fi

    # Extract filename without extension
    filename=$(basename -- "$input_file")
    filename_no_ext="${filename%.*}"

    # Perform conversion
    output_file="${filename_no_ext}.${output_format}"
    ffmpeg -i "$input_file" "$output_file"

    # Check if conversion is successful
    if [ $? -eq 0 ]; then
        echo "Conversion successful. Output file: $output_file"
    else
        echo "Conversion failed!"
        exit 1
    fi
}

# Main menu
while true; do
    echo "===== MENU ====="
    echo "1. Process Image"
    echo "2. Check Syntax of Shell Script"
    echo "3. Extract Compressed File"
    echo "4. Convert File using FFmpeg"
    echo "5. Exit"
    read -p "Enter your choice: " choice
    case $choice in
        1)  read -p "Enter input image path: " input_image
            process_image "$input_image"
            ;;
        2)  read -p "Enter shell script path: " shell_script
            check_syntax "$shell_script"
            ;;
        3)  read -p "Enter compressed file path: " compressed_file
            extract_compressed "$compressed_file"
            ;;
        4)  read -p "Enter input file path: " input_file
            read -p "Enter output format: " output_format
            convert_file "$input_file" "$output_format"
            ;;
        5)  echo "Exiting..."
            exit 0
            ;;
        *)  echo "Invalid choice. Please enter a number between 1 and 5."
            ;;
    esac
done
