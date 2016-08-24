" =============================================================================
" File: conversion.vim
" Description: Conversion from info docs (plain text) to Vim help format
" Author: Daniel Campoverde [alx741] <alx741@riseup.net>
" =============================================================================


setlocal nogdefault

" Info2help() {{{1
" Convert Info plain text files generated by ` info page > result `
" to a convenient vim help file format
function! vinfo#conversion#info2help()

    " Add vim modelines for help-file
    " tw=78 ts=8 ft=help norl
    silent norm! Go vim:tw=78:ts=8:ft=help:norl:

    " Convert node subtitles (replace = and . underlining with -)
    silent g/\v^$\n.+\n[=.]+\n^$\n/+2 s/[=.]/-/g

    " Convert node titles (replace * underlining with =)
    silent g/\v^$\n.+\n\*+\n^$\n/+2 s/\*/=/g

    " Convert Menu marks to vim help-files syntax
    silent %s/^* Menu:/MENU/e

    " Create tag references
    " Change blank spaces, '-' with '_' and apply tag notation with '|'
    silent g/\v^\*\s+(.+)::/exe "norm! Wvt:\<Esc>"|s/\%V[ -]/_/ge
    silent %s/\v^\*\s+(.+)::/\* |\1|::/e

    " Remove false tags
    silent g/\v\*[^\* ]+\*/ norm! f*xf*x

    " Create tags
    silent g/\v^File: /call s:Create_tag()

    " Mark Nodes separations
    let @o = "==============================================================================\n"
    silent g/\v^File: /norm! "oPj"op
endfunction
" }}}1



" Create_tag() {{{1
" Takes Node names, remove white spaces
" and add '*' tag notation
function! s:Create_tag()
    " Create self node tag
    exe 'silent! norm! ' . '/\vNode: ' . "\<CR>W\"oyt,mm"
    let @o = "\n*" . @o . "*\n"
    silent put o
    silent +1
    silent s/[- ]/_/ge
    silent right
    silent norm! 'm

    " Create tag references
    " Node:
    exe 'silent! norm! ' . '/\vNode: ' . "\<CR>Wvt,y\<Esc>"
    if @@ !~? '.\+|' && @@ !~? '.\+)'
        silent s/\%V[ -]/_/ge
        exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
        silent norm! 'm
    endif
    " Next:
    exe 'silent! norm! ' . '/\vNext: ' . "\<CR>Wvt,y\<Esc>"
    if @@ !~? '.\+|' && @@ !~? '.\+)'
        silent s/\%V[ -]/_/ge
        exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
        silent norm! 'm
    endif
    " Prev:
    exe 'silent! norm! ' . '/\vPrev: ' . "\<CR>Wvt,y\<Esc>"
    if @@ !~? '.\+|' && @@ !~? '.\+)'
        silent s/\%V[ -]/_/ge
        exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
        silent norm! 'm
    endif
    " Up:
    exe 'silent! norm! ' . '/\vUp: ' . "\<CR>Wvg_y\<Esc>"
    if @@ !~? '.\+|' && @@ !~? '.\+)'
        silent s/\%V[ -]/_/ge
        exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
        silent norm! 'm
    endif
endfunction
" }}}1
