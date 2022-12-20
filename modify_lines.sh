#!/bin/bash

# Set the file to operate on
file="./input.txt"

# Set the percentage of lines to modify
modify_percent=5

# Calculate the number of lines to modify based on the total number of lines
total_lines=$(wc -l < "$file")
lines_to_modify=$((total_lines * modify_percent / 100))

# Use a loop to iterate over each line in the file
while read -r line; do
  # Generate a random number between 1 and 100
  rand=$((1 + $RANDOM % 100))

  # If the random number is less than or equal to the modify percentage, apply a modification to the line
  if [ $rand -le $modify_percent ]; then
    # Generate a random number between 1 and 3 to determine which modification to apply
    modification=$((1 + $RANDOM % 3))
    case $modification in
      1)
        # Add a new line with random content
        # Split the current line into tokens using the space character as the delimiter
        IFS=' ' read -ra current_tokens <<< "$line"
        # Read the next line
        read -r next_line
        # Split the next line into tokens using the space character as the delimiter
        IFS=' ' read -ra next_tokens <<< "$next_line"
        # Concatenate the two sets of tokens
        all_tokens=("${current_tokens[@]}" "${next_tokens[@]}")
        # Use the `shuf` command to shuffle the tokens
        shuffled_tokens=$(printf '%s\n' "${all_tokens[@]}" | shuf)
        # Pick a random number of tokens (between 1 and the total number of tokens) to include in the new line
        num_tokens=$((1 + $RANDOM % ${#all_tokens[@]}))
        # Use the `head` command to select the first `num_tokens` tokens
        new_line_tokens=$(printf '%s\n' "${shuffled_tokens[@]}" | head -n "$num_tokens")
        # Insert the new line after the current line
        sed -i "${!}a\\$new_line_tokens" "$file"
        ;;
      2)
        # Remove the current line
        sed -i "${!}d" "$file"
        ;;
      3)
        # Shuffle the tokens on the current line
        # Split the line into tokens using the space character as the delimiter
        IFS=' ' read -ra tokens <<< "$line"
        # Use the `shuf` command to shuffle the tokens
        shuffled_tokens=$(printf '%s\n' "${tokens[@]}" | shuf)
        # Replace the current line with the shuffled version
        sed -i "${!}s/.*/$shuffled_tokens/" "$file"
        ;;
    esac
  fi
done < "$file"
