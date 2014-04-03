"=============================================================================
" FILE: spell_suggest.vim
" AUTHOR:  MURAOKA Yusuke <yusuke@jbking.org>
"          Martin Kopischke <martin@kopischke.net>
" Last Change: 2014-04-03.
" License: MIT license  {{{1
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

if ! has('spell')
  finish
endif

function! unite#sources#spell_suggest#define()
  return get(s:, 'unite_source', [])
endfunction

" Define 'substitution' kind: {{{1
" defined here because of its tight coupling to s:cword
let s:unite_kind_substitution                = {'name': 'substitution'}
let s:unite_kind_substitution.default_action = 'replace'
let s:unite_kind_substitution.action_table   = {
  \ 'replace':
  \   {'description': 'replace the current word with the candidate'},
  \ 'replace_all':
  \   {'description': 'replace all occurences of the current word with the candidate'}
  \ }

function! s:unite_kind_substitution.action_table.replace.func(candidate)
  call s:replace_word(s:cword, a:candidate.word)
endfunction

function! s:unite_kind_substitution.action_table.replace_all.func(candidate)
  execute '% substitute/\<'.s:cword.word.'\>/'.a:candidate.word.'/Ig'
endfunction

call unite#define_kind(s:unite_kind_substitution)

" Define source: {{{1
let s:unite_source = {
  \ 'name'        : 'spell_suggest',
  \ 'description' : 'candidates from spellsuggest()',
  \ 'hooks'       : {},
  \ }

" * candidate listing
function! s:unite_source.gather_candidates(args, context)
  if &spell == 0
    return []
  endif

  " get word under cursor
  let s:cword = {}
  let s:cword.word = s:trim(expand('<cword>'))
  let s:cword.line = line('.')
  let s:cword.col  = col('.')

  " get word to base suggestions on
  let l:word = len(a:args) > 0 ?
    \ a:args[0] == '?' ? s:trim(input('Suggest spelling for: ', '', 'history')) : a:args[0] :
    \ s:cword.word

  " get suggestions
  if l:word == ''
    return []
  else
    let l:limit       = get(g:, 'unite_spell_suggest_limit', 0)
    let l:suggestions = l:limit > 0 ? spellsuggest(l:word, l:limit) : spellsuggest(l:word)
    let l:kind        = s:cword.word != '' ? 'substitution' : 'word'
    return map(l:suggestions,
      \'{"word": v:val,
      \  "abbr": printf("%2d: %s", v:key+1, v:val),
      \  "kind": l:kind}')
  endif
endfunction

" * syntax highlighting
function! s:unite_source.hooks.on_syntax(args, context)
  syntax match uniteSource_spell_suggest_LineNr /^\s\+\d\+:/
  highlight default link uniteSource_spell_suggest_LineNr LineNr
endfunction

" Helper functions: {{{1
" * replace word (defined by word, line, col)
function! s:replace_word(word, replacement)
  let l:line = getline(a:word.line)
  let l:col  = match(l:line[:a:word.col], '\<\w\+$')
  if l:col > -1
    call setline(a:word.line, l:line[:l:col-1] . a:replacement . l:line[l:col+len(a:word.word):])
  endif
endfunction

" * trim leading and trailing whitespace
function! s:trim(string)
  return matchstr(a:string, '\S.\+\S')
endfunction
" }}}
" vim:set sw=2 sts=2 ts=8 et fdm=marker fdo+=jump fdl=1:
