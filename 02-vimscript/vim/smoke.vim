" Lesson 02: Vimscript scopes and functions.
let g:homerow_hero_vimscript_loaded = 1
let b:homerow_hero_buf_flag = 'buffer-scope'

function! s:Double(n) abort
  return a:n * 2
endfunction

function! HomerowHeroTriple(n) abort
  return a:n * 3
endfunction

let g:homerow_hero_doubled = s:Double(21)
