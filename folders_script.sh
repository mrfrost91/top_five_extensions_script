#!/usr/bin/env bash
if (( $# == 0 )); then
	echo "Error! No argument specified! Please provide an existing folder as an argument. E.g. './folders_script.sh new_folder'" >&2
	exit 1
elif (( $# > 1 )); then
	echo "Error! Too many arguments! Please provide only one argument for the script. E.g., './folders_script.sh new_folder'" >&2
	exit 2
fi
if [[ ! -d "$1" ]]; then
	echo "Error! Wrong argument! Please provide an existing folder as an argument. E.g., './folders_script.sh new_folder'" >&2
	exit 3
fi
initial_path="$(pwd)"
ext_list=""
function recursive_find () {
	cd "$1" || return 1
	found_files="$(find . -maxdepth 1 -type f | sed 's|^./||')"
	if [[ $found_files ]]; then
		while read -r line; do
			ext="$(grep -oE '(\.?[^.]+)$' <<< "$line")"
			ext_list+="$ext\n"
		done <<< "$found_files"
	fi
	folders="$(find "$(pwd)" -mindepth 1 -maxdepth 1 -type d)"
	if [[ $folders ]]; then
		while read -r line; do
			recursive_find "$line"
		done <<< "$folders"
	else
		return 0;
	fi
	return 0
}
recursive_find "$1"
cd "$initial_path" || exit 4
if [[ ! $ext_list ]]; then
	echo "Error! '$1' folder doesn't contain any files" >&2
	exit 5
elif [[ $ext_list ]]; then
	ext_list="${ext_list::-2}"
fi
ext_list_len="$(echo -e "$ext_list" | sort | uniq | wc -l)"
if (( ext_list_len == 1 )); then
	echo "Warning! There is only one file format in '$1' folder:"
elif (( ext_list_len < 5 )); then
	echo "Warning! There are less than 5 file formats in '$1' folder"
	echo "Top $ext_list_len file formats in '$1' folder:"
else
	echo "Top 5 file formats in '$1' folder:"
fi
echo -e "$ext_list" | awk '{a[$0]++}END{for(i in a){print i,"\t"a[i]}}' | sort -rn -k2 | head -5
exit 0
