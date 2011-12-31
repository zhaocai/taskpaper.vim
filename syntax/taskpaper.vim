" Vim syntax file
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2011-02-15

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if version < 508
  command! -nargs=+ HiLink hi link <args>
else
  command! -nargs=+ HiLink hi def link <args>
endif

let b:has_conceal = has('conceal')

" syn case ignore

syn region taskpaperProject matchgroup=taskpaperProject start=/^\t*\%(\u[^:]\+\)/ end=/:\%(\s\+@\w\+\%((.*)\)\=\)\{-}$/ oneline contains=taskpaperContextText

syn region taskpaperProjectFold start=/\_^\t*\%(.\+:\)/ end=/\_^\s*\_$/ transparent fold

syn region taskpaperContextText start=/\s\+@/ end=/\%(\w\+\%((.*)\)\=\)\_s/ transparent oneline contained containedin=taskpaperProject,taskpaperTask contains=taskpaperContext,taskpaperContextProperty
syn region taskpaperContext matchgroup=taskpaperDelimiter start=/@\%(\w\+\)\@=/ end=/\%(\_s\|(\)\@=/  contained oneline containedin=taskpaperContextText
syn region taskpaperContextProperty matchgroup=taskpaperDelimiter start="(" end=")" contained containedin=taskpaperContextText

syn region taskpaperTask matchgroup=taskpaperTaskDelimiter start=/^\%(\t\+\)[-+]\%(\s\+\)/ end=/\s*$/ oneline keepend contains=taskpaperDone,taskpaperCancelled,taskpaperContextText
syn match taskpaperDone /\w.*\%(@[Dd]one\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=taskpaperTask conceal cchar=⚡ contains=taskpaperContextText
syn match taskpaperCancelled /\w.*\%(@[Cc]ance[l]\{1,2}ed\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=taskpaperTask conceal cchar=⌇ contains=taskpaperContextText


syn sync fromstart

HiLink taskpaperProject         Title
HiLink taskpaperContext         Underlined
HiLink taskpaperContextProperty Identifier
HiLink taskpaperTask            String
HiLink taskpaperTaskDelimiter   SpecialChar
HiLink taskpaperDone            Conceal
HiLink taskpaperCancelled       Ignore
HiLink taskpaperDelimiter       Delimiter

" syn match  taskpaperLineContinue ".$" contained
" syn match  taskpaperComment "^.*$"
" HiLink taskpaperComment         Normal



let b:current_syntax = "taskpaper"
delcommand HiLink
" vim: ts=8
