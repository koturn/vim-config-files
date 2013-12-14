let g:eskk#start_completion_length = 2
let g:eskk#show_candidates_count = 2

let g:eskk#marker_henkan = '»'
let g:eskk#marker_okuri = '*'
let g:eskk#marker_henkan_select = '«'
let g:eskk#marker_jisyo_touroku = '?'

let g:eskk#dictionary = {'path' : '~/.skk-jisyo', 'sorted' : 0, 'encoding' : 'utf-8'}
let g:eskk#large_dictionary = {'path' : '~/.eskk/SKK-JISYO.L', 'sorted' : 1, 'encoding' : 'euc-jp'}

let g:eskk#debug = 0
let g:eskk#rom_input_style = 'msime'
let g:eskk#revert_henkan_style = 'okuri'
let g:eskk#egg_like_newline = 1
let g:eskk#egg_like_newline_completion = 1
let g:eskk#enable_completion = 1
let g:eskk#keep_state = 0

autocmd MyAutoCmd User eskk-initialize-pre  call s:eskk_use_camma_period()
function! s:eskk_use_camma_period()
  let table = eskk#table#new('rom_to_hira*', 'rom_to_hira')
  call table.add_map(',', '，')
  call table.add_map('.', '．')
  call table.add_map('=', '＝')
  call table.add_map('~', '～')
  call eskk#register_mode_table('hira', table)

  let table = eskk#table#new('rom_to_kata*', 'rom_to_kata')
  call table.add_map(',', '，')
  call table.add_map('.', '．')
  call table.add_map('=', '＝')
  call table.add_map('~', '～')
  call eskk#register_mode_table('kata', table)
endfunction
