# Linux - Chmod & Chown
### Introduction

__This doument would help you explore the various facets of these two linux commands: chown & chmod, to understand better how they can be used for maintaining access control and data security. Now without further ado, let's begin shall we?__

## File Permissions

In Linux, each file and directory has some defined permissions that dictates whaat actions - whether read (4), write (2), or execute (1), can be performed on the file. These permissions are assigned to three (3) categories of users in the linux environment:
- __Owner/user (u):__ The user who owns (or created) the file or directory.
- __Group (g):__ This is the group that is tied to the file or directory. This helps with stipulating and making a file accessible to other users (belonging to the same group) who do not own or have access to the file.
- __Others (o):__ This refers to all/any other user in the system.

__Types of permissions:__
- __Read (r or 4):__ This permission allows for the viewing of the contents a file or directory holds.
- __Write (w or 2):__ This permission allows for the modification and or deletion of files, contents of files and or directories.
- __Execute (e or 1):__ This permission allows for the execution/running of a file or in the case of directories, accessing the contentsof that directory.

### The chmod commad
 __Chmod__ means 'Change mode' and is used to modify the access level or permissions of a file or direcctory.
 
 Usage:
 ```
 chmod [options] mode <filename or directoryname>
 ```

 __Arguments:__
 
 __1.__ __options:__ These are flags that tells `chmod` what to do. some of these flags/options are:
 - __-R:__ This option recursively apaplies/modifies permissions of directories and their contents.
 - __-v:__ This flag tells `chmod` to display verbose informations on the changes being made to a file or directory in real time.
 - __-c:__ This flag tells `chmod` to only display the information of only files whose permissions were altered.

 __2.__ __mode:__ This spells out the permissions to be assigned to the file or directory and can be represented in three formats viz:
 - __Symbolic mode:__ In this format, letters (u, g, o, a), and symbols (+, -, =) are used to specify permissions (e.g: u+rwx, g-w, etc...). where u = user/owner, g = group, o = others, a = all, + = add permission(s), - = remove permission(s)
 E.g:
```
chmod u+rwx, g=rw <filename>.txt
```
This above example tells `chmod` to grant full access to the file's owner, only read/write access to the file's group.
 
 - __Absolute mode:__  This mode uses octal numbers (i.e: numbers between 0 to 7) to represent permissions. in this mode, read = 4, write = 2, and execute = 1. So assigning a permission to a file using this mode would look like: 
```
 chmod 777 <filename>
```
- __Reference mode:__
This copies permissions from another file or directory and pastes it to a file.

## The chown command
The chown command is short for 'change owner' and is used to modify the ownership property of a file and or directory.
This is how it is used:

```
chown [options] new_owner:group <filename or directoryname>
```

__Arguments:__

__1.__ __options:__ This right here, controls how `chmod` works/behaves. some common options for `chmod` includes:
- __-R:__ This recursively changes the ownership of a direcctory and all their contents.
- __-v:__ This option tells `chmod` to display verbose information about the changes being made.
- __--reference:__ This option tells `chmod` to set the ownership of the file to match that of the referenced file (another file or another directory).

__2.__ __new_owner:__ This argument here is a place-holder for the username or the numeric user ID of the user who will become the new owner of the file or directory being modified.

__3.__ __group:__ This argument stipulates the new group (which can be stipulated via the group ID or the group name) that gets the ownership of the file or directory. 
E.g:
```
chown alice:developers fileName.txt
```
The above command tells `chown` to change the file's owner to 'alice' and the file group to 'developers'


__Conclusion__

The `chmod` and `chown` commands are very very important in ensuring the proper access control and data security of files in a Linux environment, and understanding these commands (as we have done in the above explanations) is crucial in managing file permissions, ownership and managing file data in the Linux environment.

