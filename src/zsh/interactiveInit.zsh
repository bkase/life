export HISTFILE=~/.zshistory;
export HISTSIZE=100000;
export SAVEHIST=100000;

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

# Less Colors for Man Pages
# http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
export LESSOPEN='| /opt/local/bin/lesspipe.sh %s'

#functions
calc() { awk "BEGIN { print $* }"; }
record_pwd() { pwd > /tmp/.cwd }
git_squash_second_with_initial() {
   SECOND=$1
   INITIAL=$2
   git checkout $SECOND
   git reset --soft $INITIAL
   git commit --amend -m "Initial commit"
   git tag initial
   git checkout master
   git rebase --onto initial $SECOND
   git tag -d initial
}

#register hooks
autoload -U add-zsh-hook && add-zsh-hook chpwd record_pwd

export LS_COLORS=$(vivid generate gruvbox-light)

#cd to the most recent place
touch /tmp/.cwd
cd `cat /tmp/.cwd`


# TODO: Why do my aliases not work in environment.shellAliases anymore
alias vi="vim"
alias ls="exa --group-directories-first"
alias l="ls"
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"
alias c="clear && archey"
alias cls="clear && archey && ls"
alias gc="git commit"
alias wlog="git log --decorate --oneline"
alias gl="git log --decorate"
alias ggp="git grep"
alias gcob="git checkout -b"
alias gps="git push"
alias grb="git rebase"
alias gsh="git show"
alias gcp="git cherry-pick"
alias gd="git diff"
alias gf="git fetch"
alias gcl="git clone"
alias gb="git branch"

eval "$(scmpuff init -s)"

_gen_fzf_default_opts() {
  # Comment and uncomment below for the light theme.

  # Gruvbox Dark color scheme for fzf
  #export FZF_DEFAULT_OPTS="
    #--color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
    #--color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
  #"
  ## Gruvbox Light color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:#3c3836,bg:#fbf1c7,hl:#b57614,fg+:#3c3836,bg+:#ebdbb2,hl+:#b57614
    --color info:#076678,prompt:#665c54,spinner:#b57614,pointer:#076678,marker:#af3a03,header:#bdae93
  "

  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

}
_gen_fzf_default_opts

# Search google chrome history with fzf
ch() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  rm -rf /tmp/h
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

# fasd
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# (FASD + fzf || find . + fzf) do
# $1 = flag for files (-f) or directories (-d)
# $2 = format string for command to run
# $3 = any arguments to fasd directly
_fasd_do() {
  local res
  res=$(fasd -Rl -$1 "$3" | fzf -1 -0 --no-sort +m || find . -type $1 -print0 | grep -FzZ '*'"$3"'*' | fzf +m) && $(printf "$2" "$res") || return 1
}

j() {
  _fasd_do d "cd %s" "$*"
}

vf() {
  _fasd_do f "vim %s" "$*"
}

export NIX_PATH="darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:/nix/var/nix/profiles/per-user/root/channels:$HOME/.nix-defexpr/channels"
export NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

export WASMER_DIR="/Users/bkase/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

eval "$(direnv hook zsh)"

