# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

# End of lines added by compinstall

# Lambda prompt
#PROMPT=$'\U250c\U2500\U2500(%n@%M)-[%~] %t\n\U2514\U2500%{\e[0;31m%}\U03bb%{\e[0m%} '
# Arrow prompt
PROMPT=$'\U250c\U2500\U2500(%n@%M)-[%~] %t\n\U2514\U2500%{\e[0;31m%}\U3009%{\e[0m%}'
# RPROMPT='%~ %t'

# fzf autocomplete settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# use ripgrep by default for faster searching
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--reverse --height 40% --border --preview "bat --color=always --style=numbers {}"' 
source <(fzf --zsh)

if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    # linux
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Golang
export PATH="$HOME/go/bin:$PATH"

# elixir
export PATH="/usr/bin:$PATH"

# Laravel
if [[ "$(uname)" == "Darwin" ]]; then
    # MacOS
    export PATH="$HOME/.composer/vendor/bin:$PATH"
else
    # Linux
    export PATH="$HOME/.config/composer/vendor/bin:$PATH"
fi

# bun completions
[ -s "/home/mike/.bun/_bun" ] && source "/home/mike/.bun/_bun"

# Dotfiles config git alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# Aliases
alias ls='ls --color'

[ -f "/home/mike/.ghcup/env" ] && . "/home/mike/.ghcup/env" # ghcup-env
