" plugin to handle the TaskPaper to-do list format
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2011-02-15

">=< Buffer Load Guard [[[1 ==================================================
if exists("b:loaded_taskpaper")
    finish
endif
let b:loaded_taskpaper = 1

if !exists('b:undo_ftplugin')
    let b:undo_ftplugin = ''
endif

"add '@' to keyword character set so that we can complete contexts as keywords
setlocal iskeyword+=@-@

"set default folding: by project (syntax), open (up to 99 levels), disabled
setlocal foldmethod=syntax foldlevel=99 nofoldenable wrap textwidth=0


" Set &tabstop and &shiftwidth options for bulleted lists.
setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

" Automatic formatting for bulleted lists.
setlocal formatoptions=tcron

if &ft != 'taskpaper'
    let b:undo_ftplugin .= '
        \ | setlocal tabstop< shiftwidth< expandtab< softtabstop<
        \ | setlocal formatoptions< iskeyword<
        \ | setlocal foldmethod< foldlevel< nofoldenable< wrap< textwidth=0
        \'
endif

map <buffer> <silent> <Leader>td <Plug>ToggleDone
map <buffer> <silent> <Leader>tx <Plug>ToggleCancelled
map <buffer> <silent> <Leader>tc <Plug>ShowContext
map <buffer> <silent> <Leader>ta <Plug>ShowAll
map <buffer> <silent> <Leader>tp <Plug>FoldAllProjects

">=< Script Load Guard [[[1 ==================================================
if exists("g:loaded_taskpaper")
    finish
endif
let g:loaded_taskpaper = 1

" Set up mappings
noremap <unique> <script> <Plug>ToggleDone       :call <SID>ToggleDone()<CR>
noremap <unique> <script> <Plug>ToggleCancelled  :call <SID>ToggleCancelled()<CR>
noremap <unique> <script> <Plug>ShowContext      :call <SID>ShowContext()<CR>
noremap <unique> <script> <Plug>ShowAll          :call <SID>ShowAll()<CR>
noremap <unique> <script> <Plug>FoldAllProjects  :call <SID>FoldAllProjects()<CR>

" Define a default date format
if !exists('task_paper_date_format') | let task_paper_date_format = "%Y-%m-%d" | endif

"show tasks from context under the cursor
fun! s:ShowContext()
    let s:wordUnderCursor = expand("<cword>")
    if(s:wordUnderCursor =~ "@\k*")
        let @/ = "\\<".s:wordUnderCursor."\\>"
        "adapted from http://vim.sourceforge.net/tips/tip.php?tip_id=282
        setlocal foldexpr=(getline(v:lnum)=~@/)?0:1
        setlocal foldmethod=expr foldlevel=0 foldcolumn=1 foldminlines=0
        setlocal foldenable
        setlocal conceallevel=0
    else
        echo "'" s:wordUnderCursor "' is not a context."
    endif
    silent! call repeat#set("\<Plug>ShowContext")
endf

fun! s:ShowAll()
    setlocal foldmethod=syntax
    silent! %foldopen!
    setlocal nofoldenable
    setlocal conceallevel=0

    silent! call repeat#set("\<Plug>ShowAll")
endf

fun! s:FoldAllProjects()
    setlocal foldmethod=syntax
    setlocal foldenable
    setlocal conceallevel=0
    silent! %foldclose!

    silent! call repeat#set("\<Plug>FoldAllProjects")
endf

" toggle @done context tag on a task
fun! s:ToggleDone()

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
endf

" toggle @cancelled context tag on a task
fun! s:ToggleCancelled()

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
endf




">=< Modeline [[[1 ===========================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fmr=[[[,]]] fdm=marker fdl=1 :
