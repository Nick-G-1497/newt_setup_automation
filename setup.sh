!/bin/bash

RED="\033[0;31m";
BLUE="\033[34m"
NOCOLOR="\033[0m";
GREEN="\033[32m"

echo "======================================================================";
echo -e "${BLUE}Development Env Setup Script for Ubuntu 22.02   (ver 1.2) ";
echo -e "${BLUE}      - written by Nick Goralka (11/9/22)    ${NOCOLOR}";
echo "======================================================================";


echo -e "${RED}
     \\XXXXXX//
      XXXXXXXX
     //XXXXXX\\                      OOOOOOOOOOOOOOOOOOOO
    ////XXXX\\\\                     OOOOOOOOOOOOOOOOOOOO
   //////XX\\\\\\     |||||||||||||||OOOOOOOOOOOOOOOVVVVVVVVVVVVV
  ////////\\\\\\\\    |!!!|||||||||||OOOOOOOOOOOOOOOOVVVVVVVVVVV'
 ////////  \\\\\\\\ .d88888b|||||||||OOOOOOOOOOOOOOOOOVVVVVVVVV'
////////    \\\\\\\d888888888b||||||||||||            'VVVVVVV'
///////      \\\\\\88888888888||||||||||||             'VVVVV'
//////        \\\\\Y888888888Y||||||||||||              'VVV'
/////          \\\\\\Y88888Y|||||||||||||| .             'V'
////            \\\\\\|iii|||||||||||||||!:::.            '
///              \\\\\\||||||||||||||||!:::::::.
//                \\\\\\\\           .:::::::::::.
/                  \\\\\\\\        .:::::::::::::::.
                    \\\\\\\\     .:::::::::::::::::::.
                     \\\\\\\\
${NOCOLOR}
"

echo "Please press enter to continue"
read response;

if [ "$EUID" -ne 0 ]
	then echo -e "${RED}Error [-] Need to be root"
          echo -e "${GREEN}      - Drive your damm computer like you mean it and sudo"
	exit
fi

# Make sure packages and repos are up to date
apt-get update;
apt-get upgrade;
apt autoremove;

# Install apt dependancies
apt-get install git;
apt-get install doxygen;
apt-get install python3;
apt-get install python3-venv;
apt-get install graphviz;
apt-get install curl;
apt-get install sl; # steam locamotive command

# Install VSCode
apt-get install wget gpg;
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg;
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/;
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list';
rm -f packages.microsoft.gpg;

# Download Slack
snap install slack;

apt install apt-transport-https;
apt update;
apt install code; # or code-insiders

# Install drawio
wget https://github.com/jgraph/drawio-desktop/releases/download/v19.0.3/drawio-amd64-19.0.3.deb;
dpkg -i drawio-amd64-19.0.3.deb;
mv drawio-amd64-19.0.3.deb /tmp/;

# Install Segger SystemView
wget https://www.segger.com/downloads/systemview/SystemView_Linux_V332_x86_64.deb;
dpkg -i SystemView_Linux_V332_x86_64.deb;
mv SystemView_Linux_V332_x86_64.deb /tmp/;

# Abscure python dependancies needed for the debugger
apt-get install libpython2.7;
apt-get install libatlas3-base;

# Get rid of braile display driver b/c it messes up devices mounting to /dev
apt remove brltty;

# # Configure udev
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules;
service udev restart;

# Make user able to dialout on the USB port
usermod -a -G dialout $SUDO_USER;
usermod -a -G plugdev $SUDO_USER;

# Add the gpg key to package manager
wget -qO - https://raw.githubusercontent.com/JuulLabs-OSS/debian-mynewt/master/mynewt.gpg.key | sudo apt-key add -;

# Add to apt.list
echo "deb https://raw.githubusercontent.com/JuulLabs-OSS/debian-mynewt/master latest main" >> /etc/apt/sources.list.d/mynewt.list;
apt-get update;

# Install newt
apt-get install newt;

# Install nrf command line tools
wget https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/10-18-1/nrf-command-line-tools_10.18.1_amd64.deb;
dpkg -i nrf-command-line-tools_10.18.1_amd64.deb;
mv nrf-command-line-tools_10.18.1_amd64.deb /tmp/;

# # # Install J-Link Software
dpkg -i misc/JLink_Linux_V767d_x86_64.deb;


# Install the compiler
apt-get update;
apt-get install gcc-arm-none-eabi;
apt-get install gdb-arm-none-eabi;

# Set up ssh keys for you github
clear;
read -p "Enter the email for your github account : " email;
read -p "Enter the username for your github account : " username;
git config --global user.email $email;
git config --global user.name $username;
echo -e "${RED}Just hit enter to save it in the default location\n";
echo -e "${RED}Add a passphrase or don't. I'm not your mother.\n";
echo -e "${GREEN}Hit enter to continue\n";
read response;
ssh-keygen -t rsa -b 4096;
eval "$(ssh-agent -s)";
ssh-add ~/.ssh/id_rsa;

clear;
cat ~/.ssh/id_rsa.pub;
echo -e "${RED}\n \n Copy the content (starting from ssh-rsa). Now open your GitHub account and do the following steps\n";
echo -e "${NOCOLOR} Click on your profile in the top right corner and select Settings from the drop-down box\n";
echo -e "Now from the Account Settings section present on the left, select SSH and GPG keys\n";
echo -e "To add a new key, Click on New SSH key\n";
echo -e "    Under the title section, add a name to your key. Then in the key section, paste the key that we copied from our terminal. Finally, click on Add SSH key\n\n\n";

echo -e "${RED} \n\n\nDO NOT CONTINUE UNTIL YOU HAVE DONE THIS ${NOCOLOR}\n\n";

read response;

# Clone the Decawave Repository
cd /home/$SUDO_USER/Documents;
git clone git@github.com:Decawave/uwb-apps.git;
chown $SUDO_USER uwb-apps;
chmod -R 777 uwb-apps;
cd uwb-apps;
newt upgrade;
cd repos/apache-mynewt-core/;
git apply ../decawave-uwb-core/patches/apache-mynewt-core/mynewt_1_7_0_*;
cd -;

# Edit JLink Script
mv /home/$SUDO_USER/Documents/uwb-apps/repos/apache-mynewt-core/hw/scripts/jlink.sh /tmp;
cp misc/jlink.sh /home/$SUDO_USER/Documents/uwb-apps/repos/apache-mynewt-core/hw/scripts/jlink.sh;


# Exit message
clear;

echo -e "${GREEN}[-] All dependancies should be installed ${NOCOLOR}";
echo "Leave this window open and complete the following:";
echo "         - Open up Slack and sign in";
echo "         - Install Platformio IDE Extension for VSCode - (Can use the serial monitor for USB Console)";
echo "         - Set up your git credentials with vscode";
echo "         - Install Doxygen Documentation Generator Extension for VSCode";
echo "         - Install GitHub Pull Requests and Issues Extension for VSCode";
echo "         - Install C/C++ Extension Pack Extension for VSCode";
echo "         - Run 'sl' in a terminal (steam locamotive command)";
echo "         - Then you should be ready to go";

exit; 

