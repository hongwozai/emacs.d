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
# ============== control flow ============
# emacs multi-term ch only zsh
if [ -f ~/.zshrc ]; then
    emacs_term_chpwd "~/.zshrc"
fi
