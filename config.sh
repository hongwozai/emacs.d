#!/bin/bash

# pyim dict
function dictionary_setup() {
    echo "Download pyim dict"
    wget -O ~/Downloads/pyimdict.zip \
         https://github.com/tumashu/chinese-pyim-bigdict/archive/gh-pages.zip

    echo "unzip and copy ..."
    mkdir -p ~/.eim
    unzip ~/Downloads/pyimdict.zip -d ~/.eim
    gzip -d ~/.eim/chinese-pyim-bigdict-gh-pages/pyim-bigdict.pyim.gz
    mv ~/.eim/chinese-pyim-bigdict-gh-pages/pyim-bigdict.pyim \
       ~/.eim/dict.pyim
    rmdir ~/.eim/chinese-pyim-bigdict-gh-pages
    echo "pyim dict finished."
}

function exec_setup() {
    echo "setup em..."
    if ! [ -f /usr/bin/em ]; then
        cat <<EOF > /usr/bin/em
#!/bin/bash
env LANG='zh_CN.UTF8' emacsclient -nw -a "" -c $1
EOF
    else
        echo "em exists."
    fi
    echo "em setup finished."
}

# setup
dictionary_setup
exec_setup