# trackup
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


## Table of Contents
- [trackup](#trackup)
  * [Description](#description)
  * [Getting started](#getting-started)
  * [How to use it](#how-to-use-it)
  * [Examples with explanation](#examples-with-explanation)
  * [Available options](#available-options)
  * [Todo](#todo)
---

## Description

Keeps track of files that you want to backup. It does so by storing their path, so that it easily can be retrieved at a later point. Also has the ability to check the validity of the paths, and also to remove any path that is no longer valid.

The script is intended to use as an assistance when backing up system and/or application files, by piping the output of the list option (`trackup.sh --list`) to a backup application or solution of choice.

*All tracked files will be stored in a plain text file at location `~/.local/bin/trackup.sh.list`. It is this file that the script operates on.*

## Getting started

This is an example of how to setup and use the script. Do note that it is nothing more than a script and that there are several ways to set things up. 

##### Put the script file in location of choice. I use `~/.local/bin`:
````
$ mkdir -p ~/.local/bin && mv /path/to/trackup.sh ~/.local/bin
````

##### Make sure it is executable:
````
$ chmod u+x ~/.local/bin/trackup.sh
````

##### (*Optional*) Put location in `PATH` variable:
````
$ export PATH="$HOME/.local/bin:$PATH"
````

##### (*Optional*) Create an alias for the script:
````
$ echo "alias trackup='trackup.sh'" >> ~/.bashrc
````

## How to use it

This is how the script is used:
````
trackup.sh [-hlsc][-ar arg]
````

## Examples with explanation

Following are some usage examples with corresponding output. They demonstrate several cases that may occur using this script, such as a adding file to be tracked, checking tracking status, performing a clean up and also how to list files that are being tracked.

##### Show current tracking status:
````
  $ trackup.sh --status
  [+] "/just/a/file"
````
*Only one file is being tracked.*

##### Add some new files to be tracked:
````
  $ trackup.sh --add somefile --add someotherfile
  [+] "/path/to/somefile" 
  [+] "/path/to/someotherfile" 
````
*Two files were being added for tracking. **Note:** It is possible add relative paths - the script will figure outer the absolute paths.*

##### Show current tracking status (after a file has been removed):
````
  $ rm /path/to/somefile
  $ trackup.sh --status
  [ ] "/path/to/somefile" 
  [+] "/path/to/someotherfile" 
  [+] "/just/a/file"
````
*One file that are being tracked was removed. The `--status` option will show that this is the case.*

##### Clean all non-valid paths and display all tracked paths after this operation:
````
  $ trackup.sh -cl
  Cleaned out 1 entry
  /path/to/someotherfile /just/a/file
````
*The script performed a cleanup of all files that no longer exists. After that, the remaining tracked files were displayed as a string of paths separated by a space.*

##### Copy all tracked files to another location:
````
  $ mkdir -p ~/tmp/test
  $ cp $(trackup.sh --list) /tmp/test/
  $ ls /tmp/test
  file    someotherfile
````
*For the sake of this example, a temporary directory is created, in which all tracked files are copied to, combining the `cp` command and `--list` option. The `ls` command shows the files actually being there.*


## Available options

  The script takes a number of different options. In compliance with [POSIX standards](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html), combined short options are allowed. For instance, `-cl` will be interpreted the same way as `--clean --list`. Furthermore, the commands will be performed in a fixed order, no matter which order you enter them:
  1. Show help (and then exit)
  2. List file status
  3. Clean tracked files
  4. List files
  5. Add files
  6. Remove files

*In other words: `--list --clean` will be handled as if you entered `--clean --list`.* 

##### Below is a list of all available commands:
  `-h, --help`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;displays the help section  
  `-l, --list`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;prints all stored paths to stdout  
  `-s, --status`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;checks the validity of each stored path  
  `-a, --add <PATH>`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;add a new file to be tracked  
  `-r, --remove <PATH>`&nbsp;&nbsp;removes a previously tracked file  
  `-c, --clean`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;will remove any stored path that is not valid  


## Todo
* Handle how symlinks are handled
* Handle wildcards (add all files in folder)
* Add verbose mode
* make script POSIX compliant and not reliant on bash
