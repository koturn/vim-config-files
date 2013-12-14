setl updatetime=500
let g:vimshell_prompt = "<po><yo> > "
let s:count = 0
let s:last_time = 0
let s:anim = [
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
let s:vimshell_prompt_counter = 0
function! s:my_vimshell_dynamic_prompt()
  let l:time = str2float(reltimestr(reltime()))
  if (l:time - s:last_time) > 0.45
    let s:vimshell_prompt_counter += 1
    let s:last_time = l:time
  endif
  return s:anim[s:vimshell_prompt_counter % len(s:anim)]
endfunction
" if s:is_cui
"   let g:vimshell_prompt = "('v ')$ "
" else
"   let g:vimshell_prompt_expr = 's:my_vimshell_dynamic_prompt() . " $ "'
"   let g:vimshell_prompt_pattern = '^([ ´:_:`]\{5}) \$ '
" endif
let g:vimshell_secondary_prompt = '> '
let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_right_prompt = '"[" . strftime("%Y/%m/%d %H:%M:%S", localtime()) . "]"'

function! s:update()
  let l:pos = getpos(".")
  let l:anim = s:my_vimshell_dynamic_prompt()
  let l:prev_anim = matchstr(getline('.'), '<po>\zs.\{-}\ze<yo>')
  exec ':%s/<po>\zs.\{-}\ze<yo>/' . l:anim . '/g'
  call setpos('.', [l:pos[0], l:pos[1], l:pos[2] + strlen(l:anim) - strlen(l:prev_anim), l:pos[3]])
  let b:vimshell.context.prompt_pattern = printf('^<po>%s<yo>\ >\ ', l:anim)
endfunction

function! s:vimshell()
  setl conceallevel=2
  setl concealcursor=ni
  syntax match tagPoyoHiddenBegin /<po>/ conceal
  syntax match tagPoyoHiddenEnd   /<yo>/ conceal
  augroup MyAutoCmd
    autocmd CursorHold  <buffer> call s:update()
    autocmd CursorHoldI <buffer> call s:update()
  augroup END
endfunction
autocmd MyAutoCmd FileType vimshell call s:vimshell()

