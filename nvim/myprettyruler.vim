"
" Wed Nov 11 11:58:40 AM CET 2020
"
" This module shows at the place of the ruler the buffer name and
" some infos about the current buffer (trailing spaces and indent),
" if there is enough space.
"
" To change the color of the ruler, in your config, overwrite
" the global variable prcolor with some values you see in:
" :so $VIMRUNTIME/syntax/hitest.vim
"
" To use this module, just source it in your configuration after,
" :source whitespace.vim
"
" erasing the ruler
"
:set rulerformat=%(\ %)
"
" color variable
"
:let g:prcolor = get(g:, 'prcolor', 'Comment')
"
" fun that updates the ruler
"
function! GetRuler()
	echo ''
	let tmp = ''
	let w1 = StatuslineTabWarning()
	let w2 = StatuslineTrailingSpaceWarning()
	let len = strlen(@%) + strlen(w1) + strlen(w2) + 6
	if len > (&columns / 2)
		if w1 != '' || w2 != ''
			"case code info takes place
			let &rulerformat =
			\ tmp.printf('%%%d(%%=%%#%s#%s %s %%m%%)', strlen(w1) + strlen(w2) + 5, g:prcolor, w1, w2)
		else
			"case file path is really really long...
			let &rulerformat =
			\ tmp.printf('%%%d(%%=%%#%s#%%t%%m%%)', strlen(expand('%:t')) + 3, g:prcolor)
		endif
	else
		if @% == ''
			"case empty buff, show nothing
			let &rulerformat = '%( %)'
		else
			"default fallthrough
			let &rulerformat = tmp.printf('%%%d(%%=%%#%s#%s %s %%f%%m%%)', len, g:prcolor, w1, w2)
		endif
	endif
endfunction
"
" update the ruler at each modification
"
augroup update
	autocmd!
	autocmd BufWritePost * :call GetRuler()
	autocmd BufCreate * :call GetRuler()
	autocmd BufFilePost * :call GetRuler()
	autocmd WinEnter * :call GetRuler()
	autocmd VimResized * :call GetRuler()
	autocmd VimEnter * :call GetRuler()
augroup end
"
" vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab :
"
