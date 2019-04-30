#!/data/data/com.termux/files/usr/bin/bash
clear
# Vars
root_path=~/.config/fish
#get current dir
pdir=$(pwd)
#installing necessary packages
echo Installing Necessary Packages...
apt install figlet toilet -y > /dev/null 2>&1
pkg install ncurses-utils -y > /dev/null 2>&1
# Setting up commands
getCPos() (
	local opt=$*
	exec < /dev/tty
	oldstty=$(stty -g)
	stty raw -echo min 0
	# on my system, the following line can be replaced by the line below it
	echo -en "\033[6n" > /dev/tty
	# tput u7 > /dev/tty    # when TERM=xterm (and relatives)
	IFS=';' read -r -d R -a pos
	stty $oldstty
	# change from one-based to zero based so they work with: tput cup $row $col
	row=$((${pos[0]:2} - 1))    # strip off the esc-[
	col=$((${pos[1]} - 1))
	if [[ $opt =~ .*-row.* ]]
	then
		printf $row
	else
		printf $col
	fi
)
spinner() (
	PID=$!
	stty -echo
	local opt=$*
	tput civis
	cstat(){
		local optstat="$(if [[ ! $opt =~ .*$1.* ]]
						 then
							 echo 0
						 else
							 echo 1
						 fi)"
		#echo $opt
		echo $optstat
	}
	#echo $(cstat -s)
	if [ "$(cstat -s)" -eq 1 ]
	then
		printf '\n'
		# While process is running...
		while kill -0 $PID 2> /dev/null;
		do  
			printf '\u2588\e[1B\e[1D\u2588\e[1A'
    		sleep 0.3
		done
	elif [ "$(cstat -p)" -eq 1 ]
	then
		while kill -0 $PID 2> /dev/null;
		do  
			printf '\u2588\e[1B\e[1D\u2588\e[1A'
    		sleep 0.3
		done
	elif [ "$(cstat -t)" -eq 1 ]
	then
		until [ $(getCPos) -eq $(($(tput cols))) ]
		do
			#echo $(getCPos) >> log.txt
			#getCPos
			#tput cols
			if [ ! $(getCPos) -eq $(($(tput cols)-1)) ]
			then
				printf '\u2588\e[1B\e[1D\u2588\e[1A'
				printf '\u2588\e[1B\e[1D\u2588\e[1A'
			else
				#echo 1
				#echo hi
				local row=$(($(getCPos -row)+1))
				local plen=$(tput cols)
				printf '\u2588'
				tput cup "$row" "$plen"
				printf '\u2588'
				break
			fi
		done
		printf "\n\n\nDone!\n"
	fi
	#echo hh
	tput cnorm
	stty echo
)
#Updating secondary packages
echo Updating Packages....	
pip install mdv > /dev/null 2>&1 & spinner -s
apt-get autoremove > /dev/null 2>&1 & spinner -p
apt-get autoclean > /dev/null 2>&1 & spinner -p
apt-get install git -y > /dev/null 2>&1 & spinner -p && spinner -t
clear
#Script starts
#cd $HOME
#cd termuxstyling
echo Script made by:- Dark Warrior
#Uninstall
if [ -e ".user.cfg" ]
then
	uname=$(sed '1q;d' .user.cfg)
	istate=$(sed '2q;d' .user.cfg)
	if [ "$istate" -eq "1" ]
	then
		printf "Uninstall? [Y/N]: "
		read ink1
		case $ink1 in
			[yY][eE][sS]|[yY])
		rm .user.cfg;
		echo $uname > .user.cfg
		echo 0 >> .user.cfg
		cd
        rm -rf ~/.config/fish
        echo Uninstalled Successfully
		exit 0
		;;
			*)
		;;
		esac
	fi
fi
#Assigns Username
if [ ! -e ".user.cfg" ] 
then
	printf "Type your username: "
	read uname
	echo "This is your username: $uname"
	echo "$uname" > .user.cfg
	echo "1" >> .user.cfg
	clear
#Rename Username
else
	printf "Would You Like to Change Your Username[Y/N]: "
	read ink
	case "$ink" in
		[yY][eE][sS]|[yY])
	rm .user.cfg;
	clear
	bash setup.sh;
	;;
	*)
	clear
	echo "Welcome back $uname"
	;;
	esac
fi
#installing script
echo "Installing..."
mkdir -p $PREFIX/var/lib/postgresql > /dev/null 2>&1 & spinner -s
if [ -e "/data/data/com.termux/files/usr/etc/motd" ];then rm ~/../usr/etc/motd;fi & spinner -p
sleep 0.1 & spinner -p && spinner -t
#Set default username if found null
if [ -z "$uname" ]
then
	uname="FemurTech"
fi
#Sets fish_startup
if [ ! -d ~/.config/fish ];then mkdir -p ~/.config/fish;fi
cd $root_path
if [ ! -d functions ];then mkdir functions;fi
echo "
figlet -t $uname
set fish_greeting
">config.fish
echo '
function fish_prompt
set -l textcol  green
set -l bgcol    default
set -l arrowcol green
set_color --bold red
echo -n "root@termux["
set_color --bold $textcol #-b #$bgcol
echo -n ""(basename $PWD)""
set_color --bold red
echo -n "]:
"
set_color --bold $arrowcol -b normal
echo -n "# "
end
'>functions/fish_prompt.fish
cd $HOME
cd termuxstyling
echo Script made by
toilet Dark
toilet Warrior
sleep 2
mdv README.md
echo Subscribe to our YT channel FemurTech
echo tinyurl.com/femurtech
clear
cd $pdir
chsh -s fish
fish
