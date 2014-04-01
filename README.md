## Unite spelling suggestion source \[WIP]

A [unite.vim](https://github.com/Shougo/unite.vim) source that displays Vim’s spelling suggestions for the word passed as an argument, or the word under the cursor if no argument is passed.

### Usage

No Vim documentation yet, but `:Unite spell_suggest[:word]` will display a list of suggestions in the Unite interface. The selected candidate will be yanked, pending further development and a more useful solution. 

Set `g:unite_spell_suggest_limit` to limit the number of suggestions displayed (by default, this variable is unset and all suggestions returned by Vim are displayed).
