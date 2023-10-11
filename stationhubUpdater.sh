#!/bin/sh

echo "░█▀▀░▀█▀░█▀█░▀█▀░▀█▀░█▀█░█▀█░█░█░█░█░█▀▄
░▀▀█░░█░░█▀█░░█░░░█░░█░█░█░█░█▀█░█░█░█▀▄
░▀▀▀░░▀░░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀░"

OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    alias ls='ls --color=auto'
    ;;
  'WindowsNT')
    OS='Windows'
    ;;
  'Darwin') 
    OS='Mac'
    ;;
  'AIX') 
  ;;
  *) 
    OS='Windows'
  ;;
esac

echo Detected OS: $OS

dir=`dirname "$0"`

echo "Installing jq.."

case $OS in
  'Linux')
    curl -sS https://webi.sh/jq | sh
    ;;
  'Windows')
    curl -L -o /usr/bin/jq.exe https://github.com/stedolan/jq/releases/latest/download/jq-win64.exe
    setx path "%path%;C:\Program Files\7-Zip"
    ;;
  'Mac') 
    curl -sS https://webi.sh/jq | sh
    ;;
  'AIX') 
  ;;
  *) 
    curl.exe -sS https://webi.ms/jq | powershell
    setx path "%path%;C:\Program Files\7-Zip"
  ;;
esac

echo "Grabbing latest release.."
DATA=$(curl -sS https://api.github.com/repos/unitystation/stationhub/releases/latest | jq '.assets' > releases.json)

DOWNLOADLINK=sss
FILENAME=aaa

#TODO: Use labels instead of the index of releases. Talk to GIllies and Bod about this.
case $OS in
  'Linux')
    DOWNLOADLINK=$(jq -r .[0].browser_download_url releases.json)
    FILENAME=$(jq -r .[0].name releases.json)
    ;;
  'Windows')
    DOWNLOADLINK=$(jq -r .[2].browser_download_url releases.json)
    FILENAME=$(jq -r .[2].name releases.json)
    ;;
  'Mac') 
    DOWNLOADLINK=$(jq -r .[1].browser_download_url releases.json)
    FILENAME=$(jq -r .[1].name releases.json)
    ;;
  'AIX') ;;
  *) ;;
esac

echo "Release found: $FILENAME"
echo "Downlading from: $DOWNLOADLINK"
curl -L $DOWNLOADLINK > $FILENAME

echo "Looking for 7zip.."
if ! command -v 7z &> /dev/null
then
    echo "7zip could not be found. Extract files manually."
    case $OS in
    'Linux')
        xdg-open https://7-zip.org/
        ;;
    'Windows')
        msg "%username%" 7zip could not be found. Extract files manually.
        start https://7-zip.org/
        ;;
    'Mac') 
        open https://7-zip.org/
        ;;
    'AIX') ;;
    *) ;;
    esac
    exit 1
fi


echo "Extracting.."
case $OS in
  'Linux')
    7z x $FILENAME -o*
    ;;
  'Windows')
    echo "Extracting in $dir"
    7z x $FILENAME -o"$dir\stationhub"
    ;;
  'Mac') 
    7z x $FILENAME 
    ;;
  'AIX') 
  ;;
  *) 
    7z x $FILENAME 
  ;;
esac

echo " █████   █████                                      ██████                        ███
░░███   ░░███                                      ███░░███                      ░███
 ░███    ░███   ██████   █████ █████  ██████      ░███ ░░░  █████ ████ ████████  ░███
 ░███████████  ░░░░░███ ░░███ ░░███  ███░░███    ███████   ░░███ ░███ ░░███░░███ ░███
 ░███░░░░░███   ███████  ░███  ░███ ░███████    ░░░███░     ░███ ░███  ░███ ░███ ░███
 ░███    ░███  ███░░███  ░░███ ███  ░███░░░       ░███      ░███ ░███  ░███ ░███ ░░░ 
 █████   █████░░████████  ░░█████   ░░██████      █████     ░░████████ ████ █████ ███
░░░░░   ░░░░░  ░░░░░░░░    ░░░░░     ░░░░░░      ░░░░░       ░░░░░░░░ ░░░░ ░░░░░ ░░░ "


read -rn1