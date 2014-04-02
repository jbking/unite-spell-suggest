## Unite spelling suggestion source

A [unite.vim](https://github.com/Shougo/unite.vim) source that displays Vim’s spelling suggestions for a word.

### Usage

No Vim documentation, but `:Unite spell_suggest[:word]` will display a list of suggestions in the Unite interface. The selected candidate will replace the word under the cursor, if there was any, else Unite’s default word handling applies.

* without an argument, suggestions are based on the word under the cursor;
* an argument of `?` will prompt for a word to base suggestions on;
* set `g:unite_spell_suggest_limit` to limit the number of suggestions retrieved by Vim’s `spellsuggest()` (by default, this variable is unset).

### Caveats

Vim’s `spellsuggest()` only returns suggestions if `spell` is set in the current buffer (see `:h spellsuggest()`), and hence the Unite source will remain empty if it is unset. Use the `-no-empty` option to skip empty suggestion lists.
