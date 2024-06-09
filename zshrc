# Load shared shell configuration
source ~/.shrc

# Enable completions
autoload -U compinit && compinit

# Enable regex moving
autoload -U zmv

# Style ZSH output
zstyle ':completion:*:descriptions' format '%U%B%F{red}%d%f%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Case insensitive globbing
setopt no_case_glob

# Expand parameters, commands and arithmetic in prompts
setopt prompt_subst

# Colorful prompt with Git branch
autoload -U colors && colors

# History file
export HISTFILE=~/.zsh_history
export HISTSIZE=500000
export SAVEHIST=100000

# Expire duplicates first
setopt hist_expire_dups_first

# Don't store duplicates
setopt hist_ignore_dups

# Don't show duplicate history entries
setopt hist_find_no_dups

# Remove unnecessary blanks from history
setopt hist_reduce_blanks

# Save time info
setopt extended_history

# Share history between instances
setopt share_history

# Append to history
setopt append_history

# Don't hang up background jobs
setopt no_hup

# Use emacs bindings even with vim as EDITOR
bindkey -e

# Enable hooks for precmd
autoload -U add-zsh-hook

# From https://nuclearsquid.com/writings/edit-long-commands/
# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style:
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

gitbr() {
  psvar[1]=$(git_branch)
}

gitst() {
  psvar[2]=$(git_status)
}

add-zsh-hook precmd gitbr
add-zsh-hook precmd gitst

PROMPT='%F{cyan}%* %B%F{green}%n@%m%b %F{cyan}%60<...<%~ \
%F{240}(%F{yellow}%v%F{240}%(V.|.)%F{red}%2v%F{240}%(2V.|.)%F{yellow}%%%j%F{240}|%(?.%F{yellow}%?.%F{red}%?)%F{240})\
%B%F{green}%b%% %f'
