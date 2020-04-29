# trackup

### Description
Keeps track of files that you want to backup. It does so by storing their path, so that it easily can be retrieved at a later point. Also has the ability to check the validity of the paths, and also to remove any path that is no longer valid.

### Usage
````
trackup.sh -hlsarc <ARGUMENT>
````
  
### Examples
  - Clean all non-valid paths and display all tracked paths after this operation:
  ````
    trackup.sh -cl
  ````
  - Add a new file to be tracked:
  ````
    trackup.sh -a somefile
  ````
    
### Options

  `-h, --help`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;displays the help section  
  `-l, --list`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;prints all stored paths to stdout  
  `-s, --status`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;checks the validity of each stored path  
  `-a, --add <PATH>`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;add a new file to be tracked  
  `-r, --remove <PATH>`&nbsp;&nbsp;removes a previously tracked file  
  `-c, --clean`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;will remove any stored path that is not valid  
  
    * Note that combined short options are allowed: "-cl" will be
      interpreted the same way as "--clean --list".
      
### Todo
* Handle how symlinks are handled
