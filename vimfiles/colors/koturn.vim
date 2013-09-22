" Vim color file
" Maintainer:   koturn 0;
" Last Change:  2013 March 09
" grey on black
" based on 'torte'

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
"colorscheme default
let g:colors_name = 'koturn'

" hardcoded colors :
" GUI Comment : #80a0ff = Light blue

" GUI
if has('gui_running')  " for GUI
"  highlight Comment    guifg=Green
"  highlight Constant   guifg=Red
"  highlight Special    guifg=Pink
"  highlight Identifier guifg=Yellow
"  highlight Statement  guifg=Purple
"  highlight PreProc    guifg=blue
"  highlight Type       guifg=SlateBlue

  highlight Normal     guifg=Gray80    guibg=Black
  highlight Search     guifg=Black     guibg=Red    gui=bold
  highlight Visual     guifg=#404040                gui=bold
  highlight Cursor     guifg=Black     guibg=Green  gui=bold
  highlight Special    guifg=Orange
  highlight Comment    guifg=#80a0ff
  highlight StatusLine guifg=SlateBlue guibg=white
  highlight Statement  guifg=Gold                   gui=NONE
  highlight Type                                    gui=NONE
  highlight Pmenu      guifg=White     guibg=SlateBlue
  highlight PmenuSel   guibg=White     guifg=Black
  highlight PmenuSbar  guibg=Black
  highlight PmenuThumb guifg=DarkGray
  highlight LineNr     guifg=Green
else  " for Console
  highlight Normal     ctermfg=LightGrey ctermbg=Black
  highlight Search     ctermfg=Black     ctermbg=Red   cterm=NONE
  highlight Visual                                     cterm=reverse
  highlight Cursor     ctermfg=Black     ctermbg=Green cterm=bold
  highlight Special    ctermfg=Brown
  highlight Comment    ctermfg=Blue
  highlight StatusLine ctermfg=white     ctermbg=blue
  highlight Statement  ctermfg=Yellow                  cterm=NONE
  highlight Type                                       cterm=NONE
  highlight LineNr     ctermfg=Green
  highlight CursorColumn ctermfg=bg ctermbg=fg
  highlight CursorLine   ctermfg=bg ctermbg=fg
  " highlight CursorColumn ctermbg=gray cterm=reverse
  " highlight CursorLine   ctermbg=gray cterm=reverse
endif
