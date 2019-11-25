#!/bin/bash -e
set -o pipefail

# can get the latest version number from https://minecraft.gamepedia.com/Bedrock_Dedicated_Server
version="1.13.2.0"
zipfile="bedrock-server-$version.zip"
download_url="https://minecraft.azureedge.net/bin-linux/$zipfile"

target_dir=~/minecraft
backup_dir=~/backup

echo "This will install minecraft bedrock edition"
echo
echo "It will:"
echo "- Download from: $download_url"
echo "- Download to:   $target_dir/$zipfile"
echo "- Extract to:    $target_dir/bedrock_server"
echo "- Enable systemd user services for $USER"
echo "- Backup to:     $backup_dir"
echo
echo "Press Enter to continue or Ctrl-C to abort"
read

if [[ $1 == "--force" ]] ; then
	force=true
else
	force=false
fi

mkdir -p "$target_dir"
cd "$target_dir"

backed_up=false
function backup() {
	if ! $backed_up ; then
		backup_zip="$backup_dir/minecraft-$( date '+%Y%m%d-%H%M%S' ).zip"
		echo "Backing up to"
		mkdir -p "$backup_dir"
		zip -r "$backup_zip" "$target_dir/worlds" "$target_dir/bedrock_server/server.properties" "$target_dir/bedrock_server/permissions.json"
		backed_up=true
	fi
}

function restore_settings() {
	"$( dirname "${BASH_SOURCE[0]}" )"/restore-settings.sh "$target_dir"
}

if $force || ! [[ -e $zipfile ]] ; then
	echo "Downloading" 
	wget "$download_url"
else
	echo "Skipping download (already present)"
fi

# there's no --version option or similar for the server, and no version string easily readable
# in the executable so we look at the last log file to decide whether to extract data

# get the expected executable size
expected_exe_size=$( unzip -l $zipfile bedrock_server | awk '(NR==4) { print $1 } ' )
actual_exe_size=$( stat --printf="%s" bedrock_server/bedrock_server )
if $force || ! [[ $expected_exe_size -eq $actual_exe_size ]] ; then
	backup
	echo "Extracting"
	mkdir -p bedrock_server
	unzip -o -d bedrock_server "$zipfile"

	# config files will have been overwritten; restore settings
	restore_settings
else
	echo "Skipping extraction (executable is already the expected size)"
fi

# we want to store the worlds directory as a symlink to our actual data
if ! [[ -L bedrock_server/worlds ]] ; then
	backup
	echo "Moving worlds out of install dir"
	mv bedrock_server/worlds .
	( cd bedrock_server ; ln -s ../worlds )
fi

echo "Enabling systemd service"
mkdir -p ~/.config/systemd/user/
cd ~/.config/systemd/user/
if ! [[ -L minecraft@.service ]] ; then
	ln -s "$( dirname "${BASH_SOURCE[0]}" )"/minecraft@.service minecraft@.service
fi

mkdir -p ~/.config/systemd/user/default.target.wants
cd ~/.config/systemd/user/default.target.wants
if ! [[ -L minecraft@default.service ]] ; then
	ln -s ../minecraft@.service minecraft@default.service
fi


echo "Enabling user linger"
sudo loginctl enable-linger $USER

systemctl --user daemon-reload
systemctl --user status
systemctl --user stop minecraft@default.service
systemctl --user start minecraft@default.service
systemctl --user status minecraft@default.service

#export XDG_RUNTIME_DIR=/run/user/$( id -u )
#export DBUS_SESSION_BUS_ADDRESS=/run/usr/$( id -u )/bus
#sudo --preserve-env=XDG_RUNTIME_DIR systemctl --user status
# systemctl --user enable $USER
# systemctl --user daemon-reload
# loginctl enable-linger $USER
