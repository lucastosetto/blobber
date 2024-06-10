#!/bin/bash

# Function to show usage
usage() {
  echo "Usage: $0 --source=path/to/source --dest=my-bucket/path/to/dest"
  exit 1
}

# Check arguments
if [ $# -ne 2 ]; then
  usage
fi

# Parse arguments
for i in "$@"; do
  case $i in
    --source=*)
      SOURCE="${i#*=}"
      shift
      ;;
    --dest=*)
      DEST="${i#*=}"
      shift
      ;;
    *)
      usage
      ;;
  esac
done

# Check if source and destination are provided
if [ -z "$SOURCE" ] || [ -z "$DEST" ]; then
  usage
fi

# Upload the file
mc cp $SOURCE myminio/$DEST
