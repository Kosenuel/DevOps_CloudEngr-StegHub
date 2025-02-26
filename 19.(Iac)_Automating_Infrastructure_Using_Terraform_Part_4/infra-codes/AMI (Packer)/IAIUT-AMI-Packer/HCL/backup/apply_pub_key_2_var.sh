#!/bin/bash

# Path to the variable file to be searched and modified
input_file="variables.pkrvar.hcl"

# Path to the file containing the replacement string
replacement_file="output/Ansible_key.pub" 

# Read the replacement content from the replacement file
replacement_content=$(cat "$replacement_file")

# Use sed to search for the pattern and replace it with the replacement content
sed -i.bak -e "/ssh-rsa.*internal/c bastion_public_key     = \"$replacement_content\"" "$input_file"
