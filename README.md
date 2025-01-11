# KlipperFirmwareUpdater
Script to automate Firmware Update for your Klipper Devices

## Setup
1. Download the repository and put it on your Pi (or whatever you use for klipper) - Location shouldn't matter, I have mine in /home/pi/ -> git clone https://github.com/JanB97/KlipperFirmwareUpdater
2. Go to your klipper install folder (eg. /home/pi/klipper/) -> cd /home/pi/klipper
3. Create a config for the board you want to have updated -> make menuconfig
4. Exit and save the config
5. Copy or Move the config file for your board to the "configs" folder within the KlipperFirmwareUpdater folder -> mv /home/pi/klipper/.config /home/pi/KlipperFirmwareUpdater/configs/board.config
6. Open the update-firmware.cfg file and add the board (without .config) in the "boards" array, -> See explanation down below
7. Make the script executable -> chmod +X update-firmware.sh
8. Execute the script -> ./update-firmware.sh

### Config File
In the update-firmware.cfg is the "boards" array.
Here you have to add your boards surrounded by "" and with a space inbetween the options.
I have left my config in the file to hopefully make it more clear, but bellow is a short overview of the settings:

boards setting:
1. Enabled -> if "1" the board will be updated
2. Name -> This is the name of the board, you can set whatever you want but the "board.config" file needs to be called the same. Please replace the "board" part with your name
3. UUID -> Canbus UUID of the board. Can be found in your printer.cfg most likely
4. CanBridge-Board? -> If "1" the board will be reset and flashed via the /dev/serial/by-id/ path, as Canbridge boards cannot be flashed with the UUID
5. Optional /by-id/ path if Canbridge-Board -> Set the path to you board (eg.: /dev/serial/by-id/usb-katapult_stm32f446xx_31001A001350324E31333220-if00)

klipper_path: Set the path to your klipper installation

katapult_path: Set the path to your katapult installation

keep_old_firmware: if set to "1" the firmware used for flashen will be kept in the ./firmware/ folder, otherwise it will be removed after flashing.
