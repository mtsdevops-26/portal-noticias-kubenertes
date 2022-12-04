#!/bin/bash
set -e
#apt-get install -y curl

cat << "EOF"

╔════•ೋೋ•════╗ 
  MTSDEVOPS    
╚════•ೋೋ•════╝
 ___ _   _ ____ _____  _    _     _
|_ _| \ | / ___|_   _|/ \  | |   | |
 | ||  \| \___ \ | | / _ \ | |   | |
 | || |\  |___) || |/ ___ \| |___| |___
|___|_| \_|____/ |_/_/   \_\_____|_____|
 ____   ___   ____ _  _______ ____       
|  _ \ / _ \ / ___| |/ / ____|  _ \      
| | | | | | | |   | ' /|  _| | |_) |
| |_| | |_| | |___| . \| |___|  _ <|
|____/ \___/ \____|_|\_\_____|_| \_\

EOF

cat << EOF
Open source Docker CE and Docker compose install
Copyright 2018-$(date +'%Y'), Yago Martis Devops
https://github.com/mtsdevops-26
===================================================
EOF

#Verifique executando como root:
check_user() {
    USER_ID=$(/usr/bin/id -u)
    return $USER_ID
}

if [ "$USER_ID" > 0 ]; then
    printf "You must be a root user" 2>&1
    exit 1
fi


#Certifique-se de ter o git instalado
check_git(){
    if ! [ -x "$(command -v git)" ]; then
        echo -e -n "${CYAN}(!)${NC} - Error: git is not installed. Please Install\n"
        exit 1
    fi
}


# Certifique-se de ter o curl instalado.
check_curl() {
    OS=$(sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/os-release)
    if ! [ -x "$(command -v curl)" ]; then
        printf "\033[31m ERROR: can't find CURL \033[0m\n"
        printf '\033[32m INSTALLING CURL\033[0m\n'
        if [ "$OS" == Debian ]; then
            apt-get update
            apt-get install -y curl
            elif [ "$OS" == CentOS ]; then
            yum -y install curl
            yum -y install deltarpm
            yum -y install yum-utils device-mapper-persistent-data
         else
        if [ -x "$(command -v curl)" ]; then
        printf "CURL is installed on this server\n"
        fi
    fi
fi
}

# download do compositor e instalação
downloadcomposer() {
    # get latest docker compose released tag
    export COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    # Install docker-compose
    sh -c "curl -L http://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
    sh -c "curl -L http://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
    chmod a+rx '/usr/local/bin/docker-compose' 
}

#verifica se o docker está instalado
check_docker(){
    if [ -x "$(command -v docker)" ]; then
        printf "Docker Installed\n"
        docker --version
        echo ""
    else
        printf '\033[32m INSTALLING DOCKER\033[0m\n'
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
    fi
}

#verifique se o docker Compose está instalado
check_compose(){
    if [ -x "$(command -v docker-compose)" ]; then
        printf "Docker Compose Installed :)\n "
        docker-compose --version
        echo ""
    else
        printf '\033[32m INSTALLING DOCKER COMPOSE\033[0m\n'
        #Instalar docker-compose
        downloadcomposer
    fi
}

check_git
check_curl
check_docker
check_compose


exit 0;