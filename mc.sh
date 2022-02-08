#!/bin/bash

# Minecraft version
VERSION=1.18

set -e
root=$PWD
mkdir -p mc
cd mc

#export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
#export PATH=$JAVA_HOME/bin:$PATH

download() {
    set -e
    echo By executing this script you agree to the JRE License, the PaperMC license,
    echo the Mojang Minecraft EULA,
    echo the NPM license, the MIT license,
    echo and the licenses of all packages used \in this project.
    echo Press Ctrl+C \if you \do not agree to any of these licenses.
    echo Press Enter to agree.
    read -s agree_text
    echo Thank you \for agreeing, the download will now begin.

    echo "eula=true" > eula.txt
    echo Agreed to Mojang EULA
    wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
    unzip -o ngrok.zip
    rm -rf ngrok.zip
    echo "Download complete" 
}

require() {
    if [ ! $1 $2 ]; then
        echo $3
        echo "Running download..."
        download
    fi
}
require_file() { require -f $1 "File $1 required but not found"; }
require_dir()  { require -d $1 "Directory $1 required but not found"; }
require_env() {
  if [[ -z "${!1}" ]]; then
    echo "Environment variable $1 not set. "
    echo "Make a new secret called $1 and set it to $2"
    exit
  fi
}
require_executable() {
    require_file "$1"
    chmod +x "$1"
}

# server files
require_file "eula.txt"

# ngrok binary
require_executable "ngrok"

# environment variables
require_env "ngrok_token" "your ngrok authtoken from https://dashboard.ngrok.com"
require_env "ngrok_region" "your region, one of:
us - United States (Ohio)
eu - Europe (Frankfurt)
ap - Asia/Pacific (Singapore)
au - Australia (Sydney)
sa - South America (Sao Paulo)
jp - Japan (Tokyo)
in - India (Mumbai)" 

# start web server
#echo "Starting web server..."
echo "Minecraft server starting, please wait" > $root/ip.txt

# start tunnel
mkdir -p ./logs
touch ./logs/temp # avoid "no such file or directory"
rm ./logs/*
echo "Starting ngrok tunnel in region $ngrok_region"
./ngrok authtoken $ngrok_token
touch logs/ngrok.log
./ngrok tcp -region $ngrok_region --log=stdout 1025 > ./logs/ngrok.log &
# wait for started tunnel message, and print each line of file as it is written
tail -f ./logs/ngrok.log | sed '/started tunnel/ q'
orig_server_ip=`curl --silent http://127.0.0.1:4040/api/tunnels | jq '.tunnels[0].public_url'`
trimmed_server_ip=`echo $orig_server_ip | grep -o '[a-zA-Z0-9.]*\.ngrok.io[0-9:]*'`
server_ip="${trimmed_server_ip:-$orig_server_ip}"
echo "Server IP is: $server_ip"
echo "$server_ip" > $root/ip.txt
echo "$VERSION" > $root/ver.txt
touch logs/latest.log
# Experiment: Run http server after all ports are opened
#( tail -f ./logs/latest.log | sed '/RCON running on/ q' && python3 -m http.server 8080 ) &

# Start minecraft
#PATH=$PWD/jre/bin:$PATH
echo "Running server..."
#java -version
#java -Xmx1G -Xms1G -jar server.jar nogui
node ./../index.js
echo "Exit code $?"
