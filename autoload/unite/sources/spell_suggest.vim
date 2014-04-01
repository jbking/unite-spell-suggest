"=============================================================================
" FILE: spell_suggest.vim
" AUTHOR:  MURAOKA Yusuke <yusuke@jbking.org>
" Last Change: 29-Sep-2011.
" License: MIT license  {{{
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

let s:unite_source = {
  \ 'name': 'spell_suggest',
  \ 'description': 'candidates from spellsuggest()',
  \ 'default_kind': 'word',
  \ }

function! s:unite_source.gather_candidates(args, context)
  let l:word = get(a:, 'args[0]', expand('<cword>'))
  if l:word == ''
    echohl WarningMsg | echomsg 'spell_suggest: no word to base spelling suggestions on.' | echohl None
    return []
  endif
  let l:limit = get(g:, 'unite_spell_suggest_limit', 25)
  return map(spellsuggest(l:word, l:limit), '{ "word": v:val }')
endfunction

function! unite#sources#spell_suggest#define()
  return s:unite_source
endfunction
