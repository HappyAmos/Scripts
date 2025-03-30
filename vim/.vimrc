
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

" Custom <F2> mapping to open vim-powered terminal in split window
:map <F2> <c-w>:term ++close<cr>

" Custom <F3> mapping to split window
:map <F3> <Esc> :split <Enter>

" Custom <F4> mapping to pause vim (type fg to resume)
:map <F4> <c-z>

" Custom <F5> mapping based on file extension
" ** Old mapping was :map <F5> <Esc>:! ./build<Enter>
let extension = expand('%:e')
let python = (extension == "py")
let cpp = (extension == "cpp")
let go = (extension == "go")
let rust = (extension == "rs")
if (python == v:true)
	" echo 'Python mapped to <F5>'
	:map <F5> <Esc>:! python %<Enter>
endif
if (cpp == v:true)
	" echo 'g++ mapped to <F5>'
	:map <F5> <Esc>:! g++ -ggdb -Werror % -o %:r<Enter>./%:r
endif
if (go == v:true)
	" echo 'Go run mapped to <F5>'
	:map <F5> <Esc>:! go run .<Enter>
endif
if (rust == v:true)
	" echo 'Rust cargo run mapped to <F5>'
	:map <F5> <Esc>:! cargo run<Enter>
endif

" Custom <F6> mapping for building apps
if (go == v:true)
	" echo 'Go build mapped to <F6>'
	:map <F6> <Esc>:! go build .<Enter>
endif
if (rust == v:true)
	" echo 'Rust cargo check to <F6>'
	:map <F6> <Esc>:! cargo check<Enter>
endif

" Custom <F7> mapping to open serial terminal app
:map <F7> <Esc>:! gtkterm<Enter>

" Custom <F8> mapping to drop to shell
:map <F8> <Esc>:shell<Enter>
