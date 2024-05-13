#!/bin/bash

# Adiciona o repositório do Google Chrome
echo "Adicionando repositório do Google Chrome..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Adiciona o repositório do Visual Studio Code
echo "Adicionando repositório do Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# Atualiza a lista de pacotes
echo "Atualizando lista de pacotes e sistema..."
sudo apt update
sudo apt upgrade -y

# Instala o Google Chrome e o Visual Studio Code
echo "Instalando o Google Chrome e o Visual Studio Code..."
sudo apt install google-chrome-stable code -y

# Verifica o sistema operacional e instala os Flatpaks apropriados
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" == "ubuntu" ]; then
        echo "Instalando Flatpaks no Ubuntu..."
        sudo apt install flatpak -y
        sudo add-apt-repository ppa:flatpak/stable -y
        sudo apt update
        sudo apt install flatpak -y
    elif [ "$ID" == "pop" ]; then
        echo "Instalando Flatpaks no Pop!_OS..."
        sudo apt install flatpak -y
        flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    else
        echo "Distribuição não suportada para instalação de Flatpaks."
    fi
fi

# Instala os Flatpaks
echo "Instalando Flatpaks adicionais..."
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub org.filezillaproject.Filezilla -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub org.localsend.localsend_app -y
flatpak install flathub com.brave.Browser -y
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub org.videolan.VLC -y

echo "Instalação concluída!"
