#!/bin/bash

echo "The following directories will be deleted..."
echo "  ./download/*"
echo "  ./source/*"

read -r -p "Are you sure? [y/N] " RESPONSE

case "${RESPONSE}" in
    [yY][eE][sS]|[yY]) 
		rm -rf download source
        ;;
esac
