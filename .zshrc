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

zstyle ':omz:update' mode disabled
source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"

alias ls="ls -a --color=auto"
alias zb="zen-browser"
alias nvid="neovide"
alias ta="tmux a"
alias tn="tmux new"
alias n.="nvim ."
alias tk="wl-copy "$(cat ~/.token)""
alias kc="kiro-cli"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# --- zsh-autosuggestions (fish-like inline preview) ---
# Install with: sudo pacman -S zsh-autosuggestions
# Accept full suggestion with Right arrow / End; accept one word with Ctrl+Right or Alt+F.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
