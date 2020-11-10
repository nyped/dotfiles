" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
"
"display a warning if &et is wrong, or we have mixed-indenting
"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return 'BI[n]' if &et is set wrong at line n
"return 'MI[i:j]' if spaces and tabs are used to indent at lines i
"and j
"return an empty string if everything is fine
function! StatuslineTabWarning()
	if !exists("b:statusline_tab_warning")
		let tabs = search('^\t', 'nw')
		let spaces = search('^ ', 'nw')
		let tmp = ''
		if tabs != 0 && spaces != 0
			let b:statusline_tab_warning =  tmp.printf('MI %d:%d ', tabs, spaces)
		elseif (spaces != 0 && !&et)
			let b:statusline_tab_warning = tmp.printf('BI %d ', spaces)
		elseif (tabs != 0 && &et)
			let b:statusline_tab_warning = tmp.printf('BI %d ', tabs)
		else
			let b:statusline_tab_warning = ''
		endif
	endif
	return b:statusline_tab_warning
endfunction

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return 'TS[n]' if trailing white space is detected at line n
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
	if !exists("b:statusline_trailing_space_warning")
		let trailing = search('\s\+$', 'nw')
		let tmp = ''
		if trailing != 0
			let b:statusline_trailing_space_warning = tmp.printf('TS %d ', trailing)
		else
			let b:statusline_trailing_space_warning = ''
		endif
	endif
	return b:statusline_trailing_space_warning
endfunction
