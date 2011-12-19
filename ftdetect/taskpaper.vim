" Vim filetype detection file
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2011-03-28
"
"===  Load Guard  {{{1 =======================================================
if !zlib#rc#script_load_guard('ftdetect_' . expand('<sfile>:t:r'), 700, 100, [])
    finish
endif
"
augroup taskpaper
     au! BufRead,BufNewFile *.taskpaper   setfiletype taskpaper
     au FileType taskpaper setlocal noexpandtab
augroup END
