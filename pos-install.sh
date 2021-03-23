#!/bin/bash
# ----------------------------- VARIÁVEIS ----------------------------- #
#URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
#URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"

DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

PROGRAMAS_PARA_INSTALAR=(
  snapd
  build-essential
  flatpak
  default-jre
  git
  gnome-shell-extensions 
  gnome-tweaks
  gnome-sushi
  gnome-startup-applications
  pavucontrol
  neofetch
  libvulkan1:i386 
  libgnutls30:i386 
  libldap-2.4-2:i386 
  libgpg-error0:i386 
  libxml2:i386 
  libasound2-plugins:i386 
  libsdl2-2.0-0:i386 
  libfreetype6:i386 
  ubuntu-restricted-extras
  vim
)
# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
#sudo rm /var/lib/dpkg/lock-frontend
#sudo rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
sudo dpkg --add-architecture i386

### Instalando requerimentos.
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
	flatpak \
    gnupg-agent \
	gnome-software-plugin-flatpak \
    software-properties-common -y


### Atualizando sistema após adição de novos repositórios.
sudo apt update && sudo apt upgrade -y

## Adicionando repositórios de terceiros e suporte a Snap (Driver Logitech, Lutris e Drivers Nvidia)##
#sudo apt-add-repository "$PPA_LIBRATBAG" -y
#sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
#wget -nc "$URL_WINE_KEY"
#sudo apt-key add winehq.key
#sudo apt-add-repository "deb $URL_PPA_WINE bionic main"
# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #

## Download e instalaçao de programas externos ##
#mkdir "$DIRETORIO_DOWNLOADS"
#wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"
#wget -c "$URL_SIMPLE_NOTE"         -P "$DIRETORIO_DOWNLOADS"
#wget -c "$URL_4K_VIDEO_DOWNLOADER" -P "$DIRETORIO_DOWNLOADS"
#wget -c "$URL_INSYNC"              -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
#sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    sudo apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

sudo apt install apt-transport-https curl gnupg

curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser

#sudo apt install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y

## Instalando pacotes Flatpak ##
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.obsproject.Studio -y

## Instalando pacotes Snap ##
sudo snap install spotify
sudo snap install discord
sudo snap install --classic code

# ---------------------------------------------------------------------- #

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
flatpak update

sudo apt autoclean
sudo apt autoremove -y
sudo rm -rf /var/cache/snapd
sudo rm -rf ~/snap
# ---------------------------------------------------------------------- #
