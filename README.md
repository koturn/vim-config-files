vim-setting-files
=================

```AA
+--------------------------------------------------+
|      __         __                      ____     |
|     / /______  / /___  ___________     / __ \ _  |
|    / //_/ __ \/ __/ / / / ___/ __ \   / / / /(_) |
|   / ,< / /_/ / /_/ /_/ / /  / / / /  / /_/ / _   |
|  /_/|_|\____/\__/\__,_/_/  /_/ /_/   \____/ ( )  |
|                                             |/   |
+--------------------------------------------------+
```

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

また、e-mailアドレスなどのプライベートな情報は、  
~/.vim/.private.vim  
に配置してあります。  
現在必要な設定項目は、以下の例の通りです。  

```VimL
""" .private.vim """
" gmail.vim(https://github.com/yuratomo/gmail.vim)の
" g:gmail_user_nameに設定される値
" この変数を定義しなければ、g:gmail_user_nameには、.vimrcで空文字列が代入される。
let g:gmail_address = 'xxxx.yyyy.zzzz@gmail.com'

" previm(https://github.com/kannokanno/previm)の
" g:previm_open_cmdに設定される値
" この変数を定義しなければ、g:previm_open_cmdには、.vimrcで空文字列が代入される。
let g:browser_cmd = 'C:\path\to\browser\chrome.exe'

" vim-ref(https://github.com/thinca/vim-ref)が使用する
" Lynxの-pauthオプションに設定される値
" ユーザ名とパスワードが必要なプロキシ設定をしている場合に必須
" この変数を定義しない、もしくは空文字列の場合、Lynxの-pauthオプションは使用しない。
let g:pauth = 'username:password'
```

また、~/.vim/.private.vimが存在しない場合、  
g:gmail_address  
g:browser_cmd  
には空文字列が設定されます。




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

```VimL
command! ToggleCursorHighlight
      \   if !&cursorline || !&cursorcolumn
      \ |   setl   cursorline   cursorcolumn
      \ | else
      \ |   setl nocursorline nocursorcolumn
      \ | endif
```


#### 3. setとletとexecute
オプションの値設定は、極力setを用いる。  
変数に入っている値を設定するときには、letを用いてもよい。  
また、executeでコマンドを実行するのは、必要な場合を除き、なるべく避けること。

例:

```VimL
set columns=100
let &lines = s:lines

let s:posx = '10'
let s:posy = '10'
exec 'winpos ' . s:posx . ' ' . s:posy
```
letを用いる場合、代入演算子(=)の前後に1スペース以上空けること。


#### 4. 演算子の記述
前項の内容と少し重複するが、基本的に演算子の前後には1スペース以上を開けること。  
文字列やリストの要素の取り出し(s:list[2 : 4]など)のコロンの前後に1スペース設けること。  
これは、範囲指定に変数を用いた場合の視認性のためであり、無用なシンタックスエラーを避けるためである。  

例:

```VimL
let s:a = 10
let s:b = 20
let s:c = s:a + s:b
let s:str     = 'abcdefghijklmnopqrstuvwxyz'
let s:substr1 = s:str[5 : 15]
let s:substr2 = s:str[s:a : s:b]
" これはシンタックスエラー
" let s:substr3 = s:str[s:a: s:b]
```


#### 5. オプションやコマンドの略称
略称は基本的に用いない。  
しかし、以下の表にあるものは、表の通りの略称を用いても良い。

項目                 | 省略表記
---------------------|-------------------------
encoding             | enc
execute              | exec
filencoding          | fenc
filetype             | ft
relativenumber       | rnu
runtimepath          | rtp
setlocal             | setl
setglobal            | setg
shiftwidth           | sw
softtabstop          | sts
tabstop              | ts
termencoding         | tenc
autogroup内のautocmd | au(autocmd!は省略しない)
autocmd中のhighlight | hi


#### 6. その他
###### 6-1. 変数のスコープ
変数や関数のスコープはできる限り小さくすること。  
また、unletで変数消去も試みること。

例:

```VimL
function! s:get_winpos_strs()
  let l:wstr = ''
  redir => l:wstr
  silent! winpos
  redir END
  let l:wstr = substitute(l:wstr, '[\r\n]', '', 'g')
  return l:wstr[17 :]
endfunction
```

###### 6-2. 滅多に必要のない条件判断
環境判定などのif文で、判定する必要性があまりないものについては、
ifとendifをダブルクオート6つでコメントアウトする。

例:

```VimL
"""""" if v:version >= 703
nnoremap <silent> <Leader>l  :<C-u>setl relativenumber!<CR>
"""""" endif
```

###### 6-3. リローダブル
.vimrc, .gvimrcはリローダブルにすること。  
(function!, autocmd!を用いるなど)  
ただし、autocmd!は時間がかかるコマンドなので、augroupをなるべく1つにまとめること。

例:

```VimL
augroup MyAutoCmd
  autocmd!
augroup END

autocmd MyAutoCmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
augroup MyAutoCmd
  au ColorScheme * hi WhitespaceEOL term=underline ctermbg=Blue guibg=Blue
  au VimEnter,WinEnter * call matchadd('WhitespaceEOL', ' \+$')
  au ColorScheme * hi TabEOL term=underline ctermbg=DarkGreen guibg=DarkGreen
  au VimEnter,WinEnter * call matchadd('TabEOL', '\t\+$')
  au Colorscheme * hi JPSpace term=underline ctermbg=Red guibg=Red
  au VimEnter,WinEnter * call matchadd('JPSpace', '　')
augroup END
```

また、いかなるタイミングで各種autocmdが発行されても影響が出ないようにすること。

###### 6-4. 文字列リテラル
文字列リテラルには、なるべくシングルクオートを用いること。  
特殊文字を考慮する場合のみ、ダブルクオートを用いる。

###### 6-5. 行連結
オートコマンドやコマンド定義などで、過度な行連結は避けること。(多くても5行程度?)  
あまりに長くなる場合は、関数を定義し、コマンドからその関数を呼び出すようにすること。  
これは、行連結には時間がかかるためである。

悪い例:

```VimL
autocmd MyAutoCmd BufWritePost *
      \   let l:file = expand('%:p')
      \ | if getline(1) =~# '^#!' && !executable(l:file)
      \ |   silent! call vimproc#system('chmod a+x ' . shellescape(l:file))
      \ | endif
```

良い例:

```VimL
function! s:add_permission_x()
  let l:file = expand('%:p')
  if getline(1) =~# '^#!' && !executable(l:file)
    silent! call vimproc#system('chmod a+x ' . shellescape(l:file))
  endif
endfunction
autocmd MyAutoCmd BufWritePost * call s:add_permission_x()
```




###### 6-6. キーバインド
なるべくデフォルトのキーバインドに対する上書きをしないこと。
