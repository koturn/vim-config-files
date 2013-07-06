vim-setting-files
=================

~~~~AA
+--------------------------------------------------+
|      __         __                      ____     |
|     / /______  / /___  ___________     / __ \ _  |
|    / //_/ __ \/ __/ / / / ___/ __ \   / / / /(_) |
|   / ,< / /_/ / /_/ /_/ / /  / / / /  / /_/ / _   |
|  /_/|_|\____/\__/\__,_/_/  /_/ /_/   \____/ ( )  |
|                                             |/   |
+--------------------------------------------------+
~~~~

koturn 0;のvimの設定ファイルです。  
## 導入
#### 1. ファイルの配置  
展開して得られる設定ファイル、ディレクトリ一式を、ホームディレクトリに置いてください。  
以下のような配置になればOKです。  
~/.vim/  
~/vimfiles/  
~/.vimrc  
~/.gvimrc  

#### 2. プラグイン管理用プラグイン : NeoBundleのインストール  
ターミナルから、以下のコマンドでNeoBundleをインストールします。  
$ mkdir -p ~/.vim/bundle  
$ git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim  

#### 3. プラグインのインストール  
次に、Vimを立ち上げ、  
:NeoBundleInstall  
というコマンドを実行して、プラグインをインストールしてください。  

#### 4. vimprocのビルド  
お使いの環境に応じて、  
~/.vim/bundle/vimproc/  
ディレクトリにあるMakefileでvimprocをビルドしてください。  

#### 5. その他  
以下のコマンドが必要になります。  
1. git(NeoBundleに必須)  
2. python(NeoBundleに必須)  
3. curl  
4. openssl  
5. w3m  




## コーディング規約
#### 1. 命名規則
変数名などの命名規則は、以下の表に従う。

対象             | 記法
-----------------|---------------------
変数名           | 小文字スネークケース
関数名           | 小文字スネークケース
環境変数名       | 大文字スネークケース
コマンド名       | パスカルケース
オートコマンド名 | パスカルケース


#### 2. インデント
インデントは、以下の表のように行う。

項目           | 設定
---------------|---------------------------------------------
タブ           | 使用しない
インデント幅   | 2
行連結         | 次の行で、3段階インデントを深くし、'\'を記述
パイプ         | 前後に1スペース以上空ける
行連結とパイプ | 以下のコードのように記述すること

例:
~~~~VimL
command! ToggleCursorHighlight
      \   if !&cursorline || !&cursorcolumn
      \ |   setl   cursorline   cursorcolumn
      \ | else
      \ |   setl nocursorline nocursorcolumn
      \ | endif
~~~~


#### 3. setとlet
オプションの値設定は、極力setを用いる。
変数に入っている値を設定するときには、letを用いてもよい。

例:
~~~~VimL
set columns=100
let &lines = s:lines
~~~~
letを用いる場合、代入演算子(=)の前後に1スペース以上空けること。


#### 4. 演算子の記述
前項の内容と少し重複するが、基本的に演算子の前後には1スペース以上を開けること。

例:
~~~~VimL
let s:a = 10
let s:b = 20
let s:c = s:a + s:b
~~~~


#### 5. オプションやコマンドの略称
略称は基本的に用いない。
しかし、以下の表にあるものは、表の通りの略称を用いても良い。

項目                 | 省略表記
---------------------|---------
encoding             | enc
filencoding          | fenc
filetype             | ft
execute              | exec
setlocal             | setl
autogroup内のautocmd | au
autocmd中のhighlight | hi


#### 6. その他
###### 6-1. 変数のスコープ
変数や関数のスコープはできる限り小さくすること。
また、unletで変数消去も試みること。

例:
~~~~VimL
function! s:get_winpos_strs()
  let l:wstr = ''
  redir => l:wstr
  silent! winpos
  redir END
  let l:wstr = substitute(l:wstr, '[\r\n]', '', 'g')
  return l:wstr[17:]
endfunction
~~~~

###### 6-2. 滅多に必要のない条件判断
環境判定などのif文で、判定する必要性があまりないものについては、
ifとendifをダブルクオート6つでコメントアウトする。

例:
~~~~VimL
"""""" if v:version >= 703
nnoremap <silent> <Leader>l :setl relativenumber!<CR>
"""""" endif
~~~~

###### 6-3. リローダブル
.vimrc, .gvimrcはリローダブルにすること。
(function!, autocmd!を用いる)
ただし、autocmd!は時間がかかるコマンドなので、augroupをなるべく1つにまとめること。

例:
~~~~VimL
augroup MyAutoCmd
  autocmd!
augroup END

autocmd MyAutoCmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
augroup MyAutoCmd
  au ColorScheme * hi WhitespaceEOL term=underline ctermbg=Blue guibg=Blue
  au VimEnter,WinEnter * call matchadd('WhitespaceEOL', '\s\+$')
  au ColorScheme * hi TabEOL term=underline ctermbg=DarkGreen guibg=DarkGreen
  au VimEnter,WinEnter * call matchadd('TabEOL', '\t\+$')
  au Colorscheme * hi JPSpace term=underline ctermbg=Red guibg=Red
  au VimEnter,WinEnter * call matchadd('JPSpace', '　')
augroup END
~~~~

また、いかなるタイミングで各種autocmdが発行されても影響が出ないようにすること。
