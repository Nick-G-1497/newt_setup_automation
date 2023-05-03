# newt_setup_automation

## What is this script?

This script is meant to automate the time consuming and tedious task of downloading dependancies and setting up all the neccisary tools for a proper development environment on a Linux machine. 

### Issues

 - The script includes all the required steps in order to install all the dependancies, however, it may be that they are not installed in the correct order in the script or the scipt may install some things under root instead of the user who runs the script. This was something that was not fully resolved as the only way to test the script was completely wipe the partition/disk and install a fresh version of the OS and this is extremely time consuming. We needed to prioritize other aspects of the project.

## How to run the script?

All that is needed to run this script is a fresh Ubuntu 22.04 Linux install (https://ubuntu.com/#download). If you have never done this before please refer to this tutorial or the numberous other sources on the internet (https://www.freecodecamp.org/news/how-to-dual-boot-any-linux-distribution-with-windows/).

Simple download the zip folder of the entire repo. Unzip the files into your Documents folder. Open up a terminal and navigate to where you downloaded the project. Run `sudo bash setup.sh`. 

Please note that the script will ask for user input periodically to set up things like your git credentials and what not. If you mess up it will not hurt anything to run it multiple times, however you will save time if you read the prompts carefully as the messages are extremely delibrate.

## CAN YOU ADD A VERIFICATION STEP, HOW DO I KNOW IT WORKED?
