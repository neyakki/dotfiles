export PATH=$HOME/.local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

plugins=(git git-commit zsh-autosuggestions zsh-syntax-highlighting you-should-use)

eval "$(starship init zsh)"
source $ZSH/oh-my-zsh.sh

# Alias
alias ll="ls -al"
alias ezas="eza --color=always --icons=auto"
alias ezaa="eza --color=always --icons=auto --total-size -l --group-directories-first"
alias ezal="eza --color=always --icons=auto --total-size -la --group-directories-first"
alias ezaf="eza --color=always --icons=auto -f"
alias ezad="eza --color=always --icons=auto -d"
alias tree="eza --color=always --icons=auto -T"
alias conf="NVIM_ROOT=~/.config nvim"

# Custom Git Alias
alias gh="git hist"
alias ghnp="git --no-pager hist"
