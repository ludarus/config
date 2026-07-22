#open sway after autologin
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
	exec sway
fi

#prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/scripts:$HOME/.cargo/bin:$HOME/.local/share/bob/nightly/bin:$PATH"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias ls="ls -a --color=auto"
alias zb="zen-browser"
alias nvid="neovide"
alias ta="tmux a"
alias tn="tmux new"
alias n.="neovide ."

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

