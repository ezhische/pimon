welcome(){
  echo "  This script will install if not installed: python-pip python -dev and python module paho-mqtt,"
  echo "  pyyaml, psutil and install service pimon."
  read -r -p "  Do you want to proceed? [y/N] " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    printf ""
  else
    exit
  fi	
}

install_python(){
  sudo apt update -y
  sudo apt install -y python3 python3-pip python-dev
}

printm(){
  length=$(expr length "$1")
  length=$(($length + 4))
  printf "\n"
  printf ":: $1 \n\n"
}

print_green(){
  tput setaf 2; echo "$1"
  tput sgr 0
}

print_yellow(){
  tput setaf 3; printf "$1"
  tput sgr 0
}

clone_create_venv(){
  print_yellow "Cloning Repository"
  sudo git clone https://github.com/ezhische/pimon /opt/pimon
  print_yellow "Taking ownership"
  sudo chown -R $USER /opt/pimon
  print_yellow "Installing Virtual Enviroment"
  python3 -m venv /opt/pimon/
}

install_requirements(){
  print_yellow "Installing Python Modules"
  /opt/pimon/bin/python3 -m pip install -r /opt/pimon/requirements.txt
}

update_config(){
  print_green "+ Copy config.yaml.example to config.yaml"
  cp /opt/pimon/config.yaml.example /opt/pimon/config.yaml
  printm "MQTT settings"
  
  printf "Enter mqtt_host: "
  read HOST
  sed -i "s/127.0.0.1/${HOST}/" /opt/pimon/config.yaml

  printf "Enter mqtt_user: "
  read USER
  sed -i "s/mymqttusername/${USER}/" /opt/pimon/config.yaml

  printf "Enter mqtt_password: "
  read PASS
  sed -i "s/\"mymqttpassword/\"${PASS}/" /opt/pimon/config.yaml

  printf "Enter mqtt_port (default is 1883): "
  read PORT
  if [ -z "$PORT" ]; then
    PORT=1883
  fi
  sed -i "s/1883/${PORT}/" /opt/pimon/config.yaml

  printf "Enter mqtt_topic_prefix (default is pimon): "
  read TOPIC
  if [ -z "$TOPIC" ]; then
    TOPIC=pimon
  fi
  sed -i "s/pimon/${TOPIC}/" /opt/pimon/config.yaml

  print_green  "+ config.yaml is updated with provided settings"
}

set_service(){
  printm "Setting service"
  sudo cp /opt/pimon/pimon.service /etc/systemd/system/pimon.service
  sudo systemctl daemon-reload
  sudo systemctl start pimon.service
  sudo systemctl enable pimon.service
}

main(){
  printm "Pimon Monitor installer"
  welcome
  install_python
  clone_create_venv
  install_requirements 
  update_config
  set_service
  printm "Done"
}

main
