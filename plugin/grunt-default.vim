"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/grunt-watch.vim
"VERSION:  0.1
"LICENSE:  MIT

if exists("g:loaded_grunt_default")
    finish
endif
let g:loaded_grunt_default = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:grunt_default_file")
    let g:grunt_default_file = []
endif
if !exists("g:grunt_default_update_ext")
    let g:grunt_default_update_ext = ''
endif
if !exists("g:grunt_default_pause")
    let g:grunt_default_pause = 0
endif

command! GruntDefault call gruntdefault#ManualDefault()
command! GruntEdit call gruntdefault#Edit()
command! GruntCreate call gruntdefault#Create()
command! GruntTemplate call gruntdefault#Template()
command! GruntPause call gruntdefault#Pause()
command! GruntResume call gruntdefault#Resume()
command! GruntStop call gruntdefault#Stop()
command! GruntPlay call gruntdefault#Play()

function! s:SetAutoCmd(files)
    if type(a:files) != 3
        let file = [a:files]
    else
        let file = a:files
    endif

    if file != []
        for e in file
            exec 'au BufWritePost *.'.e.' call gruntdefault#Default()'
        endfor
    endif
    unlet file
endfunction
au VimEnter * call s:SetAutoCmd(g:grunt_default_file)

let &cpo = s:save_cpo
unlet s:save_cpo
