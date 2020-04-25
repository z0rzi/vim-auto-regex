
nnoremap <LEADER>r<LEFT> :<C-u>call autoRegex#moveStart(-1)<CR>
nnoremap <LEADER>r<RIGHT> :<C-u>call autoRegex#moveEnd(1)<CR>

nnoremap <LEADER>r<LEFT><RIGHT> :<C-u>call autoRegex#moveStart(1)<CR>
nnoremap <LEADER>r<LEFT><LEFT> :<C-u>call autoRegex#moveStart(-1)<CR>

nnoremap <LEADER>r<RIGHT><RIGHT> :<C-u>call autoRegex#moveEnd(1)<CR>
nnoremap <LEADER>r<RIGHT><LEFT> :<C-u>call autoRegex#moveEnd(-1)<CR>

nnoremap <LEADER>ru :<C-u>call autoRegex#undo()<CR>
nnoremap <LEADER>ru :<C-u>call autoRegex#undo()<CR>

vnoremap <LEADER>r :<C-u>/\%V.<CR>
