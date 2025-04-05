#!/bin/bash

GIT_TOKEN=""

# 
# Run or Crash
# Runs a command or crashes with exit message on failure.
# Forces a script to stop at this point and not to continue.
roc() {
	"$@"
	local result=$?
	if [ "$result" -ne 0 ]; then
		echo "Command exited with error: [$result]"
		exit "$result"
	fi
}

# Get and return the CPU architecture
getarch() {
	local arch
	arch=$(uname -i)
	if [[ $arch == x86_64* ]]; then
		echo "amd64"
	elif [[ $arch == i*86 ]]; then
		echo "X32"
	elif  [[ $arch == arm* ]]; then
		echo "arm64"
	elif [[ $arch == aarch64* ]]; then
		echo "arm64"
	fi
}


whiptail_inputbox_no_null() {
	local prompt="$1"
	local default="$2"
	# The weird "3>&1 1>&2 2>&3" redirects the output and display, otherwise you 
	# wouldn't see this command at all.
	input=""
	while : 
	do
		if [ -n "$default" ]; then
			input=$(whiptail --inputbox "$prompt" 0 0 "$default" 3>&1 1>&2 2>&3)
		else
			input=$(whiptail --inputbox "$prompt" 0 0 3>&1 1>&2 2>&3)
		fi
		input=$(echo "$input" | xargs)
		if [ -n "$input" ]; then
			break; 
		fi
	done
	echo "$input"
}

# Setup our directory structure
setup_directories() {
	# Create a couple directories for our setup
	roc mkdir -p /tmp
	roc mkdir -p "$HOME"/scripts
	roc mkdir -p "$HOME"/Programming/rust
	roc mkdir -p "$HOME"/Programming/bash
	roc mkdir -p "$HOME"/Programming/c
	roc mkdir -p "$HOME"/Programming/cpp
	roc mkdir -p "$HOME"/Programming/go
	roc mkdir -p "$HOME"/Programming/python
}

# Update the system using apt
system_update() {
	roc sudo apt update && sudo apt upgrade -y
}

# Install basic setup tools
install_tools() {
	roc sudo apt install vim mc jq yq shellcheck whiptail curl build-essential
}

# Git clone my Scripts Github repo to $HOME/Programming/Scripts
install_scripts() {
	# Download Scripts repo from Github and cp .vimrc to home dir
	roc cd "$HOME"/Programming && git clone https://github.com/HappyAmos/Scripts.git
	roc cp "$HOME"/Programming/Scripts/vim/.vimrc "$HOME"
}

# Install Cheat and Glow
install_cheat_glow() {
	printf "Installing Cheat and Glow\n"
	arch=$(getarch)
	# Download the appropriate version of cheat from its repo
	cd /tmp \
	  && wget https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-"$arch".gz \
	  && gunzip cheat-linux-"$arch".gz \
	  && chmod +x cheat-linux-"$arch" \
	  && sudo mv cheat-linux-"$arch" /usr/local/bin/cheat

	cd || exit

	# Modify cheat  ~/.config/cheat/conf.yml to set preferences
	echo "Setting 'cheat' preferences..."
	sed -i 's/editor: EDITOR_PATH/editor: vim/g' ~/.config/cheat/conf.yml
	sed -i 's/colorize: false/colorize: false/g' ~/.config/cheat/conf.yml
	sed -i 's/pager: PAGER_PATH/pager: glow/g' ~/.config/cheat/conf.yml

	# Symlink to cheat directory
	cd || exit
	echo "Create a symlink to personal cheatsheets folder in home directory."
	ln -s "$HOME"/.config/cheat/cheatsheets/personal/ "$HOME"/cheat

	cd "$HOME"/.config/cheat/cheatsheets/personal || exit
	git clone https://HappyAmos:"$GIT_TOKEN"@github.com/HappyAmos/cheat

	# There is a cheatsheet called cheat we need to temporarily rename as it is the
	# same name as the cloned directory "cheat"
	mv "$HOME"/.config/cheat/cheatsheets/personal/cheat/cheat "$HOME"/.config/cheat/cheatsheets/personal/cheat.bak
	mv "$HOME"/.config/cheat/cheatsheets/personal/cheat/* "$HOME"/.config/cheat/cheatsheets/personal/
	mv "$HOME"/.config/cheat/cheatsheets/personal/cheat/.* "$HOME"/.config/cheat/cheatsheets/personal/
	rm -rf "$HOME"/.config/cheat/cheatsheets/personal/cheat
	mv "$HOME"/.config/cheat/cheatsheets/personal/cheat.bak "$HOME"/.config/cheat/cheatsheets/personal/cheat

	# Install glow
	printf "Install 'glow'\n"
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
	echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
	sudo apt install glow

}

install_rust() {
	# Run the Rust install script
	curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
}

install_autoexec() {
	autotag="# tag:autoexec.sh"

	# Looks for a tag in .bashrc. if it doesn't exist, then 
	# our script hasn't been modified yet. obviously, this
	# isn't foolproof, but works for now.
	if grep -q "$autotag" "$HOME/.bashrc" ; then
		echo "tag already exists."
	else
		# Modify .bashrc to look for and run autoexec.sh
		(
			printf "\n\n";
			echo '# Custom command area:';
			printf "\n";
			echo "$autotag";
			echo 'if [ -f "autoexec.sh" ]; then';
			echo '  # commands to execute if the file exists';
			echo '  . ~/autoexec.sh';
			echo '#else';
			echo '  # commands to execute if the file does not exist (optional)';
			echo 'fi';
		) >> "$HOME/.bashrc"
	fi

	# Add some lines to our new autoexec.sh
	fn="$HOME/autoexec.sh"
	if [ ! -e "$fn" ]; then
		touch "$fn"
		(
			echo "#!/bin/bash";
			echo "bash --version";
			echo "echo";
			echo 'echo "Type cheat -t personal to list personal tagged cheatsheets."';
			echo 'echo "Type glow <somefile.md> to view markup"';
			echo "echo";
			echo "export PATH=\$PATH:~/scripts";
		) >> "$fn"
		chmod 777 "$fn"
	fi
}



main_menu() {
	while [ 1 ]
	do
	CHOICE=$(
		whiptail \
			--title "HappyAmos Setup" \
			--backtitle "User [$(whoami)]  Architecture [$(getarch)]" \
			--menu "Make your choice" 16 100 10 \
			--nocancel \
			"1)" "Refresh & update system"   \
			"2)" "Install tools" \
			"3)" "Setup and install Scripts from Github repository" \
			"4)" "Setup and install Cheat and Glow" \
			"5)" "Install Rust" \
			"6)" "Setup autoexec.sh" \
			"q)" "End script"  3>&2 2>&1 1>&3	
		)

	result=$(whoami)
	case $CHOICE in
		"1)")
		 	system_update	
			result="System updated."
			;;
		"2)")   
			install_tools
			result="Installed vim mc jq yq shellcheck whiptail curl build-essential"
			;;
		"3)")
			install_scripts
			result="Installed $HOME\\Programming\\Scripts directory from Github, \nCopied .vimrc from Scripts to $HOME\\.vimrc"
			;;
		"4)")
			install_cheat_glow
			result="Installed and setup Cheat and Glow"
			;;
		"5)")
			install_rust
			result="Installed Rust"
			;;
		"6)")
			install_autoexec
			result="Setup autoexec.sh in $HOME"
			;;
		"q)")
			exit
			;;
	esac

	whiptail --msgbox "$result" 20 78
	done

}

# Main loop
main() {
	# TODO: Install whiptail if not installed
	setup_directories
	main_menu

}

main
