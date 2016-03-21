#!/bin/bash

# ============== function =================
# emacs term chpwd
function emacs_term_chpwd()
{
    cat <<EOF >> $1
if [ -n "$INSIDE_EMACS" ]; then
    chpwd() { print -P "\033AnSiTc %d" }
    print -P "\033AnSiTu %n"
    print -P "\033AnSiTc %d"
fi
EOF
}

function em_sudo() {
    emacsclient -nw -a "" -c /sudo:root@localhost:$1
}

function em_alias() {
    cat <<EOF >> $1
alias em='emacsclient -nw -a "" -c'
alias emsudo='em_sudo'
EOF
}

# ============== control flow ============
# emacs multi-term ch only zsh
if [ -f ~/.zshrc ]; then
    emacs_term_chpwd "~/.zshrc"
fi

if [ -f ~/.bashrc ]; then
    em_alias "~/.bashrc"
fi
