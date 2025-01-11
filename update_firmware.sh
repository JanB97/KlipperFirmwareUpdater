#!/bin/bash

CONFIG_FILE="update_firmware.cfg"

# Prüfen, ob die Datei existiert
if [ -f "$CONFIG_FILE" ]; then
    # Datei laden
    source "$CONFIG_FILE"
else
    echo "Konfigurationsdatei $CONFIG_FILE nicht gefunden!"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Dieses Skript muss mit Root-Rechten ausgeführt werden."
  exit 1
fi


echo "FIRMWARE UPDATER"
echo
for board in "${boards[@]}"; do
	read -r -a board_detail_array <<< "$board"
	echo "Board gefunden: ${board_detail_array[1]} | UUID: ${board_detail_array[2]} | Enabled: ${board_detail_array[0]} | CANBridge: ${board_detail_array[3]}"
	if [ -f "./configs/${board_detail_array[1]}.config" ]; then
		echo "Config gefunden -> /configs/${board_detail_array[1]}.config"
	else
		echo "Config nicht gefunden -> /configs/${board_detail_array[1]}.config"
	fi
	if [ "${board_detail_array[3]}" -eq "1" ] 2>/dev/null; then
		echo "CANBridge ID: ${board_detail_array[4]}"
	fi
	echo
done

mv -f "${klipper_path}/.config" "${klipper_path}/old.config"
KLIPPER_VERSION=$(git -C ${klipper_path} describe --tags)
service klipper stop

for board in "${boards[@]}"; do
        read -r -a board_detail_array <<< "$board"
        if [ ! -f "./configs/${board_detail_array[1]}.config" ]; then
		echo "${board_detail_array[1]} überspringen -> Keine Config-Datei!"
                continue
        fi

	echo "MAKE FIRMWARE -> ${board_detail_array[1]}"
        echo
        make -C "$klipper_path" clean
        cp -f "./configs/${board_detail_array[1]}.config" "${klipper_path}/.config"
        make -C "$klipper_path" -j4
	echo
	echo "Firmware kopieren: ${klipper_path}/out/klipper.bin -> ./firmware/${board_detail_array[1]}-${KLIPPER_VERSION}.bin"
        mv -f "${klipper_path}/out/klipper.bin" "./firmware/${board_detail_array[1]}-${KLIPPER_VERSION}.bin"
	echo
	echo "STOP Klipper"
	echo
	echo "FLASHING Firmware ${board_detail_array[1]}"
	python3 "${katapult_path}/scripts/flashtool.py" -i can0 -u ${board_detail_array[2]} -r

	if [ "${board_detail_array[3]}" -eq "1" ] 2>/dev/null; then
                python3 "${katapult_path}/scripts/flashtool.py" -f "./firmware/${board_detail_array[1]}-${KLIPPER_VERSION}.bin" -d "/dev/serial/by-id/${board_detail_array[4]}"
        else
		python3 "${katapult_path}/scripts/flashtool.py" -i can0 -u ${board_detail_array[2]} -f "./firmware/${board_detail_array[1]}-${KLIPPER_VERSION}.bin"
	fi

	if [ ${keep_old_firmware} -eq "0" ]; then
		echo "Firmware löschen -> ./firmware/${board_detail_array[1]}-${KLIPPER_VERSION}.bin"
		rm -f "./firmware/${board_detail_array[1]}-${KLIPPER_VERSION}.bin"
	fi
	echo
	echo
done

mv -f "${klipper_path}/old.config" "${klipper_path}/.config"
service klipper start
