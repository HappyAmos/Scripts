filetype plugin indent on
set tabstop=4        " Make tabs 4 spaces wide (does not replace with spaces, that requires expandtab
set shiftwidth=4     " Make the shift + < || > match the tabstop
set nowrap           " do not automatically wrap on load
set formatoptions-=t " do not automatically wrap text when typing
" Don't remember what this does.
set omnifunc=syntaxcomplete#Complete

" Enable mouse control in Vim
if has('mouse')
  set mouse=a
endif

" Custom <F5> mapping based on file extension
" ** Old mapping was :map <F5> <Esc>:! ./build<Enter>
let extension = expand('%:e')
let python = (extension == "py")
if (python == v:true)
	" echo 'Python mapped to <F5>'
	:map <F5> <Esc>:! python %<Enter>
else
	" echo 'Not Python, nothing mapped to <F5>'
endif

" Custom <F6> mapping to open serial terminal app
:map <F6> <Esc>:! gtkterm<Enter>

" Custom <F7> mapping to open vim-powered terminal in split window
:map <F7> <c-w>:term ++close<cr>


