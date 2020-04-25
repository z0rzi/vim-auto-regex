
function! s:parseSubRegex(in)
    let res = split(a:in, '\\(\w\+\\)\\{0}', 'g')
    call map(res, {_, val -> substitute(val, '^.*\(\\z\w\).*$', '\1', '')})
    return res
endfunction!

function! s:parseRegex(in)
    let before = matchstr(a:in, '^.*\ze\\(S\\)\\{0}')
    let after = matchstr(a:in, '\\(E\\)\\{0}\zs.*$')

    let body = matchstr(a:in, '\\(S\\)\\{0}\zs.*\ze\\(E\\)\\{0}')
    if ! len(body)
        let body = matchstr(a:in, '^.*\ze\\(E\\)\\{0}')
    endif
    if ! len(body)
        let body = matchstr(a:in, '\\(S\\)\\{0}\zs.*$')
    endif
    if ! len(body)
        let body = matchstr(a:in, '^.*$')
    endif

    let before = substitute(before, '^.\{-}\\zs', '', '')
    let before = s:parseSubRegex(before)
    let after = s:parseSubRegex(after)

    let g:before = before
    let g:after = after
    
    return [before, body, after]
endfunction

function s:formRegex(before, body, after)
    if index(a:after, '\zs') >= 0
        let prefix = ''
    else
        let prefix = '\(\('.a:body.'\)\@!<.\)*\(.\('.a:body.'\)\@!\)*\zs'
    endif
    let idx = index(a:after, '\zs')
    if idx >= 0
        let a:after[idx] = '.\{-\}\<\zs'
    endif
    let idx = index(a:before, '\ze')
    if idx >= 0
        let a:before[idx] = '\ze\>.\{-\}'
    endif
    return prefix . join(a:before, '\(W\)\{0}') . '\(S\)\{0}' . a:body . '\(E\)\{0}' . join(a:after, '\(W\)\{0}')
endfunction

function autoRegex#moveEnd(way)
    let [before, body, after] = s:parseRegex(@/)

    let index = index(before, '\ze')
    if index >= 0
        call remove(before, index)
        if a:way > 0
            if index+1 < len(before)
                call insert(before, '\ze', index+1)
            endif
        else
            if index > 0
                call insert(before, '\ze', index-1)
            else
                call insert(before, '\ze')
            endif
        endif
    else
        if a:way > 0
            call add(after, '.\{-1,}\>')
        else
            if len(after)
                call remove(after, len(after)-1)
            else
                call add(before, '\ze')
            endif
        endif
    endif


    let @/ = s:formRegex(before, body, after)
    call histadd('/', @/)
endfunction

function autoRegex#moveStart(way)
    let [before, body, after] = s:parseRegex(@/)


    let index = index(after, '\zs')
    if index >= 0
        call remove(after, index)
        if a:way < 0
            if index > 0
                call insert(after, '\zs', index-1)
            endif
        else
            if index < len(after)
                call insert(after, '\zs', index+1)
            else
                call add(after, '\zs')
            endif
        endif
    else
        if a:way < 0
            call insert(before, '\<.\{-1,}')
        else
            if len(before)
                call remove(before, 0)
            else
                call insert(after, '\zs')
            endif
        endif
    endif

    let @/ = s:formRegex(before, body, after)
    call histadd('/', @/)
endfunction

function! autoRegex#undo()
    let nr = histnr('/')
    while histget('/', nr) != @/ && nr > 0
        call histdel('/', nr)
        let nr -= 1
    endwhile
    call histdel('/', nr)

    let @/ = histget('/', nr - 1)
endfunction

