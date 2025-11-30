#!/bin/bash

# Convert all Windows paths in Unity .csproj files to WSL/Linux paths
find . -name '*.csproj' | while read -r f; do
  # Replace Windows-style paths like D:\something\else or C:\Users\me\Documents
  sed -E -i '
    s|([A-Z]):\\|/mnt/\L\1/|g;     # convert drive letter (C: -> /mnt/c/)
    s|\\|/|g;                      # convert backslashes to forward slashes
  ' "$f"
done
