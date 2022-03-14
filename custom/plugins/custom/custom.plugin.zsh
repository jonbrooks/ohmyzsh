## Aliases

# Recursively remove .DS_Store files
alias cleanupds="find . -type f -name '*.DS_Store' -ls -delete"

#Lists aliases and functions defined in the shell
alias listaliases="alias | sed 's/=.*//'"
alias listfunctions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'" # show non _prefixed functions

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

alias deleteMerged='git branch --merged $(git_main_branch) | grep -v "\* $($(git_main_branch)" | grep -v "$(git_main_branch)"  | xargs -n 1 git branch -d'

#removes jwt auth header from pasteboard contents
alias pbclean='pbpaste | sed "s/Bearer [^\"]*/\.\.\./" | pbcopy'

## Functions

# Create a new directory and enter it
function mk() {
  mkdir -p "$@" && cd "$@"
}
# Open man page as PDF
function manpdf() {
 man -t "${1}" | open -f -a /Applications/Preview.app/
}

# Extra many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.epub)     unzip "$1"                            ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file to extract"
  fi
}

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Take pasteboard contents assumed to be a jwt and output the payload
# relies on pbpaste and jq
function pbjwt() {
  local input=`pbpaste`
  local regex="^[^\.]+\.([^\.]+)\.*."

  [[ $input =~ $regex ]] && local payload=${BASH_REMATCH[1]}
  local json=`echo $payload | base64 -d`
  echo "$json}" | jq
}

## Path config

#Add npm to path
#export PATH="$HOME/.npm-packages/bin:$PATH"
#export PATH="/usr/local/opt/node@10/bin:~/.rbenv/shims:$PATH"
#export PATH="/usr/local/opt/node@12/bin:~/.rbenv/shims:$PATH"

#M1 only:
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

## Other config

#initialize rbenv, which sets ruby to be the one set by rbenv (currently 2.7.x)
eval "$(rbenv init -)"
