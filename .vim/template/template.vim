"=============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <mail.address@gmail.com>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" }}}
"=============================================================================
if exists('g:loaded_<+FILE+>')
  finish
endif
let g:loaded_<+FILE+> = 1
let s:save_cpo = &cpo
set cpo&vim




let &cpo = s:save_cpo
unlet s:save_cpo
