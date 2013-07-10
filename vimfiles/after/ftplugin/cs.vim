nnoremap <silent> <buffer> <F12> :OmniSharpGotoDefinition<CR>
nnoremap <silent> <buffer> <S-F12> :OmniSharpFindUsages<CR>

nnoremap [omni_sharp] <Nop>
nmap m   [omni_sharp]
nnoremap <silent> <buffer> [omni_sharp]a :OmniSharpAddToProject<CR>
nnoremap <silent> <buffer> [omni_sharp]b :OmniSharpBuild<CR>
nnoremap <silent> <buffer> [omni_sharp]c :OmniSharpFindSyntaxErrors<CR>
nnoremap <silent> <buffer> [omni_sharp]f :OmniSharpCodeFormat<CR>
nnoremap <silent> <buffer> [omni_sharp]j :OmniSharpGotoDefinition<CR>
nnoremap <silent> <buffer> <C-w>[omni_sharp]j <C-w>s:OmniSharpGotoDefinition<CR>
nnoremap <silent> <buffer> [omni_sharp]i :OmniSharpFindImplementations<CR>
nnoremap <silent> <buffer> [omni_sharp]r :OmniSharpRename<CR>
nnoremap <silent> <buffer> [omni_sharp]t :OmniSharpTypeLookup<CR>
nnoremap <silent> <buffer> [omni_sharp]u :OmniSharpFindUsages<CR>
nnoremap <silent> <buffer> [omni_sharp]x :OmniSharpGetCodeActions<CR>
