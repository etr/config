# .bashrc

# User specific aliases and functions

# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc

#######################################
# user specific environment
#######################################

set -o vi

have() 
{ 
    unset -v have 
    PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin type $1 >&/dev/null && have="yes" 
}

for f in `ls /etc/bash_completion.d`; do source /etc/bash_completion.d/$f; done

# for mc, cvs, svn, ...
export EDITOR=vim

# Use vim to browse man pages. One can use Ctrl-[ and Ctrl-t
# to browse and return from referenced man pages. ZZ or q to quit.
# Note initially within vim, one can goto the man page for the
# word under the cursor by using [section_number]K.
# Note we use bash explicitly here to support process substitution
# which in turn suppresses the "Vim: Reading from stdin..." warning.
export MANPAGER='bash -c "vim -MRn -c \"set ft=man nomod nolist nospell nonu\" \
-c \"nm q :qa!<CR>\" -c \"nm <end> G\" -c \"nm <home> gg\"</dev/tty <(col -b)"'
# GROFF_NO_SGR is required with man-db which uses grotty to
# output SGR codes by default when attached to a terminal.
# We want vim to highlight the raw text, so disable that feature.
# Also see MANPAGER in my .vimrc for extra handling to support
# ctrl-[ with man-db
export GROFF_NO_SGR=1
# Another option is to use $VIMRUNTIME/macros/less.sh
# though I find that less effective

# vim and gnome-terminal have support for 256 colours in fedora 8 at least
# Note debian/ubuntu users need to install the ncurses-term package for this
# Note this should be set in ~/.profile for Fedora startup scripts to
# setup LS_COLORS correctly.
export TERM=xterm-256color

# setup default search path for python modules.
# Note we add this to the 'path' in .vimrc so the gf
# command will open any .py or .h files etc. in this dir
export PYTHONPATH=~/pb.o/libs/

# for developing: http://udrepper.livejournal.com/11429.html
export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

#######################################
# change app defaults
# Note one can disable an alias for a
# command by running like \command
#######################################

# highlight $HOST:$PWD prompt
PS1='\[\e[1m\]\u@\h:\w\[\e[0m\]$(__git_ps1 "[%s]")$ '

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# Don't store duplicate adjacent items in the history
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'

# append to the history file, don't overwrite it
shopt -s histappend

#Bigger history file size
unset HISTFILESIZE
HISTSIZE=1000000

#history time format
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -a; history -n'

# adjust settings according to current terminal window width
# which may have changed while the last command was running
# (which is a common occurance for vim/less/etc.)
# Note this is already set in /etc/bashrc on Fedora 8 at least.
#shopt -s checkwinsize

# GREP_COLOR=bright yellow on black bg.
# use GREP_COLOR=7 to highlight whitespace on black terminals
# LANG=C for speed. See also: http://www.pixelbeat.org/scripts/findrepo
alias grep='GREP_COLOR="1;33;40" LANG=C grep --color=auto'

alias ls="BLOCK_SIZE=\'1 ls --color=auto" #enable thousands grouping and colour
alias minicom='minicom -c on' #enable colour
alias cal='cal -3' #show 3 months by default
alias units='units -t' #terse mode
alias diff='LC_ALL=C TZ=GMT0 diff -Naur' #normalise diffs for distribution
alias lynx='lynx -force_html -width=$COLUMNS' #best settings for viewing HTML
alias links='links -force-html' #need to enable colour in config menu manually
alias xterm='xterm -fb "" -bg black -fg gray -fa "Sans Mono" -fs 9 +sb -sl 3000 -g 80x50+1+1'
alias please='sudo env PATH=$PATH' 
alias sudo='sudo env PATH=$PATH' #work around sudo built --with-secure-path (ubuntu)
alias vim='export TERM=xterm; vim -p -X' #don't try to contact xserver (which can hang on network issues)
#alias gdb='gdb -tui -quiet' #enable the text window interface if possible
alias head='head -n $((${LINES:-12}-2))' #as many as possible without scrolling
alias tail='tail -n $((${LINES:-12}-2)) -s.1' #Likewise, also more responsive -f

alias amek='make'
alias amke='make'

# I hate noise
set bell-style visible

# Tell less not to beep and also display colours.
# Also don't wrap lines, as less supports horizontal scolling
export LESS="-QRS"
# Adjust the less highlight colors
#export LESS_TERMCAP_so="$(printf 'rev\nbold\nsetaf 3\n' | tput -S)"
#export LESS_TERMCAP_se="$(tput sgr0)"

# Let me have core dumps
ulimit -c unlimited

#######################################
# shortcut aliases and functions
#######################################

alias ..="cd .."        #go to parent dir
alias ...="cd ../.."    #go to grandparent dir
alias -- -="cd -"       #go to previous dir
alias l='ls'            #list files
alias l.='ls -d .*'     #list hidden files
alias ll='ls -lhrt'     #extra info compared to "l"
alias lld='ls -lUd */'  #list directories
alias la='ls -a'        #list hidden files

# what most people want from od (hexdump)
alias hd='od -Ax -tx1z -v'

# canonicalize path (including resolving symlinks)
alias realpath='readlink -f'

# make and change to a directory
md () { mkdir -p "$1" && cd "$1"; }

# print the corresponding error message
strerror() { python -c "\
import os,locale as l; l.setlocale(l.LC_ALL, ''); print os.strerror($1)"; }

# quick plot of numbers on stdin. Can also pass plot params.
# E.G: seq 1000 | sed 's/.*/s(&)/' | bc -l | plot linecolor 2
plot() { { echo 'plot "-"' "$@"; cat; } | gnuplot -persist; }

# highlight occurences of expression
hili() { e="$1"; shift; grep --col=always -Eih "$e|$" "$@"; }
# Ditto, but user pager ('n' to iterate)
scan() { e="$1"; shift; less -i -p "*$e" "$@"; }

# Make these functions, common to other languages, available in the shell
ord() { printf "0x%x\n" "'$1"; }
chr() { printf $(printf '\\%03o\\n' "$1"); }

export BROWSER=google-chrome
export P4CONFIG=~/.p4settings
