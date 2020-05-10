"
"
"
"my settings
"
"
"
:set termguicolors "only for linux
:set shellcmdflag=-ic
:set tabstop=4
:set nu rnu
:set softtabstop=0 noexpandtab
:set shiftwidth=4
"
"exiting terminal
"
:tnoremap <Esc> <C-\><C-n>
"
"scrolling
"
:nnoremap <C-Up> <C-y>
:nnoremap <C-Down> <C-e>
:set scrolloff=5
"
"add lines
"
:nnoremap o o<Esc>
:nnoremap O O<Esc>
"
"to work faster
"
:command Q q
:command WQ wq
:command Wq wq
:command Nt tabnew
:command E edit
"
"C-x do decrement and C-c to increment
"
:nnoremap <C-c> <C-a>
"
"C-a/e to go to the beginning / end of line
"
:imap <C-a> <home>
:map <C-a> <home>
:imap <C-e> <end>
:map <C-e> <end>
"
"C-o quick save
"
:imap <C-o> <Esc>:w<Return>
:map <C-o> :w<Return>
:map <C-q> :q!
:imap <C-q> <Esc>:q!
"
"switch windows
"
:map <leader>1 1gt
:map <leader>2 2gt
:map <leader>3 3gt
:map <leader>4 4gt
:map <leader>5 5gt
:map <leader>6 6gt
:map <leader>7 7gt
"
"My plugins
"
"
"
call plug#begin('~/.vim/plugged')
Plug 'vimlab/split-term.vim'
Plug 'oblitum/rainbow'
Plug 'NLKNguyen/papercolor-theme'
Plug 'preservim/nerdcommenter'
Plug 'unblevable/quick-scope'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
call plug#end()
"
"rainbow settings
"
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
"
"Terminal settings
"
:set splitbelow
:command T 10Term
"
"Nerd tree
"
:nmap <Leader>] :NERDTreeToggle<CR>
:let g:NERDTreeWinSize=35
"
"Theme settings
"
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': {
  \       'override' : {
  \         'color00' : ['#263238', '15'],
  \         'color07' : ['', '15'],
  \ 		'cursorlinenr_fg' : ['', '208'], 
  \         'cursorlinenr_bg' : ['#263238', ''],
  \         'linenumber_bg' : ['#263238', ''],
  \         'linenumber_fg' : ['', '110']
  \       }
  \     },
  \      'default.light': {
  \        'override' : {
  \         'color00' : ['#ffffb3', ''],
  \ 		'cursorlinenr_fg' : ['', '56'], 
  \         'cursorlinenr_bg' : ['#ffffb3', ''],
  \         'linenumber_bg' : ['#ffffb3', ''],
  \         'linenumber_fg' : ['', '110']
  \       } 
  \     }
  \   }
  \ }
let g:airline_theme='papercolor'
let g:lightline = { 'colorscheme': 'PaperColor' }
set background=dark
colorscheme PaperColor
highlight Normal ctermbg=none
"
"quick-scope
"
let g:qs_highlight_on_keys = ['f', 'F']
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
