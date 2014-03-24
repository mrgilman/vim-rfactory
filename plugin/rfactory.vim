let rfactory_fg_methods = ['create', 'build', 'build_stubbed', 'attributes_for']
let method_pattern = '\<\%('. join(rfactory_fg_methods, '\|') . '\)' " Non capturing 'or'
let symbol_pattern = '\(:\w\+\)'
let optional_trait_pattern = '\%(, '.symbol_pattern.'\)\?'
let s:pattern = method_pattern . '.' . symbol_pattern . optional_trait_pattern

function! s:FactoryOnCurrentLine()
  return matchlist(getline('.'), s:pattern)
endfunction

function! s:FactoryFilePath()
  let files = split(glob('spec/**/factories.rb'))
  if len(files)
    return files[0]
  else
    return ''
  endif
endfunction

function! s:Rfactory(edit_method)
  let factory = s:FactoryOnCurrentLine()
  let factory_file_path = s:FactoryFilePath()
  if len(factory) && factory_file_path !=? ''
    let factory_name = factory[1]
    let factory_trait = factory[2]
    execute a:edit_method . ' ' . factory_file_path
    call search('.*factory.' . factory_name)
    if factory_trait !=? ''
      call search('.*trait.' . factory_trait)
    endif
    normal! zz
  else
    " s:ShowErrorMessage('No factory call found on current line.')
  endif
endfunction

command! Rfactory :call <sid>Rfactory('edit')
command! REfactory :call <sid>Rfactory('edit')
command! RSfactory :call <sid>Rfactory('split')
command! RVfactory :call <sid>Rfactory('vsplit')
command! RTfactory :call <sid>Rfactory('tabedit')
