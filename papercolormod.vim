let g:airline#themes#papercolormod#palette = {}

let g:airline#themes#papercolormod#palette.accents = {
      \ 'red': [ '#66d9ef' , '' , 81 , '' , '' ],
      \ }

" Normal Mode:
let s:N1 = [ '#263238' , '#e4e4e4' , 240 , 254 ] " Mode
let s:N2 = [ '#263238' , '#e9ae49' , 254 , 31  ] " Info
let s:N3 = [ '#263238' , '#eec277' , 255 , 24  ] " StatusLine


let g:airline#themes#papercolormod#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#papercolormod#palette.normal_modified = {
      \ 'airline_c': [ '#263238' , '#eec277' , 255 , 24 , '' ] ,
      \ }


" Insert Mode:
let s:I1 = [ '#263238' , '#e4e4e4' , 240 , 254 ] " Mode
let s:I2 = [ '#263238' , '#e9ae49' , 254 , 31  ] " Info
let s:I3 = [ '#263238' , '#eec277' , 255 , 24  ] " StatusLine


let g:airline#themes#papercolormod#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#papercolormod#palette.insert_modified = {
      \ 'airline_c': [ '#263238' , '#eec277' , 255 , 24 , '' ] ,
      \ }


" Replace Mode:
let g:airline#themes#papercolormod#palette.replace = copy(g:airline#themes#papercolormod#palette.insert)
let g:airline#themes#papercolormod#palette.replace.airline_a = [ '#d7005f'   , '#e4e4e4' , 161 , 254, ''     ]
let g:airline#themes#papercolormod#palette.replace_modified = {
      \ 'airline_c': [ '#263238' , '#eec277' , 255 , 24 , '' ] ,
      \ }


" Visual Mode:
let s:V1 = [ '#eec277', '#e4e4e4', 24,  254 ]
let s:V2 = [ '',        '#e9ae49', '',  31  ]
let s:V3 = [ '#263238', '#eec277', 254, 24  ]

let g:airline#themes#papercolormod#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#papercolormod#palette.visual_modified = {
      \ 'airline_c': [ '#e4e4e4', '#eec277', 254, 24  ] ,
      \ }

" Inactive:
let s:IA = [ '#263238' , '#e4e4e4' , 240 , 254 , '' ]
let g:airline#themes#papercolormod#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#papercolormod#palette.inactive_modified = {
      \ 'airline_c': [ '#263238' , '#e4e4e4' , 240 , 254 , '' ] ,
      \ }


" CtrlP:
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#papercolormod#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ '#263238' , '#eec277' , 254 , 24  , ''     ] ,
      \ [ '#263238' , '#e9ae49' , 254 , 31  , ''     ] ,
      \ [ '#263238' , '#e4e4e4' , 240 , 254 , 'bold' ] )

