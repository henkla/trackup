# trackup

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

### Description
Keeps track of files that you want to backup. It does so by storing their path, so that it easily can be retrieved at a later point. Also has the ability to check the validity of the paths, and also to remove any path that is no longer valid.

### Installation
1. Put the script file in location of choice. I use `~/.local/bin`:
````
$ mkdir -p ~/.local/bin && mv /path/to/trackup.sh ~/.local/bin
````

2. Make sure it is executable:
````
$ chmod u+x ~/.local/bin/trackup.sh
````

3. (Optional) Put location in `PATH` variable:
````
$ export PATH="$HOME/.local/bin:$PATH"
````

4. (Optional) Create an alias for the script:
````
$ echo "alias trackup='trackup.sh'"
````

### Usage
````
trackup.sh [-hlsc][-ar arg]
````
  
### Examples
Clean all non-valid paths and display all tracked paths after this operation:
````
  $ trackup.sh -cl
  Cleaned out 1 entry
  /path/to/somefile /path/to/someotherfile /another/path/to/somefile /just/a/file
````
Add a new file to be tracked:
````
  $ trackup.sh -a somefile
  [+] "/path/to/somefile"
````
    
### Options

  `-h, --help`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;displays the help section  
  `-l, --list`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;prints all stored paths to stdout  
  `-s, --status`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;checks the validity of each stored path  
  `-a, --add <PATH>`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;add a new file to be tracked  
  `-r, --remove <PATH>`&nbsp;&nbsp;removes a previously tracked file  
  `-c, --clean`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;will remove any stored path that is not valid  
  
### Good to know 💡
In compliance with [POSIX standards](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html), combined short options are allowed: `-cl` will be interpreted the same way as `--clean --list`.

The commands will be performed in a fixed order, no matter which order you enter them:
1. Show help (and then exit)
2. List file status
3. Clean tracked files
4. List files
5. Add files
6. Remove files

### Todo
* Handle how symlinks are handled
