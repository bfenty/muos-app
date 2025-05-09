#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}

if [[ -d "/opt/system/Tools/PortMaster/" ]]; then
	controlfolder="/opt/system/Tools/PortMaster"
elif [[ -d "/opt/tools/PortMaster/" ]]; then
	controlfolder="/opt/tools/PortMaster"
elif [[ -d "${XDG_DATA_HOME}/PortMaster/" ]]; then
	controlfolder="${XDG_DATA_HOME}/PortMaster"
else
	controlfolder="/roms/ports/PortMaster"
fi

# trunk-ignore(shellcheck/SC1091)
source "${controlfolder}/control.txt"
# trunk-ignore(shellcheck/SC1090)
[[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ]] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

GAMEDIR="/${directory}/ports/RomM"
LOG_DIR="${GAMEDIR}/logs"

mkdir -p "${LOG_DIR}"

cd "${GAMEDIR}" || exit

# trunk-ignore(shellcheck/SC2155)
export LOG_FILE="${LOG_DIR}/$(date +'%Y-%m-%d').log"
export PYSDL2_DLL_PATH="/usr/lib"
export LD_LIBRARY_PATH="${GAMEDIR}/libs:${LD_LIBRARY_PATH}"
export SDL_GAMECONTROLLERCONFIG="${sdl_controllerconfig}"

# Run the app
pm_platform_helper "python" >dev/null
python main.py >"${LOG_FILE}" 2>&1

# Cleanup
pm_finish
