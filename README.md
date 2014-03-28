#Vim Whitespace Plugin

This plugin causes all trailing whitespace characters (spaces and tabs) to be
highlighted. Whitespace for the current line will not be highlighted
while in insert mode. This plugin also causes all tab characters in the file to be highlighted.
A helper function `:StripWhitespace` is also provided
to make whitespace cleaning painless.

##Installation
There are a few ways you can go about installing this plugin:

1.  If you have [Vundle](https://github.com/gmarik/Vundle.vim) you can simply add:
    ```
    Bundle 'eyuelt/vim-better-whitespace'
    ```
    to your `.vimrc` file then run:
    ```
    :BundleInstall
    ```
2.  If you are using [Pathogen](https://github.com/tpope/vim-pathogen), you can just run the following command:
    ```
    git clone git://github.com/eyuelt/vim-better-whitespace.git ~/.vim/bundle/
    ```
3.  While this plugin can also be installed by copying its contents into your `~/.vim/` directory, I would highly recommend using one of the above methods as they make managing your Vim plugins painless.

##Usage
Whitespace highlighting is enabled by default, with a highlight color of red.

To set a custom highlight color, just call:
```
highlight ExtraWhitespace ctermbg=<desired_color>
```

To toggle whitespace highlighting on/off, call:
```
:ToggleWhitespace
```

To toggle tab highlighting on/off, call:
```
:ToggleTab
```

To clean extra whitespace, call:
```
:StripWhitespace
```
By default this operates on the entire file. To restrict the portion of
the file that it cleans, either give it a range or select a group of lines
in visual mode and then execute it.

To convert tab characters to spaces, add:
```
set expandtab
```
to your `.vimrc` file then use the builtin vim command:
```
:retab
```

Repository exists at: http://github.com/eyuelt/vim-better-whitespace

Originally inspired by: https://github.com/bronson/vim-trailing-whitespace

Based on:

http://sartak.org/2011/03/end-of-line-whitespace-in-vim.html

http://vim.wikia.com/wiki/Highlight_unwanted_spaces
