if [[ -n "$CURSOR_AGENT" ]]; then
	return
fi

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(autojump git python compleat ssh-agent history-substring-search)
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
	plugins+=(zsh-autosuggestions)
else
	echo "zsh-autosuggestions is not installed. Install it by running:"
	echo "git clone https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
alias gvim='gvim --remote-silent'
mvim() { /usr/local/bin/mvim --remote-silent "$*"; }

unsetopt correct_all
unsetopt cdable_vars

autoload -U compinit
compinit

autoload -U bashcompinit
bashcompinit

_nosetests()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=(`nosecomplete ${cur} 2>/dev/null`)
}
complete -o nospace -F _nosetests nosetests

aws_prompt_info() {
    if [[ -z "${AWS_PROFILE}" ]]; then
    else
	    echo "%{$fg[yellow]%}$AWS_PROFILE"
    fi
}
# Fix dynamic AWS profiles with CDK 
export AWS_SDK_LOAD_CONFIG=1
export AWS_DEFAULT_REGION="eu-west-1"
export AWS_STS_REGIONAL_ENDPOINTS=regional
# speed up not trying to connect to 169.254.169.254
export AWS_METADATA_SERVICE_NUM_ATTEMPTS=0

if [ -f ~/.dotfiles/scripts/awsrole.zsh ]; then
    source ~/.dotfiles/scripts/awsrole.zsh
fi

if [[ -n "$CURSOR_AGENT" ]]; then
  # Skip theme initialization for better compatibility
else
  PROMPT='%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} )%{$fg_bold[green]%}%p$(aws_prompt_info) %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

if [[ -e ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

if [[ -e ~/.zshrc.`hostname` ]]; then
    source ~/.zshrc.`hostname`
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -d $HOME/.nvm ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [ -d $HOME/.poetry/bin ]; then
    export PATH="$HOME/.poetry/bin:$PATH"
fi
export PATH="$HOME/.local/bin:$PATH"

export EDITOR=vim
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -d "$HOME/.poetry/bin" ] && export PATH="$HOME/.poetry/bin:$PATH"

[ -d "$HOME/.asdf" ] && . "$HOME/.asdf/asdf.sh"

alias 'export-aws-credentials=eval $(aws configure export-credentials --format env --profile $AWS_PROFILE)'

# Print Unix timestamp for current time minus N hours
unix_ts_since_hours() {
        HOURS="${1:=10}"
        python3 -c "from datetime import datetime, timedelta; print(int((datetime.utcnow() - timedelta(hours=$HOURS)).timestamp()))"
}

git_main_branch() {
    # Navigate to the root of the git repository
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
        echo "Not a git repository" >&2
        return 1
    }

    # Check for the main branch names in the root's .git/refs/heads
    for b in main master ci; do
        if [[ -f "$git_root/.git/refs/heads/$b" ]]; then
            echo "$b"
            return
	fi
    done

    # Check the packed-refs file if refs/heads is empty
    if [[ -f "$git_root/.git/packed-refs" ]]; then
        for b in main master ci; do
            if grep -qE "refs/heads/$b$" "$git_root/.git/packed-refs"; then
                echo "$b"
                return
            fi
        done
    fi

    # Fallback if no main branch name is found
    echo "Could not deduce the git main branch" >&2
    return 1
}

FORK_USER=$USER
BITBUCKET_HOST="FILLIN"
UPSTREAM_PROJECT="CAP"

clone_and_set_upstream() {
    if [ -z "$1" ]; then
        echo "Usage: clone_and_set_upstream repo_name"
        return 1
    fi

    repo_name=$1
    forked_repo_url="ssh://git@$BITBUCKET_HOST/~$FORK_USER/$repo_name.git"
    upstream_repo_url="ssh://git@$BITBUCKET_HOST/$UPSTREAM_PROJECT/$repo_name.git"

    git clone "$forked_repo_url" || { echo "Failed to clone $repo_name, create fork in https://$BITBUCKET_HOST/projects/$UPSTREAM_PROJECT/repos/$repo_name?fork"; return 1; }
    pushd "$repo_name" || exit
    git remote add upstream "$upstream_repo_url"
    echo "Upstream remote set to $upstream_repo_url"
        popd
}

git_clone() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: git_clone repo_name [repo_name2 ...]"
        return 1
    fi
    for repo in "$@"; do
        echo "Cloning $repo"
        clone_and_set_upstream "$repo"
    done
}

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

. "$HOME/.cargo/env"
