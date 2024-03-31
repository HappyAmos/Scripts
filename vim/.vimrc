filetype plugin indent on
set tabstop=4        " Make tabs 4 spaces wide (does not replace with spaces, that requires expandtab
set shiftwidth=4     " Make the shift + < || > match the tabstop
set nowrap           " do not automatically wrap on load
set formatoptions-=t " do not automatically wrap text when typing
" Don't remember what this does.
set omnifunc=syntaxcomplete#Complete
" Map F5 to save and then run a "build" script in the same directory as the
" source file. 
:map <F5> <Esc>:! ./build<Enter>
" Map F6 to open up the serial app
:map <F6> <Esc>:! gtkterm<Enter>
" vim-powered terminal in split window
":map <F7>:term ++close<cr>
:map <F7> <c-w>:term ++close<cr>

" Enable mouse control in Vim
if has('mouse')
  set mouse=a
endif



