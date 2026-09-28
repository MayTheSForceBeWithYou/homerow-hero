let g:homerow_hero_navigation_vim_loaded = 1

function! HomerowHeroNavigationVim() abort
  let g:homerow_hero_navigation_vim_calls = get(g:, 'homerow_hero_navigation_vim_calls', 0) + 1
endfunction

nnoremap <silent> <leader>hv :<C-u>call HomerowHeroNavigationVim()<CR>
