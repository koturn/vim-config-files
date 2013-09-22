setl wrap
let g:my_vimshell_prompt_counter = -1
function! g:my_vimshell_dynamic_prompt()
  let g:my_vimshell_prompt_counter += 1
  let anim = [
        \ "(´:_:`)",
        \ "( ´:_:)",
        \ "(  ´:_)",
        \ "(   ´:)",
        \ "(    ´)",
        \ "(     )",
        \ "(     )",
        \ "(`    )",
        \ "(:`   )",
        \ "(_:`  )",
        \ "(:_:` )",
        \]
  return anim[g:my_vimshell_prompt_counter % len(anim)]
endfunction
if !has('gui_running')
  let g:vimshell_prompt = "('v ')$ "
else
  let g:vimshell_prompt_expr = 'g:my_vimshell_dynamic_prompt() . " $ "'
  let g:vimshell_prompt_pattern = '^([ ´:_:`]\{5}) \$ '
endif
let g:vimshell_secondary_prompt = '> '
let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_right_prompt = '"[" . strftime("%Y/%m/%d %H:%M:%S", localtime()) . "]"'
