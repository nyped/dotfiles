"my keybinds
":set termguicolors
:set shellcmdflag=-ic
:set tabstop=4
:set nu rnu
:set shiftwidth=4
"add lines
:nnoremap o o<Esc>
:nnoremap O O<Esc>
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
"My plugins
call plug#begin('~/.vim/plugged')
Plug 'vimlab/split-term.vim'
Plug 'oblitum/rainbow'
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()
"rainbow
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
"Terminal
:set splitbelow
:command T Term
"Theme
set background=dark
colorscheme PaperColor
highlight Normal ctermbg=none
let g:airline_theme='simple'
