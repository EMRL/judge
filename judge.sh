#!/usr/bin/env bash
#
# judge.sh
#
###############################################################################
# A shell script designed to process and segment rows of data by best guessing 
# gender.
#
# https://github.com/EMRL/judge
###############################################################################

version="0.1.0"

# Configuration
lib_path="lib"
data_path="data"
format="merged-quoted"

printf "\njudge ${version}\n"
# Display command options
function flags() {
  echo -n "Usage: judge [options] [target] ...

Options:
  -f, --female           Detect names that are best-guess female
  -m, --male             Detect names that are best-guess male
  -o, --other            Detect names that appear to be neither female or male
  -M, --merged           First and last name are in the same field
  -q, --quoted           First name is quoted
  -Q, --quoted-merged    First and last name are quoted in the same field
  -v, --verbose          Display verbose output
  -d. --debug            Display debug output
  -h, --help             Display this help and exit
"
  echo -n "
More information at https://github.com/EMRL/judge
"
}

# If no arguments are passed, display help
[[ $# == "0" ]] && set -- "--help"

# Grab options and parse their format
option_string=h
unset options
while (($#)); do
  case $1 in
    -[!-]?*)
      for ((i=1; i < ${#1}; i++)); do
        c=${1:i:1}
        options+=("-$c")
        if [[ ${option_string} = *"$c:"* && ${1:i+1} ]]; then
          options+=("${1:i+1}")
          break
        fi
      done
      ;;
    --?*=*) options+=("${1%%=*}" "${1#*=}") ;;
    --) options+=(--endopts) ;;
    *) options+=("$1") ;;
  esac
  shift
done
set -- "${options[@]}"
unset options

# Read the options
while [[ ${1:-unset} = -?* ]]; do
  case $1 in
    -h|--help) flags >&2; exit ;;
    -f|--female) female="1"; label="female" ;;
    -m|--male) male="1"; label="male" ;;
    -o|--other) other="1"; label="unknown" ;;
    -M|--merged) format="merged" ;;
    -q|--quoted) format="quoted" ;;
    -Q|--quoted-merged) format="quoted-merged" ;;
    -v|--verbose) verbose="1" ;;
    -d|--debug) set -x ;;
    --endopts) shift; break ;;
    *) echo "Invalid option: '$1'" 1>&2 ; exit 1 ;;
  esac
  shift
done

# Input file
input_file=("${@}")

# Output file
output_file="${label}-${input_file}"

# Check input_file file exists and is readable
if [[ -r "${input_file}" && -f "${input_file}" ]]; then
  line_count="$(wc -l < ${input_file})"
  echo "Reading ${line_count} lines from ${input_file}"
else
  echo "Fatal: ${input_file} does not exist or is not a readable file"
  exit 1
fi

# Clean up old output file if it exists
if [[ -r "${output_file}" && -f "${output_file}" ]]; then
  # TODO: Ask user if this is okay
  rm "${output_file}"
elif [[ -f "${output_file}" ]]; then
  echo "Fatal: ${output_file} exists"
  exit 12
fi

# You can't do more than one thing at a time
if [[ "${female}" == "1" ]] && [[ "${male}" == "1" || "${other}" == "1" ]]; then 
  too_many_switches="1"
elif [[ "${male}" == "1" ]] && [[ "${female}" == "1" || "${other}" == "1" ]]; then 
  too_many_switches="1"
fi

if [[ "${too_many_switches}" == "1" ]]; then
  echo "Fatal: Too many switches"
  exit 3
fi

# But you have to do something
if [[ -z "${label}" ]]; then
  echo "Fatal: You must choose to parse female, male, or other"
  exit 4
fi

# Load external functions 
if [ -d "${lib_path}" ] ; then
  . "${lib_path}/yes-no.sh"
  . "${lib_path}/process_gender.sh"
  . "${lib_path}/spinner.sh"
else 
  echo "Fatal: Unable to load libraries"
  exit 13
fi

# Create output file
touch "${output_file}"

# Finally
echo "Exporting data rows identified as ${label} to ${output_file}"
echo "Using ${format} format"
if yes_no --default yes "Begin processing now? [Y/n] "; then
  process_gender &
  spinner $!
fi

# Check output_file file exists and is readable
if [[ -r "${input_file}" && -f "${output_file}" ]]; then
  line_count="$(wc -l < ${output_file})"
  if [[ "${line_count}" -gt "0" ]]; then
    echo "Saved ${line_count} lines to ${output_file}"
  else
    echo "No ${label} matches found"
    rm "${output_file}"
  fi
else
  echo "Fatal: ${input_file} does not exist or is not a readable file"
  exit 1
fi

exit 0
