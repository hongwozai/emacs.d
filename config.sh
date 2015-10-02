#!/bin/bash

# ============== control flow ============
# emacs multi-term ch
if [ -f ~/.zshrc ]; then
    emacs_term_chpwd "~/.zshrc"
fi
if [ -f ~/.bashrc ]; then
    emacs_term_chpwd "~/.bashrc"
fi
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
