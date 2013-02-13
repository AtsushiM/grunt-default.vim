"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/grunt-default.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

let g:grunt_default_plugindir = expand('<sfile>:p:h:h').'/'
let g:grunt_default_templatedir = g:grunt_default_plugindir.'template/'
let g:grunt_default_stoptext = '// grunt-default stopped.'

if !exists("g:grunt_default_cdloop")
    let g:grunt_default_cdloop = 5
endif
if !exists("g:grunt_default_makefile")
    let g:grunt_default_makefile = 'grunt.js'
endif
if !exists("g:grunt_default_cmd")
    let g:grunt_default_cmd = 'grunt&'
endif
if !exists("g:grunt_default_manural_cmd")
    let g:grunt_default_manural_cmd = 'grunt'
endif
if !exists("g:grunt_default_makefiledir")
    let g:grunt_default_makefiledir = $HOME.'/.gruntdefault/'
endif

if !isdirectory(g:grunt_default_makefiledir)
    call mkdir(g:grunt_default_makefiledir)
    call system('cp '.g:grunt_default_templatedir.'* '.g:grunt_default_makefiledir)
endif

function! gruntdefault#Stop()
    let dir = gruntdefault#Search()
    let filename = dir.g:grunt_default_makefile

    let makefile = readfile(filename)

    if makefile[0] != g:grunt_default_stoptext
        let makefile = insert(makefile, g:grunt_default_stoptext)
        call writefile(makefile, filename)
    endif
endfunction

function! gruntdefault#Play()
    let dir = gruntdefault#Search()
    let filename = dir.g:grunt_default_makefile

    let makefile = readfile(filename)

    if makefile[0] == g:grunt_default_stoptext
        call remove(makefile, 0)
        call writefile(makefile, filename)
    endif
endfunction

function! gruntdefault#Pause()
    let g:grunt_default_pause = 1
endfunction

function! gruntdefault#Resume()
    let g:grunt_default_pause = 0
endfunction

function! gruntdefault#Search()
    let i = 0
    let dir = expand('%:p:h').'/'
    while i < g:grunt_default_cdloop
        if !filereadable(dir.g:grunt_default_makefile)
            let i = i + 1
            let dir = dir.'../'
        else
            break
        endif
    endwhile

    if i != g:grunt_default_cdloop
        return dir
    endif
    return ''
endfunction

function! gruntdefault#Search()
    let i = 0
    let dir = expand('%:p:h').'/'
    while i < g:grunt_default_cdloop
        if !filereadable(dir.g:grunt_default_makefile)
            let i = i + 1
            let dir = dir.'../'
        else
            break
        endif
    endwhile

    if i != g:grunt_default_cdloop
        return dir
    endif
    return ''
endfunction

function! gruntdefault#Default()
    let dir = gruntdefault#Search()
    if dir != '' && g:grunt_default_pause == 0
        let org = getcwd()
        exec 'silent cd '.dir

        let makefile = readfile(g:grunt_default_makefile)
        if makefile[0] != g:grunt_default_stoptext
            silent call system(g:grunt_default_cmd)
        endif

        exec 'silent cd '.org
    endif

endfunction

function! gruntdefault#ManualDefault()
    let dir = gruntdefault#Search()
    if dir != ''
        let org = getcwd()
        exec 'silent cd '.dir
        let er = system(g:grunt_default_manural_cmd)
        exec 'silent cd '.org

        if er != ''
            setlocal errorformat=%f:%l:%m
            cgetexpr er
            copen
        else
            copen
        endif
    endif
endfunction

function! gruntdefault#Edit()
    let dir = gruntdefault#Search()
    if dir != ''
        exec 'e '.dir.g:grunt_default_makefile
    endif
endfunction

function! gruntdefault#Template()
    if !filereadable(g:grunt_default_makefiledir.g:grunt_default_makefile)
        let org = getcwd()
        exec 'cd '.g:grunt_default_makefiledir
        call writefile([], g:grunt_default_makefile)
        exec 'cd '.org
    endif

    exec 'e '.g:grunt_default_makefiledir.g:grunt_default_makefile
endfunction

function! gruntdefault#Create()
    if !filereadable(g:grunt_default_makefile)
        if filereadable(g:grunt_default_makefiledir.g:grunt_default_makefile)
            call writefile(readfile(g:grunt_default_makefiledir.g:grunt_default_makefile), g:grunt_default_makefile)
        else
            call writefile([], g:grunt_default_makefile)
        endif
        exec 'e '.g:grunt_default_makefile
    endif
endfunction

let &cpo = s:save_cpo
