#!/bin/bash

# Set the output file
# Generate a random filename using words from the system dictionary file
num_words=$((1 + RANDOM % 4)) # Number of words to use in the filename (random between 1 and 4)
filename="" # Initialize the filename
dict=$(mktemp)
cat /usr/share/dict/words | shuf > $dict

# Choose a random line from the dictionary file
while read -r line; do
  # Check if the line is non-empty and has the required number of characters
  if [ -n "$line" ] && [ "${#line}" -ge 4 ] && [ "${#line}" -le 8 ]; then
    # Append the word to the filename
    if [ -n "$filename" ]; then
      # Add an underscore if the filename is not empty
      filename="$filename"_
    fi
    filename="$filename$line"
    # Decrement the counter
    num_words=$((num_words - 1))
    # Break if the required number of words has been reached
    if [ "$num_words" -eq 0 ]; then
      break
    fi
  fi
done < $dict

# Set the output file
output_file="./$filename.txt"

# Create an empty array to store the lengths of the input files
lengths=()

# Calculate the average length of the input files
for file in ./*; do
  # Check if the file is a regular file (skip directories and other special files)
  if [ -f "$file" ]; then
    # Calculate the length of the file (number of lines)
    length=$(wc -l < "$file")
    # Add the length to the array
    lengths+=("$length")
  fi
done

# Calculate the average length
num_files=${#lengths[@]}
total_length=0
for length in "${lengths[@]}"; do
  total_length=$((total_length + length))
done
average_length=$((total_length / num_files))

# Create a temporary file using `mktemp`
temp_file=$(mktemp)

# Concatenate all the input files into the temporary file
cat ./* > "$temp_file"

# Shuffle the lines using the `shuf` command
shuffled_lines=$(shuf "$temp_file")

# Retain the first `average_length` lines
selected_lines=$(printf '%s\n' "$shuffled_lines" | head -n "$average_length")

# Write the selected lines to the output file
echo "$selected_lines" > "$output_file"

# Remove the temporary file
rm "$temp_file"

