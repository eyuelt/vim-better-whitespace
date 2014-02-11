" Author: Nate Peterson
" Repository: https://github.com/ntpeters/vim-better-whitespace

" Prevent loading the plugin multiple times
if exists( "g:loaded_better_whitespace_plugin" )
    finish
else
    let g:loaded_better_whitespace_plugin = 1
endif

" Set this to enable/disable whitespace highlighting
let g:better_whitespace_enabled = 1

" Set this to enable stripping whitespace on file save
let g:strip_whitespace_on_save = 0

" Only init once
let s:better_whitespace_initialized = 0

" Ensure the 'ExtraWhitespace' highlight group has been defined
function! s:WhitespaceInit()
    " Check if the user has already defined highlighting for this group
    if hlexists("ExtraWhitespace") == 0
        highlight ExtraWhitespace ctermbg = red
    endif
    let g:better_whitespace_initialized = 1
endfunction

" Enable the whitespace highlighting
function! s:EnableWhitespace()
    if g:better_whitespace_enabled == 0
        let g:better_whitespace_enabled = 1
        call <SID>WhitespaceInit()
        " Match default whitespace
        match ExtraWhitespace /\s\+$/
        call <SID>RunAutoCommands()
    endif
endfunction

" Disable the whitespace highlighting
function! s:DisableWhitespace()
    if g:better_whitespace_enabled == 1
        let g:better_whitespace_enabled = 0
        " Clear current whitespace matches
        match ExtraWhitespace ''
        syn clear ExtraWhitespace
        call <SID>RunAutoCommands()
    endif
endfunction

" Toggle whitespace highlighting on/off
function! s:ToggleWhitespace()
    if g:better_whitespace_enabled == 1
        call <SID>DisableWhitespace()
    else
        call <SID>EnableWhitespace()
    endif
endfunction

" Removes all extaneous whitespace in the file
function! s:StripWhitespace( line1, line2 )
    " Save the current search and cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")

    " Strip the whitespace
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\s\+$//e'

    " Restore the saved search and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Strips whitespace on file save
function! s:ToggleStripWhitespaceOnSave()
    if g:strip_whitespace_on_save == 0
        let g:strip_whitespace_on_save = 1
    else
        let g:strip_whitespace_on_save = 0
    endif
    call <SID>RunAutoCommands()
endfunction

" Run :StripWhitespace to remove end of line white space
command! -range=% StripWhitespace call <SID>StripWhitespace( <line1>, <line2> )
" Run :ToggleStripWhitespaceOnSave to enable/disable whitespace stripping on save
command! ToggleStripWhitespaceOnSave call <SID>ToggleStripWhitespaceOnSave()
" Run :EnableWhitespace to enable whitespace highlighting
command! EnableWhitespace call <SID>EnableWhitespace()
" Run :DisableWhitespace to disable whitespace highlighting
command! DisableWhitespace call <SID>DisableWhitespace()
" Run :ToggleWhitespace to toggle whitespace highlighting on/off
command! ToggleWhitespace call <SID>ToggleWhitespace()

" Process auto commands upon load
autocmd VimEnter,WinEnter,BufEnter,FileType * call <SID>RunAutoCommands()

" Executes all auto commands
function! <SID>RunAutoCommands()
    " Auto commands group
    augroup better_whitespace
        autocmd!

        if g:better_whitespace_enabled == 1
            if s:better_whitespace_initialized == 0
                call <SID>WhitespaceInit()
            endif

            " Highlight all whitespace upon entering buffer
            autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
            " When in insert mode, do not highlight whitespae on the current line
            autocmd InsertEnter,CursorMovedI * exe 'match ExtraWhitespace ' . '/\%<' . line(".") .  'l\s\+$\|\%>' . line(".") .  'l\s\+$/'
            " Highlight all whitespace when exiting insert mode
            autocmd InsertLeave,BufReadPost * match ExtraWhitespace /\s\+$/
            " Clear whitespace highlighting when leaving buffer
            autocmd BufWinLeave * call clearmatches()
        endif

        " Strip whitespace on save if enabled
        if g:strip_whitespace_on_save == 1
            autocmd BufWritePre * call <SID>StripWhitespace( 0, line("$") )
        endif

    augroup END
endfunction

call <SID>RunAutoCommands()
