" A Setting for the site of webdict.
let g:ref_source_webdict_sites = {
      \ 'je' : {'url' : 'http://dictionary.infoseek.ne.jp/jeword/%s'},
      \ 'ej' : {'url' : 'http://dictionary.infoseek.ne.jp/ejword/%s'},
      \ 'dn' : {'url' : 'http://dic.nicovideo.jp/a/%s'},
      \ 'wiki_en' : {'url' : 'http://en.wikipedia.org/wiki/%s'},
      \ 'wiki' : {'url' : 'http://ja.wikipedia.org/wiki/%s'}
      \}
autocmd MyAutoCmd Filetype ref-webdict setl number
if g:is_cygwin
  autocmd MyAutoCmd Filetype ref-webdict setl enc=cp932
endif
let g:ref_open = 'split'

" If you don't specify a following setting, webdict-results are garbled.
let s:pauth = get(g:, 'pauth', '')
if s:pauth ==# ''
  let g:ref_source_webdict_cmd = 'lynx -dump -nonumbers %s'
else
  let g:ref_source_webdict_cmd = 'lynx -dump -nonumbers -pauth=' . s:pauth . ' %s'
endif
unlet s:pauth

" Default webdict site
let g:ref_source_webdict_sites.default = 'ej'
" Filters for output. Remove the first few lines.
function! g:ref_source_webdict_sites.je.filter(output)
  let l:idx = strridx(a:output, '   (C) SHOGAKUKAN')
  return join(split(a:output[: l:idx - 1], "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.ej.filter(output)
  let l:idx = strridx(a:output, '   (C) SHOGAKUKAN')
  return join(split(a:output[: l:idx - 1], "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.dn.filter(output)
  let l:idx = strridx(a:output, "\n   [l_box_b]\n")
  return join(split(a:output[: l:idx], "\n")[16 :], "\n")
endfunction
function! g:ref_source_webdict_sites.wiki.filter(output)
  let l:idx = strridx(a:output, "\n案内メニュー\n")
  return join(split(a:output[: l:idx], "\n")[17 :], "\n")
endfunction
function! g:ref_source_webdict_sites.wiki_en.filter(output)
  let l:idx = strridx(a:output, "\nNavigation menu\n")
  return join(split(a:output[: l:idx], "\n")[17 :], "\n")
endfunction
