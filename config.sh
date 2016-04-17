#!/bin/bash

# pyim dict
function dictionary_setup() {
    echo "Download pyim dict"
    wget -O ~/Downloads/pyimdict.zip \
         https://github.com/tumashu/chinese-pyim-bigdict/archive/gh-pages.zip

    echo "unzip and copy ..."
    mkdir -p ~/.eim
    unzip ~/Downloads/pyimdict.zip -d ~/.eim
    mv ~/.eim/chinese-pyim-bigdict-gh-pages/pyim-bigdict.pyim \
       ~/.eim/pyim-bigdict.pyim
    rmdir ~/.eim/chinese-pyim-bigdict-gh-pages
    echo "pyim dict finished."
}


# setup
dictionary_setup