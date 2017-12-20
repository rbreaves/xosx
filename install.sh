#!/bin/bash

spinner()
{
    local pid=$!
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

keyswap(){
	# Install Key swap
	echo "Adding Alt, Ctrl, Super key swap to match OSX layout..."
	if [ ! -f ~/.Xmodmap ]; then
	    echo "Xmodmap file does not exist, adding one now and will apply settings..."
	    cp -rf ./chassis_vendor/$1/.Xmodmap ~/.Xmodmap
	else
		read -r -p "Xmodmap file found, would you like to overwrite it? (Y/n)" response
		response=${response,,}
		if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
			cp -rf ~/.Xmodmap ~/.Xmodmap.bak.$(date '+%m.%d.%y_%H%M%S')
			yes | cp -rf ./chassis_vendor/$1/.Xmodmap ~/.Xmodmap
		fi
	fi

	# Install autostart key swap
	if [ ! -f ~/.xinitrc ]; then
	    echo "xinitrc file does not exist, adding one now to apply Xmodmap keymap settings on user login"
	    cp -rf ./chassis_vendor/$1/.xinitrc ~/.xinitrc
	else
		read -r -p "xinitrc file found, would you like to overwrite it? (Caution you could lose certain startup actions) (Y/n)" response
		response=${response,,}
		if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
			echo 'Backing up xinitrc if it exists, and copying new xinitrc into home directory...'
			cp -rf ~/.xinitrc ~/.xinitrc.bak.$(date '+%m.%d.%y_%H%M%S')
			yes | cp -rf./chassis_vendor/$1/.xinitrc ~/.xinitrc
		fi
	fi
}

brand=$(cat /sys/devices/virtual/dmi/id/chassis_vendor)

if [[ $brand = 'LENOVO' ]]; then
	read -r -p "Lenovo detected, would you like to install Xmodmap keyswap for IBM Thinkpad? (Y/n)" response
	response=${response,,}
	if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
		keyswap $brand
	fi
else
	echo 'Your chassis_vendor id is' $brand
	echo 'Your system is not compatible with the keyswap profile.'
	read -r -p "Would you like to apply the xmodmap keyswap anyways? (y/N)" response
	response=${response,,}
	if [[ $response =~ ^(yes|y) ]] || [[ -z $response ]]; then
		keyswap $brand
	else
		echo 'Did not apply keyswap.'
	fi
	echo 'If the keyswap does not work please contribute code or post your "xmodmap -pke" and chassis_vendor on github.'

fi

# Install Deja Vu Font
if ! fc-list | grep -i "DejaVu Sans Mono for Powerline" >/dev/null;
then
	echo "Installing DejaVu Powerline font..."
	wget -qP ~/.fonts/ https://github.com/powerline/fonts/raw/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf
	echo "Clearing font cache and reloading..."
	sudo fc-cache -f & spinner
else
	echo "DejaVu Powerline font is already installed"
fi

# Install Konsole and its config
if ! dpkg -s konsole >/dev/null; then
	echo "Installing Konsole and settings..."
	sudo apt install -y konsole
	yes | cp -rf ./userprofile/.local/share/konsole ~/.local/share/
	yes | cp -rf ./userprofile/.local/share/kxmlgui5 ~/.local/share/
	yes | cp -rf ./userprofile/.config/konsolerc ~/.config/
else
	echo "Konsole already installed."
	read -r -p "Would you like to overwrite Konsole's configuration (Y/n)" response
	response=${response,,}
	if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
		yes | cp -rf ./userprofile/.local/share/konsole ~/.local/share/
		yes | cp -rf ./userprofile/.local/share/kxmlgui5 ~/.local/share/
		yes | cp -rf ./userprofile/.config/konsolerc ~/.config/
	fi
fi

sudo apt install -y vim

# Install Zsh
if ! dpkg -s zsh >/dev/null; then
	echo "Installing zsh..."
	sudo apt install -y zsh
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
else
	echo "Zsh already installed."
fi

# Install Plank
if ! dpkg -s plank >/dev/null; then
	echo "Installing Plank..."
	sudo apt install -y plank
else
	echo "Plank already installed."
fi

# Install flat theme
echo 'Installing flat theme OSX-Arc-Collection...'
if ! dpkg -s jq >/dev/null; then
	sudo apt install -y jq
fi

installArc(){
	if [ $(uname -m) == 'x86_64' ]; then
		wget -qP ~/Downloads/ $arcx64URL
		sudo dpkg -i ~/Downloads/$arcx64File
	else
		wget -qP ~/Downloads/ $arcx32URL
		sudo dpkg -i ~/Downloads/$arcx32File
	fi

	xfconf-query -c xfwm4 -p /general/theme -s 'OSX-Arc-White'
	xfconf-query -c xfwm4 -p /general/button_layout -s "CHM"
}

arcElements=$(curl -s https://api.github.com/repos/LinxGem33/OSX-Arc-Darker/releases/latest | jq -r '.tag_name, .assets[0].name, .assets[0].browser_download_url,.assets[1].name, .assets[1].browser_download_url')
arcElements=(${arcElements[@]})

arcVersion=$(echo "${arcElements[0]}" | sed 's/^.//')
arcx64File=$(echo "${arcElements[1]}")
arcx64URL=$(echo "${arcElements[2]}")
arcx32File=$(echo "${arcElements[3]}")
arcx32URL=$(echo "${arcElements[4]}")

if ! dpkg -s osx-arc-collection > /dev/null; then
	installArc
else
	arcInstalled=$(dpkg -s osx-arc-collection | awk '$1 ~ /Version/ { print $2 }')
	if [[ $arcVersion != $arcInstalled ]]; then
		read -r -p "Your OSX-Arc-Collection package is out of date, would you like to upgrade? (Y/n)" response
		response=${response,,}
		if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
			installArc
		fi
	else
		echo 'Latest OSX-Arc-Colllection' $arcInstalled 'already installed'
	fi
fi

# Install Global Menu

# Install Whisker Menu

# Install Quick App Launcher