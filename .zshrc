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

alias ls="ls -a --color=auto"
alias zb="zen-browser"
alias nvid="neovide"
alias ta="tmux a"
alias tn="tmux new"
alias n.="nvim ."
alias tk="cat ~/.token"
alias kc="kiro-cli"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- fuzzy directory finder (fd + fzf) ---
# The directory list lives in a shared config file (single source of truth),
# also used by the Ctrl+F kitty hotkey. Edit that file to change the list.
: ${FCD_CONF:=$HOME/.config/fcd/dirs.conf}

# Fuzzy-pick a directory from the configured roots and cd into it.
fzf-cd() {
  local dir roots=() line
  # read config: skip blank/comment lines, expand ~, keep existing dirs
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    line=${~line}
    [[ -d "$line" ]] && roots+=("$line")
  done < "$FCD_CONF"
  (( ${#roots} )) || { echo "fzf-cd: no valid dirs in $FCD_CONF" >&2; return 1; }

  # include the roots themselves plus their immediate subdirectories
  dir=$( { printf '%s\n' $roots; \
           fd --type d --hidden --follow --no-ignore --max-depth 1 \
              --exclude .git --exclude node_modules --exclude .cache \
              . $roots 2>/dev/null; } \
         | sed "s|^$HOME|~|" | fzf --prompt="cd > " --reverse --no-mouse )
  [[ -n "$dir" ]] && { dir=${~dir}; cd "$dir"; }
}

# NOTE: Ctrl+F is handled natively by kitty (see kitty.conf) which runs the
# picker in a clean overlay window to avoid dropped keypresses. Both Ctrl+F
# and the `fcd` command read the same list from $FCD_CONF.
alias fcd="fzf-cd"


# --- zsh-autosuggestions (fish-like inline preview) ---
# Install with: sudo pacman -S zsh-autosuggestions
# Accept full suggestion with Right arrow / End; accept one word with Ctrl+Right or Alt+F.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
