#!/usr/bin/bash

mkdir automation

pwd

cd automation

# sudo wget https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/42.0/linux-x86_64/en-US/firefox-42.0.tar.bz2

# sudo tar -xjvf firefox-42.0.tar.bz2

# sudo rm -rf /opt/firefox*

# sudo mv firefox /opt/firefox
# sudo ln -sf /opt/firefox/firefox /usr/bin/firefox

# echo "Firefox version 42 is installed"

echo "Now installing xvfb:"
sudo apt-get install xvfb

echo "Now installing SlimerJS:"

sudo wget http://download.slimerjs.org/releases/0.9.6/slimerjs-0.9.6-linux-x86_64.tar.bz2
sudo tar -xvjf slimerjs-0.9.6-linux-x86_64.tar.bz2
sudo ln -s `pwd`/slimerjs-0.9.6 /usr/local/share/slimerjs
sudo ln -s /usr/local/share/slimerjs/slimerjs /usr/local/bin/slimerjs
slimerjs --version 

echo 'Installing Casper:'
git clone https://github.com/n1k0/casperjs.git
cd casperjs
sudo ln -sf `pwd`/bin/casperjs /usr/local/bin/casperjs
casperjs --version

echo 'Phantom JS installation: '
sudo wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2
sudo tar xjf phantomjs-1.9.7-linux-x86_64.tar.bz2
sudo ln -s `pwd`/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/share/phantomjs
sudo ln -s /usr/local/share/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
phantomjs --version