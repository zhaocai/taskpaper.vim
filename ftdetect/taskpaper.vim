" Vim filetype detection file
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2011-03-28
"
augroup ftdetect_taskpaper
    au!
    au! BufRead,BufNewFile *.taskpaper   setfiletype taskpaper | setlocal noexpandtab
augroup END
