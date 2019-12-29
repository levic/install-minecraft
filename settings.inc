# can get the latest version number from https://minecraft.gamepedia.com/Bedrock_Dedicated_Server
version="1.14.1.4"
zipfile="bedrock-server-$version.zip"
download_url="https://minecraft.azureedge.net/bin-linux/$zipfile"

target_dir=~/minecraft
backup_dir=~/backup
script_dir="$( readlink -f "$( dirname "${BASH_SOURCE[0]}" )" )"

level_name=""
level_seed=""
operator_xuid=""

[[ $level_name != "" ]] || { echo "You need to set level_name in settings.inc" ; exit 1 ; }
[[ $level_seed != "" ]] || { echo "You need to set level_seed in settings.inc" ; exit 1 ; }
[[ $operator_xuid != "" ]] || { echo "You need to set operator_xuid in settings.inc" ; exit 1 ; }


which crudini >/dev/null || { echo "Cannot find crudini (do you need to install it?)" ; exit 1 ; }

