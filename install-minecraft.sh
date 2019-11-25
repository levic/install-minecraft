#!/bin/bash -e
set -o pipefail

version="1.12.0.28"
zipfile="bedrock-server-$version.zip"
download_url="https://minecraft.azureedge.net/bin-linux/$zipfile"

echo "This will install minecraft bedrock edition"
echo
echo "It will:"
echo "- Download from: $download_url"
echo "- Download to:   minecraft/$zipfile"
echo "- Extract to:    $PWD/minecraft/bedrock_server"
echo "- Enable systemd user services for $USER"
echo
echo "Press Enter to continue or Ctrl-C to abort"
read

if [[ $1 == "--force" ]] ; then
	force=true
else
	force=false
fi

mkdir -p minecraft
cd minecraft

if $force || ! [[ -e $zipfile ]] ; then
	echo "Downloading" 
	wget "$download_url"
else
	echo "Skipping download (already present)"
fi

if $force || ! [[ -e bedrock_server/bedrock_server ]] ; then
	echo "Extracting"
	mkdir -p bedrock_server
	unzip "../$zipfile"
else
	echo "Skipping extraction (already extracted)"
fi

if ! [[ -L bedrock_server/worlds ]] ; then
	echo "Moving worlds out of install dir"
	mv bedrock_server/worlds .
	( cd bedrock_server ; ln -s ../worlds )
fi

echo "Enabling systemd user "
mkdir -p ~/.config/systemd/user/

#export XDG_RUNTIME_DIR=/run/user/$( id -u )
#export DBUS_SESSION_BUS_ADDRESS=/run/usr/$( id -u )/bus
#sudo --preserve-env=XDG_RUNTIME_DIR systemctl --user status
# systemctl --user enable $USER
# systemctl --user daemon-reload
# loginctl enable-linger $USER
