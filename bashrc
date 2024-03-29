# Aliases
alias ll='ls -la'

# alaska aliases
alias alaska='cs ~/developer/alaska-air/'
alias flightinfo='cs ~/developer/alaska-air/Apps/CSA.Mobile.FlightInfo/'
alias boardingagent='cs ~/developer/alaska-air/BoardingAgent'

# git aliases
alias ga='git add -A'
alias gpull='git pull'
alias gpush='git push'

function gc(){
	git commit -m "AW :$1"
}

function cs(){
    cd $1
    ll
}

function gs(){

	if [ $# -eq 0 ]
  then
    echo "You can also pass a path to \`gs\` as an argument: EX: gs ~/developer/alaska-air/CSA.Mobile.FlightInfo/"
		git status
	else
		prev=`pwd`
		cd $1 && git status && cd "${prev}"
	fi

}

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\[\e[36m\]<\u>\[\e[m\]\[\e[32m\]\W\[\e[m\]:\[\e[33;40m\]\`parse_git_branch\`\[\e[m\]\\$ "
