#!/usr/bin/env bash
# 
# process_gender.sh
#
###############################################################################
# Process for female or male names
###############################################################################

function process_gender() {
  if [[ "${other}" != "1" ]]; then
    arr=()
    while IFS= read -r line; do
      arr+=("${line}")
      line=$(echo $line | sed -e 's/\r//g')

      # Set search value based on CSV format; not in use as of yet
      # set_search_value 
      
      if [[ "${verbose}" == "1" ]]; then
        grep -o "${line} " "${input_file}"
      fi
      grep -hr "${line} " "${input_file}" >> "${output_file}"
    done < data/${label}.csv
  else   
    # Setup output file
    cp "${input_file}" "${output_file}"

    # Loop through all the things and remove "known" genders
    process_other female
    process_other male
  fi
}

function process_other() {
  # Loop through female names
  arr=()
  while IFS= read -r line; do
    arr+=("${line}")
    line=$(echo $line | sed -e 's/\r//g')
    if [[ "${verbose}" == "1" ]]; then
      grep -o "${line} " "${input_file}"
    fi
    sed -i "/${line} /d" "${output_file}"
  done < data/${1}.csv
}

# This is not in use as of yet
function set_search_value() {
  if [[ "${format}" == "merged" ]]; then
    line=$(echo "${line} ")
  elif [[ "${format}" == "quoted" ]]; then
    line=$(echo '\"${line}\"')
  elif [[ "${format}" == "quoted=merged" ]]; then
    line=$(echo '\"${line} ')
  fi
}
