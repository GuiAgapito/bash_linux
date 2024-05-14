#!/bin/bash

# Função para instalar programas no Ubuntu
install_on_ubuntu() {
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

    # Verifica e instala Flatpaks no Ubuntu
    echo "Instalando Flatpaks no Ubuntu..."
    sudo apt install flatpak -y
    sudo add-apt-repository ppa:flatpak/stable -y
    sudo apt update
    sudo apt install flatpak -y

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
}

# Função para instalar programas no Pop!_OS
install_on_pop() {
    # Instala programas no Ubuntu (Pop!_OS é baseado no Ubuntu)
    install_on_ubuntu
}

# Função para instalar programas no Fedora
install_on_fedora() {
    # Adiciona o repositório do Google Chrome
    echo "Adicionando repositório do Google Chrome..."
    sudo dnf install fedora-workstation-repositories -y
    sudo dnf config-manager --set-enabled google-chrome
    sudo dnf install google-chrome-stable -y

    # Adiciona o repositório do Visual Studio Code
    echo "Adicionando repositório do Visual Studio Code..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    # Atualiza a lista de pacotes
    echo "Atualizando lista de pacotes e sistema..."
    sudo dnf update -y

    # Instala o Visual Studio Code
    echo "Instalando o Visual Studio Code..."
    sudo dnf install code -y

    # Verifica e instala Flatpaks no Fedora
    echo "Instalando Flatpaks no Fedora..."
    sudo dnf install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

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
}

# Verifica o sistema operacional e chama a função apropriada
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" == "ubuntu" ]; then
        install_on_ubuntu
    elif [ "$ID" == "pop" ]; then
        install_on_pop
    elif [ "$ID" == "fedora" ]; then
        install_on_fedora
    else
        echo "Distribuição não suportada."
    fi
fi
