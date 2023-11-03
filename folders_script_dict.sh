#!/usr/bin/env bash
if [[ "$#" == 0 ]]; then
	echo "Error! Please provide an existing folder as an argument. E.g. './folders_script.sh new_folder'" >&2
	exit 1
fi
if [[ ! -d "$1" ]]; then
	echo "Error! The provided argument is not an existing folder" >&2
	exit 2
fi
initial_path="$(pwd)"
declare -A ext_dict
function recursive_find () {
	cd "$1"
	found_files="$(find . -maxdepth 1 -type f | sed 's|^./||')"
	if [[ $found_files ]]; then
		while read line; do
			ext="$(grep -oE '(\.?[^.]+)$' <<< "$line")"
			if [[ ! $ext_dict["$ext"] ]]; then
				((ext_dict["$ext"]=1))
			else
				((ext_dict["$ext"]+=1))
			fi
		done <<< "$found_files"
	fi
	folders="$(find "$(pwd)" -mindepth 1 -maxdepth 1 -type d)"
	if [[ $folders ]]; then
		while read line; do
			recursive_find "$line"
		done <<< "$folders"
	else
		return 0;
	fi
	return 0
}
recursive_find "$1"
cd "$initial_path"
ext_dict_len="${#ext_dict[@]}"
if (( $ext_dict_len == 0 )); then
	echo "Error! '$1' folder doesn't contain any files" >&2
	exit 3
elif (( $ext_dict_len == 1 )); then
	echo "Warning! There is only one file format in '$1' folder:"
elif (( $ext_dict_len < 5 )); then
	echo "Warning! There are less than 5 file formats in '$1' folder"
	echo "Top ${#ext_dict[@]} file formats in '$1' folder:"
else
	echo "Top 5 file formats in '$1' folder:"
fi
for ext in "${!ext_dict[@]}"; do
	echo -e "$ext\t${ext_dict[$ext]}"
done | sort -rn -k2 > all_formats.txt
head -5 all_formats.txt && rm all_formats.txt
exit 0
