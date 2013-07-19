" ============================================================
"     __         __                      ____
"    / /______  / /___  ___________     / __ \ _
"   / //_/ __ \/ __/ / / / ___/ __ \   / / / /(_)
"  / ,< / /_/ / /_/ /_/ / /  / / / /  / /_/ / _
" /_/|_|\____/\__/\__,_/_/  /_/ /_/   \____/ ( )
"                                            |/
"
" Setting file for GUI only.
" ============================================================
" ------------------------------------------------------------
" Load plugins only for GUI {{{
" ------------------------------------------------------------
NeoBundleLazy 'thinca/vim-fontzoom', {
      \ 'autoload' : {
      \   'commands' : 'Fontzoom',
      \   'mappings' : [
      \     ['n', '<Plug>(fontzoom-larger)'],
      \     ['n', '<Plug>(fontzoom-smaller)']
      \]}}
nmap +  <Plug>(fontzoom-larger)
nmap -  <Plug>(fontzoom-smaller)
" }}}
" ************** The end of etting of NeoBundle **************


" ------------------------------------------------------------
" Basic settings {{{
" ------------------------------------------------------------
set guioptions=    " Hide menubar and toolbar.
set winaltkeys=no  " Turns of the Alt key bindings to the gui menu
set cursorline cursorcolumn

function! BalloonExpr()
  let l:lnum = foldclosed(v:beval_lnum)
  if l:lnum == -1
    return ''
  endif
  let l:lines = getline(l:lnum, foldclosedend(l:lnum))
  return iconv(join(len(l:lines) > &lines ? l:lines[: &lines] : l:lines, "\n"), &enc, &tenc)
endfunction
set balloonexpr=BalloonExpr()
set ballooneval

" Change cursor color depending on state of IME.
if has('multi_byte_ime') || has('xim')
  autocmd MyAutoCmd Colorscheme * hi CursorIM guifg=NONE guibg=Orange
  " Default state of IME on insert mode and searching mode.
  set iminsert=0 imsearch=0  " for no KaoriYa WIN gvim
endif

if g:is_windows
  set guifont=Consolas:h9 guifontwide=MS_Gothic:h9
  " Setting for printing.
  if has('printer')
    set printoptions=number:y,header:0,syntax:y,left:5pt,right:5pt,top:10pt,bottom:10pt
    set printfont=MS_Mincho:h12:cSHIFTJIS
  endif

  " Setting for menubar
  " set langmenu=ja_jp.utf-8
  " source $VIMRUNTIME/delmenu.vim
  " source $VIMRUNTIME/menu.vim
endif


" ------------------------------------------------------------
" Setting written in gvimrc of KaoriYa-vim {{{
" ------------------------------------------------------------
set linespace=1
" Disable auto focus with mouse moving.
set nomousefocus
" Hide mouse-pointer when you input.
set mousehide
" }}}
" }}}


" ------------------------------------------------------------
" END of .gvimrc {{{
" ------------------------------------------------------------
if has('kaoriya')
  gui
  if g:is_windows
    augroup MyAutoCmd
      au FocusGained,WinEnter * set transparency=215 titlestring&
      au FocusLost * set transparency=180 titlestring=Forcus\ was\ lost
    augroup END
  elseif g:is_mac
    augroup MyAutoCmd
      au FocusGained,WinEnter * set transparency=15 titlestring&
      au FocusLost * set transparency=30 titlestring=Forcus\ was\ lost
    augroup END
  endif
endif

unlet g:is_windows g:is_cygwin g:is_mac g:is_unix g:at_startup
colorscheme koturn
filetype plugin indent on
" }}}
