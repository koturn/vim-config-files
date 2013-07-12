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
NeoBundleLazy 'movewin.vim', {
      \ 'autoload': {'commands' : 'MoveWin'}
      \}

NeoBundleLazy 'thinca/vim-fontzoom', {
      \ 'autoload' : {
      \   'commands' : 'Fontzoom',
      \   'mappings' : [
      \     ['n', '<Plug>(fontzoom-larger)'],
      \     ['n', '<Plug>(fontzoom-smaller)']
      \]}}
nmap + <Plug>(fontzoom-larger)
nmap - <Plug>(fontzoom-smaller)
" }}}
" ************** The end of etting of NeoBundle **************




" ------------------------------------------------------------
" Basic settings {{{
" ------------------------------------------------------------
set guioptions=    " Hide menubar and toolbar.
set winaltkeys=no  " Turns of the Alt key bindings to the gui menu
set cursorline cursorcolumn

" Change cursor color depending on state of IME.
if has('multi_byte_ime') || has('xim')
  autocmd MyAutoCmd Colorscheme * hi CursorIM guifg=NONE guibg=Orange
  " Default state of IME on insert mode and searching mode.
  set iminsert=0 imsearch=0  " for no KaoriYa WIN gvim
endif

if g:is_windows
  set guifont=Consolas:h9 guifontwide=MS_Gothic:h9
  " Setting for printing.
  set printoptions=number:y,header:0,syntax:y,left:5pt,right:5pt,top:10pt,bottom:10pt
  set printfont=Consolas:h9

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
if has('kaoriya') && g:is_windows
  gui
  if g:is_windows
    augroup MyAutoCmd
      autocmd FocusGained * set transparency=215 titlestring&
      autocmd FocusLost   * set transparency=180 titlestring=Forcus\ was\ lost
    augroup END
  elseif g:is_mac
    augroup MyAutoCmd
      autocmd FocusGained * set transparency=15 titlestring&
      autocmd FocusLost   * set transparency=30 titlestring=Forcus\ was\ lost
    augroup END
  endif
endif
colorscheme koturn
filetype plugin indent on
" }}}
