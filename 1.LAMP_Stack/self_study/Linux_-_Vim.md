# Linux - Vim (Vi)
### Introduction

__Vi (Visual Editor) and it's improved version (Vim) was earlier developed for Unix-based systems. They are very effective and are known for thier efficiency and extensive fnctionality. Today, Vi and vim are popular choices for Linux users and developers. In this documentation, we will look at how we can utilize Vim's core functionality in navigating and enhancing our editing experiences in the Linux environment.__

## Core functionalities in Vim
- __Modes:__ Vim has three primary modes of operation which are:
  - __Normal Mode (default mode):__ In this mode, users are able to navigate and manipulate text via code commands.
  - __Insert Mode:__ This mode allows users too insert and modify the content of a text file.
  - __Visual Mode:__ This mode allows users to select block(s) of text for editing operations.
  
- __Navigation:__ 

  - __Cursor Movement:__ To move your cursor around the text file, you can make use of the arrow keys on your keyboard or you could use commands like:
```
h (to move cursor leftwards),
j (to move cursor downwards),
k (to move the cursor upwards),
l (to move the cursor rightwards).
```
To have a more granular (precise) control of the cursor's movement, you can utilize these commands:
```
w (to move the cursor a word forward)
b (to move the cursor a word backward)
0 (to move the cursor to the beginning of the line), 
$ (to move the cursor to the end of the line), 
gg (to move the cursor to the beginning of the file), 
G (to move the cursor to the end of the text in the file).
```

- __Scrolling:__ To scroll through the text content, use the following shortcuts:
```
Ctrl + u (Scroll up),
Ctrl + d (Scroll down),
Ctrl + f (Scroll forward),
Ctrl + b (Scroll backward).
```

- __Editing File Contents:__

  - __Inserting Text:__
  ```
  Press the 'i' key to enter into the 'Insert mode' of vim at the cursor position. You could also press the 'a' key to enter this mode after the cursor.
  ```

  - __Deleting and Cutting Texts:__  
  Use the commands below to achieve various forms of text deletion. N/B: these commands can only be used in the Normal (command) mode.
  ```
  x (deletes a character),
  dd (deletes a line),
  dw (deletes a word),
  D (deletes to the end of the line)
  ```
  Similarly, for copying, you can use these commands:
  ```
  yy (to copy a line),
  yw (to copy a word),
  p (to paste copied content).
  ```
- __Undo and Redo:__
We make mistakes sometimes, and it would be great to have a command that helps us eaily undo a mistake, or to preview how the 'before and after' an applied change looks.
```
u (to undo the last action)
Ctrl + r (to redo the last action)
```

- __Searching and Replacing:__

  - __Use__ `/pattern` to search and look for files that possesses certain pattern in a forward direction, and `?pattern` to search backward
  - __Replace pattern:__ To replacce a pattern within the current line, utilize the command below:
  ```
  :s/pattern/replacement/g
  ```
  OR
  replace the occurence of a pattern throughout the entire file with this command:
  ```
  :%s/pattern/replacement/g
  ```

  - __Clear highlight__
  you can clear highlighted search results with this command:
  ```
  :noh
  ```

  - __Buffers and Tabs:__
    - __Open a new file:__ to open a new file in the current buffer, use this command:
    ```
    :e <filename>
    ```

    - __Navigate between buffers__ using
    ```
    :bnext (next buffer)
    and 
    :bprev (previous buffer)

    #List all the buffers with 
    :ls
    ```

    - __To work with multiple files,__ you can utilize the tabs functionality, to achieve this, run this command:
    ```
    :tabnew (this opens a new tab), 
    gt      (moes to the next tab),
    gT      (moves to the previous tab),
    ```

    - __Saving and Loading Files:__
      
      - You can save changes with the `:w` command.  do this:
      ```
      :w <filename> to save the file a new file
      ```
      - You can open up a file with this command:
      ```
      :e <filename>
      ```
      To discard changes and reload the file, use this command:
      ```
      :e!
      ```

### Customizations
- __Vim configuration:__ You can modify and peform various customization on Vim like: enabling syntax highlighting, defining custom key mappings by modifying the `~/.vimrc` file.

- __Plugins:__ Vim supports various plugins to extend its functionalities. 
Some plugins for optimized productivity are: __vim-airline (status line)__, __NERDTree (file explorer)__, __CtrlP (fuzzy file finder)__.
Some plugin managers are: __Vim-plug__, __Vundle__, __Pathogen__, etc...


__Conclusion__

This self study documentation has shown us the robust features existing within Vim, equipped us with the necessary foundation to get started with Vim, and shown us the possibilities of customization of Vim.

Consistent practicing is required if you want to make working with vim a breeze for you.
Congratulations for making it thus far!

