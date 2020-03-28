"my keybinds
:set tabstop=4
:set relativenumber
:set shiftwidth=4
"to work faster
:command Q q
:command WQ wq
:command Wq wq
"C-z do decrement and C-x to increment
:nnoremap <C-z> <C-x>
:nnoremap <C-x> <C-a>
"C-a/e to go to the beginning / end of line
:imap <C-a> <home>
:map <C-a> <home>
:imap <C-e> <end>
:map <C-e> <end>
"C-o quick save
:imap <C-o> <Esc>:w<Return>
:map <C-o> :w<Return>
:map <C-q> :q!
:imap <C-q> <Esc>:q!
