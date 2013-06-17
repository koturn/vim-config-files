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
" http://nanasi.jp/articles/vim/movewin_vim.html
NeoBundleLazy 'movewin.vim', {
      \  'autoload': {'commands' : 'MoveWin'}
      \}

NeoBundleLazy 'thinca/vim-fontzoom', {
      \  'autoload' : {
      \    'commands' : 'Fontzoom',
      \    'mappings' : [
      \      ['n', '<Plug>(fontzoom-larger)'],
      \      ['n', '<Plug>(fontzoom-smaller)']
      \]}}
nmap + <Plug>(fontzoom-larger)
nmap - <Plug>(fontzoom-smaller)
filetype plugin indent on
" }}}
" ************* The end of etting of NeoBundle *************




" ------------------------------------------------------------
" Basic settings {{{
" ------------------------------------------------------------
" set lines=90 columns=200
set guioptions=    " Hide menubar and toolbar.
set winaltkeys=no  " Turns of the Alt key bindings to the gui menu

" Change cursor color depending on state of IME.
if has('multi_byte_ime') || has('xim')
  autocmd MyAutoCmd Colorscheme * highlight CursorIM guifg=NONE guibg=Orange
  " Default state of IME on insert mode and searching mode.
  set iminsert=0 imsearch=0  " for no KaoriYa WIN gvim
endif
colorscheme koturn

if has('win16') || has('win32') || has('win64')
  set guifont=Consolas:h9 guifontwide=MS_Gothic:h9

  " Setting for printing.
  set printoptions=number:y,header:0,syntax:y,left:5pt,right:5pt,top:10pt,bottom:10pt
  set printfont=Consolas:h9

  " Setting for menubar
  set langmenu=ja_jp.utf-8
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
endif

" Singleton
if has('clientserver') && has('gui_running') && argc()
  let s:running_vim_list = filter(
        \  split(serverlist(), '\n'),
        \  'v:val !=? v:servername')
  if !empty(s:running_vim_list)
    silent execute '!start gvim'
          \  '--servername' s:running_vim_list[0]
          \  '--remote-tab-silent' join(argv(), ' ')
    qa!
  endif
  unlet s:running_vim_list
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
" Settings for IndentGuides {{{
" ------------------------------------------------------------
" You have to set following after colorscheme.
" Enable highlighting indent at top level.
let g:indent_guides_start_level = 1
" Disable auto color. (You have to set manually.)
let g:indent_guides_auto_colors = 0
" Guide(highlight) width.
let g:indent_guides_guide_size  = 1
" Guide color of odd indentation.
hi IndentGuidesOdd  guibg=#663366
" Guide color of even indentation.
hi IndentGuidesEven guibg=#6666ff
" }}}




" ------------------------------------------------------------
" Others {{{
" ------------------------------------------------------------
if exists('&transparency')
  gui
  set transparency=215
endif
" }}}
