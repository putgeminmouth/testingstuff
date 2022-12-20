#!/bin/bash

# Set the input file
input_file="$1"

# Create a temporary file
tmp_file=$(mktemp)

# Set the IFS variable to an empty string
IFS=''

# Read the input file line by line
while read -r line; do
  # Check if the line is non-empty
  if [ -n "$line" ]; then
    # Generate a random number between 0 and 99
    rnd=$((RANDOM % 100))
    # Check if the random number is less than or equal to 5
    if [ "$rnd" -le 5 ]; then
      # Generate a random number between 1 and 3
      rnd=$((RANDOM % 3))
      # Apply the operation based on the random number
      if [ "$rnd" -eq 0 ]; then
        # Combine the current line and the next line using the paste command
        combined_line=$(paste -d' ' <(echo "$line") <(read -r next_line && echo "$next_line"))
        # Extract a few words from the combined line using the cut command
        few_words=$(echo "$combined_line" | cut -d' ' -f1-3)
        # Shuffle the few words using the shuf command
        shuffled_words=$(echo "$few_words" | shuf)
        # Add the shuffled words to the end of the file
        echo "$shuffled_words" >> "$tmp_file"
      elif [ "$rnd" -eq 1 ]; then
        # Skip the line
        continue
      else
        # Extract the leading whitespace and indentation from the line
        leading_whitespace=$(echo "$line" | sed -E 's/^([[:blank:]]*).*$/\1/')

        # Shuffle the tokens on the line
        shuffled_tokens=$(echo "$line" | tr ' ' '\n' | shuf | tr '\n' ' ')
        # Write the shuffled tokens to the temporary file
        echo "$leading_whitespace$shuffled_tokens" >> "$tmp_file"
      fi
    else
      # Write the original line to the temporary file
      echo "$line" >> "$tmp_file"
    fi
  fi
done < "$input_file"

# Replace the original file with the temporary file
mv "$tmp_file" "$input_file"
