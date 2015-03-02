" =============================================================================
" File: conversion.vim
" Description: Conversion from info docs (plain text) to Vim help format
" Author: Daniel Campoverde [alx741] <alx741@riseup.net>
" =============================================================================



" Info2help() {{{1
" Convert Info plain text files generated by ` info page > result `
" to a convenient vim help file format
function! vinfo#conversion#info2help()

    " Add vim modelines for help-file
    " tw=78 ts=8 ft=help norl
    exe "silent norm! Go" . ' vim:tw=78:ts=8:ft=help:norl:' . "\<Esc>gg"

    " Convert node subtitles (replace = underlining with -)
    exe "silent " . 'g/\v^$\n.+\n\=+\n^$\n/norm! jjvg_r-\<Esc>'
    " Convert node subtitles (replace . underlining with -)
    exe "silent " . 'g/\v^$\n.+\n\.+\n^$\n/norm! jjvg_r-\<Esc>'

    " Convert node titles (replace * underlining with =)
    exe "silent " . 'g/\v^$\n.+\n\*+\n^$\n/norm! jjvg_r=\<Esc>'

    " Convert Menu marks to vim help-files syntax
    exe 'silent %s/^* Menu:/MENU/e'

    " Create tag references
    " Change blank spaces, '-' with '_' and apply tag notation with '|'
    exe 'silent g/\v^\*\s+(.+)::/exe "norm! Wvt:\<Esc>"|s/\%V /_/ge|s/\%V-/_/ge'
    exe 'silent %s/\v^\*\s+(.+)::/\* |\1|::/e'

    " Remove false tags
    exe 'silent g/\v\*[^\* ]+\*/exe "norm! f*xf*x"'

    " Create tags
    exe 'silent g/\v^File: /call s:Create_tag()'

    " Mark Nodes separations
    let @o = "==============================================================================\n"
    exe 'silent g/\v^File: /exe "norm! \"oPj\"op\<Esc>"'
endfunction
" }}}1



" Create_tag() {{{1
" Takes Node names, remove white spaces
" and add '*' tag notation
function! s:Create_tag()
    " Create self node tag
    exe 'silent norm! ' . '/\vNode: ' . "\<CR>W\"oyt,mm"
    let @o = "\n*" . @o . "*\n"
    exe "silent norm! \"op"
    exe 'silent norm! ' .  "j0V\<Esc>"
    exe 'silent s/\%V /_/ge'
    exe 'silent s/\%V-/_/ge'
    exe 'silent right'
    exe 'silent norm! ' . "\'m"

    " Create tag references
    " Node:
    exe 'silent norm! ' . '/\vNode: ' . "\<CR>Wvt,y\<Esc>"
    if @@ !~? '.\+|' && @@ !~? '.\+)'
        exe 'silent s/\%V /_/ge|s/\%V-/_/ge'
        exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
        exe 'silent norm! ' . "\'m"
    endif
    " Next:
    exe 'silent norm! ' . '/\vNext: ' . "\<CR>Wvt,y\<Esc>"
    if @@ !~? '.\+|' && @@ !~? '.\+)'
        exe 'silent s/\%V /_/ge|s/\%V-/_/ge'
        exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
        exe 'silent norm! ' . "\'m"
    endif
    " Prev:
    exe 'silent norm! ' . '/\vPrev: ' . "\<CR>Wvt,y\<Esc>"
    if @@ !~? '.\+|' && @@ !~? '.\+)'
        exe 'silent s/\%V /_/ge|s/\%V-/_/ge'
        exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
        exe 'silent norm! ' . "\'m"
    endif
    " Up:
    exe 'silent norm! ' . '/\vUp: ' . "\<CR>Wvg_y\<Esc>"
    if @@ !~? '.\+|' && @@ !~? '.\+)'
        exe 'silent s/\%V /_/ge|s/\%V-/_/ge'
        exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
        exe 'silent norm! ' . "\'m"
    endif
endfunction
" }}}1
