#!/bin/bash

# Function to show usage
usage() {
  echo "Usage: $0 --name=bucket-name"
  exit 1
}

# Check arguments
if [ $# -ne 1 ]; then
  usage
fi

# Parse arguments
for i in "$@"; do
  case $i in
    --name=*)
      BUCKET_NAME="${i#*=}"
      shift
      ;;
    *)
      usage
      ;;
  esac
done

# Check if bucket name is provided
if [ -z "$BUCKET_NAME" ]; then
  usage
fi

# Create the bucket
mc mb myminio/$BUCKET_NAME
