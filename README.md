## Top Five Formats script

### Description

This is a script for counting top five most frequent file formats in a folder.
It recursively goes through all the folders and searches for files inside them.
The script prints a message to StdOut in the following format, when there are 5 or more formats available in the provided folder:
````
Top 5 file formats in 'new_folder/' folder:
.java   5
.txt    4
.docx   3
.py     2
.md     2
````
The file formats go in descending order from most spread to less spread.
When several file formats have the same number of occurrences in the folder, they would be outputted in the arbitrary order.
A warning will appear if there are less than 5 file formats in a folder, and the output would be like this:
````
Warning! There are less than 5 file formats in 'equal_4/' folder
Top 4 file formats in 'equal_4/' folder:
.txt    2
.png    1
.jpg    1
.bin    1
````
When script finds only one file extension, a warning will also appear, but the output would be slightly different, than in the other cases:
````
Warning! There is only one file format in '1_format/' folder:
.txt    1
````
The filenames without extension would be treated as an extension, e.g.
````
Top 5 file formats in 'without_ext/' folder:
Makefile        6
.java   5
.txt    4
.docx   3
.py     2
````
The script searches in hidden folders and for hidden files which names start with period, for example:
````
.new_folder
.new_text.txt
````

### Usage
To run the script a valid existing folder should be provided as first argument. E.g.
````
./folders_script.sh new_folder/
````
An error message would be printed to StdErr, if user provided no argument for the script:
````
./folders_script.sh
Error! No argument specified! Please provide an existing folder as an argument. E.g. './folders_script.sh new_folder'
````
The script takes exactly one argument at input, the following error would be printed if user provides two or more arguments:
````
Error! Too many arguments! Please provide only one argument for the script. E.g., './folders_script.sh new_folder'
````
Also, the argument should be an existing folder **(not a file!)** in the filesystem. Absolute and relative paths are both supported.
The following error message would appear, if the argument is a file or non-existing entity:
````
./folders_script.sh 123
Error! Wrong argument! Please provide an existing folder as an argument. E.g., './folders_script.sh new_folder'
````
