" plugin to handle the TaskPaper to-do list format
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2011-02-15

if exists("loaded_task_paper")
    finish
endif
let loaded_task_paper = 1

" Define a default date format
if !exists('task_paper_date_format') | let task_paper_date_format = "%Y-%m-%d" | endif

"add '@' to keyword character set so that we can complete contexts as keywords
setlocal iskeyword+=@-@

"set default folding: by project (syntax), open (up to 99 levels), disabled 
setlocal foldmethod=syntax
setlocal foldlevel=99
setlocal nofoldenable

"show tasks from context under the cursor
function! s:ShowContext()
    let s:wordUnderCursor = expand("<cword>")
    if(s:wordUnderCursor =~ "@\k*")
        let @/ = "\\<".s:wordUnderCursor."\\>"
        "adapted from http://vim.sourceforge.net/tips/tip.php?tip_id=282
        setlocal foldexpr=(getline(v:lnum)=~@/)?0:1
        setlocal foldmethod=expr foldlevel=0 foldcolumn=1 foldminlines=0
        setlocal foldenable
    else
        echo "'" s:wordUnderCursor "' is not a context."    
    endif
    silent! call repeat#set("\<Plug>ShowContext")
endfunction

function! s:ShowAll()
    setlocal foldmethod=syntax
    %foldopen!
    setlocal nofoldenable

    silent! call repeat#set("\<Plug>ShowAll")
endfunction  

function! s:FoldAllProjects()
    setlocal foldmethod=syntax
    setlocal foldenable
    %foldclose! 
    silent! call repeat#set("\<Plug>FoldAllProjects")
endfunction

" toggle @done context tag on a task
function! s:ToggleDone()

    let line = getline(".")
    if (line =~ '^\s*- ')
        let repl = line
        if (line =~ '@done')
            let repl = substitute(line, "@done\(.*\)", "", "g")
            if &verbose > 1 | echo "undone!" | endif
        else
            let today = strftime(g:task_paper_date_format, localtime())
            let done_str = " @done(" . today . ")"
            let repl = substitute(line, "$", done_str, "g")
            if &verbose > 1 | echo "done!" | endif
        endif
        call setline(".", repl)
    else 
        echo "not a task."
    endif

    silent! call repeat#set("\<Plug>ToggleDone")
endfunction

" toggle @cancelled context tag on a task
function! s:ToggleCancelled()

    let line = getline(".")
    if (line =~ '^\s*- ')
        let repl = line
        if (line =~ '@cancelled')
            let repl = substitute(line, "@cancelled\(.*\)", "", "g")
            echo "uncancelled!"
        else
            let today = strftime(g:task_paper_date_format, localtime())
            let cancelled_str = " @cancelled(" . today . ")"
            let repl = substitute(line, "$", cancelled_str, "g")
            echo "cancelled!"
        endif
        call setline(".", repl)
    else 
        echo "not a task."
    endif

    silent! call repeat#set("\<Plug>ToggleCancelled")
endfunction

" Set up mappings
noremap <unique> <script> <Plug>ToggleDone       :call <SID>ToggleDone()<CR>
noremap <unique> <script> <Plug>ToggleCancelled  :call <SID>ToggleCancelled()<CR>
noremap <unique> <script> <Plug>ShowContext      :call <SID>ShowContext()<CR>
noremap <unique> <script> <Plug>ShowAll          :call <SID>ShowAll()<CR>
noremap <unique> <script> <Plug>FoldAllProjects  :call <SID>FoldAllProjects()<CR>

map <buffer> <silent> <Leader>td <Plug>ToggleDone
map <buffer> <silent> <Leader>tx <Plug>ToggleCancelled
map <buffer> <silent> <Leader>tc <Plug>ShowContext
map <buffer> <silent> <Leader>ta <Plug>ShowAll
map <buffer> <silent> <Leader>tp <Plug>FoldAllProjects
