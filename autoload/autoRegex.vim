
function! AutoRegex#expandRegex(way, word)
    let l:currentRegex = @/
    let @/ = currentRegex . '.\{-1,}\>'
endfunction
