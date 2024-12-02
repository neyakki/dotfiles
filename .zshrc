# Env
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
export PATH="~/.local/bin"

# System
plugins=(poetry docker docker-compose golang git-flow git git-commit zsh-autosuggestions zsh-syntax-highlighting you-should-use)
source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

# Alias
alias cat="bat"
alias ls="eza --color=always --icons"
alias la="eza --color=always --icons --total-size -l --group-directories-first"
alias ll="eza --color=always --icons --total-size -la --group-directories-first"
alias lf="eza --color=always --icons -f"
alias ld="eza --color=always --icons -d"
alias tree="eza --color=always --icons -T"
