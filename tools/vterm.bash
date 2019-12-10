#!/bin/bash

# 需要将这些放入.bashrc中才行，不能直接执行(变量无法导出到父进程中)
# ===========
vterm_prompt_end() {
    printf "\e]51;A$(whoami)@$(hostname):$(pwd)\e\\"
}

export PS1=$PS1'$(vterm_prompt_end)'

# ============
vterm_cmd() {
    printf "\e]51;E"
    while [ $# -gt 0 ]; do
        printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')"
        shift
    done
    printf "\e\\"
}

em() {
    vterm_cmd find-file "$(realpath " $@ ")"
}

say() {
    vterm_cmd message "%s" "$*"
}

export -f vterm_cmd
export -f em
export -f say

