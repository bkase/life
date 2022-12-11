  set nocompatible

  set modelines=0

  " directory
  set directory=/home/bkase/.vim

  " disable backups (and swap)
  set nobackup
  set nowritebackup
  set noswapfile

  " wrap searches
  set wrapscan

  " tab and indentation
  set tabstop=2
  set softtabstop=2
  set noexpandtab
  set smarttab
  set shiftwidth=2
  set backspace=indent,eol,start
  set autoindent
  set smartindent
  set hidden
  set wildmenu
  set wildmode=list:longest
  set ttyfast
  set nopaste
  set cursorline
  set laststatus=2
  set undofile

  " show commands
  set showcmd

  " yank to paste buffer
  set clipboard=unnamedplus

  " show line and column position of cursor
  set ruler

  " status bar
  set statusline=\ \%f%m%r%h%w\ ::\ %y\ [%{&ff}]\%=\ [%p%%:\ %c,%l/%L]\
  "set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
  set laststatus=2
  set cmdheight=1

  " textwidth
  "set textwidth=80

  " formatting options
  set formatoptions=c,q,r,t

  " line numbers
  set number

  " search
  set incsearch
  set ignorecase
  set smartcase

  " syntax highlighting
  filetype plugin on
  syntax on

  " enable mouse
  set mouse=a

  "set colorscheme
  colorscheme solarized

  "allows sudo with :w!!
  cmap w!! %!sudo tee > /dev/null %

  " auto indent
  filetype plugin indent on

  " leader key to ,
  let mapleader=","
  let maplocalleader=","

  " maintain more context around cursor
  set scrolloff=3

  " VERY useful remap
  nnoremap ; :
  nnoremap j gj
  nnoremap k gk
  "nnoremap s l
  "nnoremap l s
  "vnoremap s l
  nnoremap <up> <nop>
  nnoremap <down> <nop>
  nnoremap <left> <nop>
  nnoremap <right> <nop>
  inoremap <up> <nop>
  inoremap <down> <nop>
  inoremap <left> <nop>
  inoremap <right> <nop>

  " fix regex so it's like perl/python
  nnoremap / /\v
  vnoremap / /\v

  " map tab to %
  nnoremap <tab> %

  " hides buffers instead of closing them
  set hidden

  set history=1000   " remember more commands and search history
  set undolevels=1000 " use many levels of undo
  set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,*.so
  "set title "terminal title

  " Shows spaces as you're writing
  set list
  set listchars=tab:»·,trail:·,extends:⟩,precedes:⟨
  set fillchars+=vert:\ ,stl:\ ,stlnc:\

  set pastetoggle=<F2>

  " Help key annoyance
  inoremap <F1> <ESC>
  nnoremap <F1> <ESC>
  vnoremap <F1> <ESC>

  " auto-save on leaving focus
  au FocusLost * :wa

  " remove trailing whitespace
  nnoremap <leader>W :%s/\s\+$//<cr>:let @/=\'\'<CR>

  " reselect things just pasted
  nnoremap <leader>v V`]

  " quick exit from insert
  inoremap jj <ESC>

  " open a new split and go to it ,w
  nnoremap <leader>w <C-w>v<c-w>l

  " remap for C-moving windowsing
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l

  " Tex-Live grep fix
  set grepprg=grep\ -nH\ $*

  " Python stuff
  autocmd BufRead,BufNewFile *.py set ai
  autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class

  " indent-guides config
  set ts=2 sw=2 et
  let g:indent_guides_guide_size = 1
  let g:indent_guides_auto_colors = 0
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=darkgrey   ctermbg=darkgrey
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=grey ctermbg=grey

  " HACK: fix broken paste by making it explicit
  nnoremap p ""p
  nnoremap P ""P

  " macro expansion technology
  autocmd BufRead,BufNewFile * :inoremap <buffer> <leader>; <C-O>/\v\<\+\+\><CR><C-O>c4l
  autocmd BufRead,BufNewFile * :nnoremap <buffer> <leader>; /\v\<\+\+\><CR>c4l

  "LaTeX
  "auto recompile upon save
  autocmd BufWritePost *.tex !pdflatex %
  "awesome macros
  autocmd BufRead,BufNewFile *.tex :inoremap `s \sum_{<++>}^{<++>}<++><C-O>/\v\<\+\+\><CR><C-O>c4l
  autocmd BufRead,BufNewFile *.tex :inoremap `m \mathbb{<++>}<++><C-O>/\v\<\+\+\><CR><C-O>c4l
  autocmd BufRead,BufNewFile *.tex :inoremap `v \verb~<++>~<++><C-O>/\v\<\+\+\><CR><C-O>c4l
  autocmd BufRead,BufNewFile *.tex :inoremap `a \begin{align*}<CR><++><CR>\end{align*}<C-O>/\v\<\+\+\><CR><C-O>c4l

  "make sig files have proper highlighting
  autocmd BufRead,BufNewFile *.sig set filetype=sml
  autocmd BufRead,BufNewFile sources.cm set filetype=sml
  autocmd BufRead,BufNewFile *.ispc set filetype=ispc
  autocmd BufRead,BufNewFile *todo.txt set filetype=todo.txt

  "make solarized dark the default
  set bg=dark

  function! LightlineModified()
    return &ft =~ 'help\|vimfiler\|gundo' ? "" : &modified ? '+' : &modifiable ? "" : '-'
  endfunction

  function! LightlineReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ""
  endfunction

  function! LightlineFilename()
    return ("" != LightlineReadonly() ? LightlineReadonly() . ' ' : "") .
          \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
          \  &ft == 'unite' ? unite#get_status_string() :
          \  &ft == 'vimshell' ? vimshell#get_status_string() :
          \ "" != expand('%:t') ? expand('%:t') : '[No Name]') .
          \ ("" != LightlineModified() ? ' ' . LightlineModified() : "")
  endfunction

  function! LightlineFugitive()
    if &ft !~? 'vimfiler\|gundo' && exists("b:gitsigns_head")
      let branch = b:gitsigns_head
      return branch !=# "" ? ' '.branch : ""
    endif
    return ""
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > 70 ? &fileformat : ""
  endfunction

  function! LightlineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# "" ? &filetype : 'no ft') : ""
  endfunction

  function! LightlineMode()
    return winwidth(0) > 60 ? lightline#mode() : ""
  endfunction

  let g:lightline#lsp#indicator_hints = "\uf002"
  let g:lightline#lsp#indicator_infos = "\uf129"
  let g:lightline#lsp#indicator_warnings = "\uf071"
  let g:lightline#lsp#indicator_errors = "\uf05e"
  let g:lightline#lsp#indicator_ok = "\uf00c"

  let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'mode_map': { 'c': 'NORMAL' },
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
    \   'right': [ [ 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_hints', 'linter_ok'],
    \              [ 'lineinfo' ],
    \              [ 'percent' ] ],
    \ },
    \ 'component_expand': {
    \   'linter_hints': 'lightline#lsp#hints',
    \   'linter_infos': 'lightline#lsp#infos',
    \   'linter_warnings': 'lightline#lsp#warnings',
    \   'linter_errors': 'lightline#lsp#errors',
    \   'linter_ok': 'lightline#lsp#ok',
    \  },
    \ 'component': {
    \   'lineinfo': ' %3l:%-2v',
    \ },
    \ 'component_function': {
    \   'readonly': 'LightlineReadonly',
    \   'fileformat': 'LightlineFileformat',
    \   'fugitive': 'LightlineFugitive',
    \   'modified': 'LightlineModified',
    \   'mode': 'LightlineMode',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }


  let g:neoformat_haskell_ormolu = { 'exe': 'ormolu', 'args': [] }

  let g:neoformat_enabled_haskell = ['ormolu']

  let g:neoformat_nix_nixpkgsfmt = { 'exe': 'nixpkgs-fmt', 'args': [], 'replace': 1 }
  let g:neoformat_enabled_nix = ['nixpkgsfmt']
  " Disable dhall auto-format by default
  let g:neoformat_enabled_dhall = []

  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END

  " Enable merlin on ReasonML too
  " autocmd! FileType reason call merlin#Register() | let g:ycm_semantic_triggers.reason = ['.']

  " COQ completion
  let g:coq_settings = { 'xdg': v:true, 'display.pum.y_max_len': 25, 'display.pum.y_ratio': 0.5, 'display.pum.x_max_len': 80 }

  " CoC completion
  " Smaller updatetime for CursorHold & CursorHoldI
  set updatetime=300
  " don't give |ins-completion-menu| messages.
  "set shortmess+=c
  " always show signcolumns
  "set signcolumn=yes
  "let g:coc_snippet_next="\<C-l>"
  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  "inoremap <silent><expr> <TAB>
  "      \ pumvisible() ? "\<C-n>" :
  "      \ <SID>check_back_space() ? "\<TAB>" :
 " "      \ coc#refresh()
"   inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"   function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~# '\s'
"   endfunction

   " Use <c-space> for trigger completion.
"   inoremap <silent><expr> <c-space> coc#refresh()

   " Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
   " Coc only does snippet and additional edit on confirm.
"   inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

   " Expand error
"   nmap <silent> <leader>d <Plug>(coc-diagnostic-info)
   " Use `[c` and `]c` for navigate diagnostics
   "nmap <silent> [c <Plug>(coc-diagnostic-prev)
"   nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
"   nmap <silent> gd <Plug>(coc-definition)
"   nmap <silent> gy <Plug>(coc-type-definition)
"   nmap <silent> gi <Plug>(coc-implementation)
"   nmap <silent> gr <Plug>(coc-references)
"
  " Documentation
"   nnoremap <silent> K :call <SID>show_documentation()<CR>

"   function! s:show_documentation()
"     if &filetype == 'vim'
"       execute 'h '.expand('<cword>')
"     else
"       call CocAction('doHover')
"     endif
"   endfunction
"
  " Fix autofix problem of current line
"   nmap <leader>qf  <Plug>(coc-fix-current)

"   let g:coc_status_error_sign = "✘"
"   let g:coc_status_warning_sign = "⚠"
"   highlight clear CocErrorSign
"   highlight clear CocWarningSign
"   highlight clear CocInfoSign
"   highlight clear CocHintSign
"   highlight CocErrorSign ctermbg=0
""   highlight CocWarningSign ctermbg=0
"   highlight CocInfoSign ctermbg=0
"   highlight CocHintSign ctermbg=0
"
  " END coc

  nnoremap gt :bnext<CR>
  nnoremap gT :bprevious<CR>
  nnoremap <c-p> :Files<CR>
  nnoremap <leader>b :Buffers<CR>
  nnoremap <leader>/ :BLines<CR>
  nnoremap <leader>r :GFiles?<CR>
  nnoremap <leader>g :GGrep<CR>
  " for fzf-lsp
  nnoremap <leader>E :Diagnostics<CR>
  nnoremap <leader>q :References<CR>
  nnoremap <leader>s :DocumentSymbols<CR>
  nnoremap <leader>d :Definitions<CR>
  hi DiagnosticHint ctermfg=11
  hi DiagnosticInfo ctermfg=11
  hi DiagnosticWarn ctermfg=3
  hi DiagnosticError ctermfg=1

  " fix gutter colors
  hi SignColumn ctermbg=0

  let g_fzf_layout = { 'down': '~40%' }
  set rtp+=~/.fzf

  if executable('rg')
    " Use rg over grep
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
    endif

  let g:fzf_files_options =
    \ '--preview "(highlight -O ansi {} | cat {}) 2> /dev/null | head -'.&lines.'"'

  command! -bang -nargs=* GGrep
   \ call fzf#vim#grep(
   \   'git grep --recurse-submodules --line-number '.shellescape(<q-args>), 0,
   \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

  " Golang wants REAL TABS
  autocmd FileType go autocmd BufWritePre <buffer> Fmt

  "
  " HASKELL
  "

  " Pretty unicode haskell symbols
  let g:haskell_conceal_wide = 1
  let g:haskell_conceal_enumerations = 1
  let hscoptions="𝐒𝐓𝐄𝐌xRtB𝔻w"

  " Return to last edit position when opening files (You want this!)
  augroup last_edit
    autocmd!
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif
  augroup END

  " Stop Align plugin from forcing its mappings on us
  let g:loaded_AlignMapsPlugin=1
  " Align on equal signs
  map <Leader>a= :Align =<CR>
  " Align on commas
  map <Leader>a, :Align ,<CR>
  " Align on pipes
  map <Leader>a<bar> :Align <bar><CR>
  " Prompt for align character
  map <leader>ap :Align

  " Enable some tabular presets for Haskell
  let g:haskell_tabular = 1

  " Conversion {{{

  function! Pointfree()
    call setline('.', split(system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
  endfunction
  vnoremap <silent> <leader>h. :call Pointfree()<CR>

  function! Pointful()
    call setline('.', split(system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
  endfunction
  vnoremap <silent> <leader>h> :call Pointful()<CR>

  " }}}

  " Tags {{{

  set tags=tags;/,codex.tags;/

  let g:tagbar_type_haskell = {
      \ 'ctagsbin'  : 'hasktags',
      \ 'ctagsargs' : '-x -c -o-',
      \ 'kinds'     : [
          \  'm:modules:0:1',
          \  'd:data: 0:1',
          \  'd_gadt: data gadt:0:1',
          \  't:type names:0:1',
          \  'nt:new types:0:1',
          \  'c:classes:0:1',
          \  'cons:constructors:1:1',
          \  'c_gadt:constructor gadt:1:1',
          \  'c_a:constructor accessors:1:1',
          \  'ft:function types:1:1',
          \  'fi:function implementations:0:1',
          \  'o:others:0:1'
      \ ],
      \ 'sro'        : '.',
      \ 'kind2scope' : {
          \ 'm' : 'module',
          \ 'c' : 'class',
          \ 'd' : 'data',
          \ 't' : 'type'
      \ },
      \ 'scope2kind' : {
          \ 'module' : 'm',
          \ 'class'  : 'c',
          \ 'data'   : 'd',
          \ 'type'   : 't'
      \ }
  \ }

  " Generate haskell tags with codex and hscope
  "map <leader>tg :!codex update --force<CR>:call system("git-hscope -X TemplateHaskell")<CR><CR>:call LoadHscope()<CR>

  "map <leader>tt :TagbarToggle<CR>

  set csprg=hscope
  set csto=1 " search codex tags first
  set cst
  set csverb
  nnoremap <silent> <C-\> :cs find c <C-R>=expand("<cword>")<CR><CR>
  " Automatically make cscope connections
  function! LoadHscope()
    let db = findfile("hscope.out", ".;")
    if (!empty(db))
      let path = strpart(db, 0, match(db, "/hscope.out$"))
      set nocscopeverbose " suppress 'duplicate connection' error
      exe "cs add " . db . " " . path
      set cscopeverbose
    endif
  endfunction
  au BufEnter /*.hs call LoadHscope()

  " }}}

  " Haskell Interrogation {{{

  " Disable hlint-refactor-vim's default keybindings
  let g:hlintRefactor#disableDefaultKeybindings = 1

  " hlint-refactor-vim keybindings
  map <silent> <leader>hr :call ApplyOneSuggestion()<CR>
  map <silent> <leader>hR :call ApplyAllSuggestions()<CR>

  " Show types in completion suggestions
  let g:necoghc_enable_detailed_browse = 1
  " Resolve ghcmod base directory
  au FileType haskell let g:ghcmod_use_basedir = getcwd()

  " Type of expression under cursor
  nmap <silent> <leader>ht :GhcModType<CR>
  " Insert type of expression under cursor
  nmap <silent> <leader>hT :GhcModTypeInsert<CR>
  " GHC errors and warnings
  "nmap <silent> <leader>hc :Neomake ghcmod<CR>

  " open the neomake error window automatically when an error is found
  let g:neomake_open_list = 2

  " Fix path issues from vim.wikia.com/wiki/Set_working_directory_to_the_current_file
  let s:default_path = escape(&path, '\ ') " store default value of 'path'
  " Always add the current file's directory to the path and tags list if not
  " already there. Add it to the beginning to speed up searches.
  autocmd BufRead *
        \ let s:tempPath=escape(escape(expand("%:p:h"), ' '), '\ ') |
        \ exec "set path-=".s:tempPath |
        \ exec "set path-=".s:default_path |
        \ exec "set path^=".s:tempPath |
        \ exec "set path^=".s:default_path

  " Haskell Lint
  "nmap <silent> <leader>hl :Neomake hlint<CR>

  " Options for Haskell Syntax Check
  let g:neomake_haskell_ghc_mod_args = '-g-Wall'

  " Hoogle the word under the cursor
  nnoremap <silent> <leader>hh :Hoogle<CR>

  " Hoogle and prompt for input
  nnoremap <leader>hH :Hoogle

  " Hoogle for detailed documentation (e.g. "Functor")
  nnoremap <silent> <leader>hi :HoogleInfo<CR>

  " Hoogle for detailed documentation and prompt for input
  nnoremap <leader>hI :HoogleInfo

  " Hoogle, close the Hoogle window
  nnoremap <silent> <leader>hz :HoogleClose<CR>

  " }}}


