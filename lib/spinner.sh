#!/usr/bin/env bash
#
# spinner.sh
#
###############################################################################
# Handles console feedback
###############################################################################

# Progress spinner
function spinner() {
  if [[ "${verbose}" -ne "1" && "${debug}" -ne "1" ]]; then
    local pid=$1
    local delay=0.15
    local spinstr='|/-\'
    tput civis;
    while [[ "$(ps a | awk '{print $1}' | grep ${pid})" ]]; do
      local temp=${spinstr#?}
      printf "Working... %c  " "$spinstr"
      local spinstr=$temp${spinstr%"$temp"}
      sleep $delay
      printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    done
    printf "            \b\b\b\b\b\b\b\b\b\b\b\b"
    tput cnorm;
  fi
}
