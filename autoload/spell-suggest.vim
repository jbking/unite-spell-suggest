if ! has('spell')
    finish
endif

let s:unite_source = {
            \ 'name': 'spell_suggest',
            \ 'is_volatile': 1,
            \ }
let g:unite_spell_suggest_limit = 5

function! s:unite_source.gather_candidates(args, context)
    return map(spellsuggest(a:context.input, g:unite_spell_suggest_limit), '{
                \ "word": v:val,
                \ "source": "spell_suggest",
                \ "kind": "word",
                \ }')
endfunction

call unite#define_source(s:unite_source)
