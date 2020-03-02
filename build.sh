#!/bin/bash

mkdir -p download

for VERSION in $(cat versions.txt); do
	wget https://github.com/neovim/neovim/archive/v${VERSION}.zip -O download/v${VERSION}.zip
done

mkdir -p source

for FILE in $(ls download/v*.zip); do
	unzip -q -d source ${FILE}
done

# Remove all sub-project .gitignore files, keeps status quiet.
rm $(find source/. | grep \.gitignore)

for NVIM_DIR in $(ls source); do
	pushd source/${NVIM_DIR} > /dev/null

	PATCH_DIR="../../patch/${NVIM_DIR}"
	if [ -d ${PATCH_DIR} ]; then
		for PATCH in $(ls ${PATCH_DIR}); do
			echo "Applying Patch: ${PATCH}"
			patch -p1 < ${PATCH_DIR}/${PATCH}
		done
	fi

	make CMAKE_BUILD_TYPE=RelWithDebInfo > /dev/null 2>&1
	RESULT=$?
	echo "Build Status ${NVIM_DIR}: ${RESULT}"
	popd > /dev/null
done
