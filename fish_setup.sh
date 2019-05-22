#!/data/data/com.termux/files/usr/bin/bash
apt update && apt upgrade -y
apt install fish -y
cp fish_ts.sh /$HOME
chmod 777 /$HOME/fish_ts.sh
cd ..
rm -rf tstyling
bash /$HOME/fish_ts.sh
