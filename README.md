# KlipperFirmwareUpdater
Script to automate Firmware Update for your Klipper Devices

## Setup
1. Download the repository and put it on your Pi (or whatever you use for klipper) - Location shouldn't matter, I have mine in /home/pi/
2. Go to your klipper install folder (eg. /home/pi/klipper/) -> cd /home/pi/klipper
3. Create a config for the board you want to have updated -> make menuconfig
4. Exit and save the config
5. Copy or Move the config file for your board to the "configs" folder within the KlipperFirmwareUpdater folder -> mv /home/pi/klipper/.config /home/pi/KlipperFirmwareUpdater/configs/board.config
6. Open the update-firmware.cfg file and add the board (without .config) in the "boards" array, -> See explanation down below
7. Make the script executable -> chmod +X update-firmware.sh
8. Execute the script -> ./update-firmware.sh
