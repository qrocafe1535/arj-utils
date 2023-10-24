instala_adw3 () { # habilita suporte a temas libadwaita trazendo melhora visual ao desktop.
	mkdir -p $HOME/Downloads/adw3
	wget -P $HOME/Downloads/adw3 https://github.com/lassekongo83/adw-gtk3/releases/download/v5.1/adw-gtk3v5-1.tar.xz
	sudo tar -xf $HOME/Downloads/adw3/adw-gtk3v5-1.tar.xz -C /usr/share/themes
	gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
	flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
		echo -e "\n${VERDE}Habilitado suporte a thema legado libadwaita dark!${SEM_COR}\n"
		sleep 1
}

cron_update_auto () { # automatiza update do systema
	# exporta o comando para o arquivo em /etc/crontab
	echo "0 9 * * * /usr/bin/apt update && /usr/bin/apt upgrade -y && /usr/bin/apt dist-upgrade -y && /usr/bin/apt autoremove -y " | sudo tee -a /etc/crontab
	echo -e "\n${VERDE}Habilitado Update Automático com sucesso todo dia as 09:00.${SEM_COR}\n"
	sleep 1
}

testes_internet () { # testa conexão com a internet.
		if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
		echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
		exit 1
			else
				echo -e "\n${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}\n"
				sleep 1
		fi
}

travas_apt () { # remove travas do apt
	sudo rm /var/lib/dpkg/lock-frontend
	sudo rm /var/cache/apt/archives/lock
	echo -e "${VERDE}Removido travas no APT${SEM_COR}\n"
	sleep 1
}

misc () { # adiciona arquitetura i386x86 e função na barra de ferramentas.
		sudo dpkg --add-architecture i386
		echo -e "\n${VERDE}Adicionado Misc!${SEM_COR}\n"
		sleep 1
}

system_update () { # atualiza o sistema.
		echo -e "\n${VERDE}Adicionado MISC${SEM_COR}\n"
		sleep 1
		sudo apt-get update && sudo apt-get upgrade -y
}

programas_para_instalar=( #lisagem de programas a serem instalados.
		# DEPENDÊNCIAS.
			net-tools
			traceroute
			ssh
			git
			network-manager-l2tp
			network-manager-l2tp-gnome
			apt-transport-https
			ca-certificates
			libreswan
			libfuse2
			curl
			scrot
			vim
			wget
			htop
			build-essential
			libssl-dev
			libffi-dev
			python3-dev
			python3-pip
			python3-venv
			python3-setuptools
			apt-transport-https
			ca-certificates
			software-properties-common
)

instala_apt_packages () {
	for nome_do_programa in "${programas_para_instalar[@]}"; do
		if ! dpkg -l | awk '{print $2}' | grep -q "^$nome_do_programa$"; then
			echo -e "${VERMELHO}[INSTALANDO...]${SEM_COR} $nome_do_programa..."
			sleep 1
			sudo apt install "$nome_do_programa" -y > /dev/null 2>&1
		else
			echo -e "${VERDE}[INSTALADO]${SEM_COR} - $nome_do_programa"
		fi
	done
}

suporte_flatpak () { # instala suporte a flatpak
		sudo apt-get install flatpak gnome-software-plugin-flatpak -y
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
		echo -e "${VERDE}Adicionado Suporte a Flatpaks${SEM_COR}\n"
		sleep 1
}

instala_winbox () { # instala winbox client
		mkdir -p $HOME/Downloads/Winbox
		git clone https://github.com/qrocafe1535/winbox-installer.git $HOME/Downloads/Winbox
		chmod a+x $HOME/Downloads/Winbox/winbox-setup
		cd $HOME/Downloads/Winbox
		sudo ./winbox-setup install
}

instala_dude () { #instala dude client
		mkdir -p $HOME/Downloads/Dude
		wget -P $HOME/Downloads/Dude https://download.mikrotik.com/routeros/6.48.6/dude-install-6.48.6.exe 
		wine $HOME/Downloads//Dude/dude-install-6.48.6.exe
}

mk_soft () {
		echo -e "Deseja instalar Winbox e Dude?\n"
		select  deseja_instalar in "Sim!" "Não"; do
				case $deseja_instalar in
						Sim! )
						echo "Instalando..."
						instala_winbox
						instala_dude
						break
							;;
						Não )
						echo -e "Ok!...\n"
						exit 1
							;; 
				esac
		done
}

instala_chrome () { # instala google chrome
		mkdir -p $HOME/Downloads/chrome
		wget -P $HOME/Downloads/chrome https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		sudo sudo dpkg -i $HOME/Downloads/chrome/google-chrome-stable_current_amd64.deb
		echo -e "\n${VERDE}Instalado Google Chrome${SEM_COR}\n"
		sleep 1
}

system_clean () {
		sudo apt update -y
		flatpak update -y
		sudo apt autoclean -y
		sudo apt autoremove -y
		sudo rm -r $HOME/Downloads/chrome
		sudo rm -r $HOME/Downloads/Dude
		sudo rm -r $HOME/Downloads/Winbox
		echo -e "\n${VERDE}Sistema limpo!${SEM_COR}\n"
		sleep 1
}

repositorio_non-free () { # habilita o repositório non-free
	sudo apt-add-repository contrib non-free -y
}

instala_wine () { # instala o wine no debian.
	sudo dpkg --add-architecture i386
	sudo mkdir -pm755 /etc/apt/keyrings
	sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
	sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
	sudo apt update
	sudo apt install --install-recommends winehq-stable -y
		echo -e "${VERDE}Wine instalado...${SEM_COR}\n"
		sleep 1
}

main_update_debian () {
	echo -e "\n${AZUL}Começando em 3... 2... 1....\n${SEM_COR}\n"
			sleep 3
				testes_internet
				repositorio_non-free
				misc
				travas_apt
				instala_wine
				instala_apt_packages
				system_update
				suporte_flatpak
				instala_adw3
				instala_chrome
				mk_soft
				system_clean
		echo -e "${AZUL}\nFinalizado com exito!\n${SEM_COR}"
			sleep 3
}