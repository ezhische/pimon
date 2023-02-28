# Pimon: a Raspberry/Orange Pi MQTT system monitor

**This is a fork of [kobbejager/pimon](https://github.com/hjelev/rpi-mqtt-monitor). See below for an overview of the differences**

Gather system information and send it to MQTT server. Pimon is written in python and gathers information about your system cpu load, cpu temperature, free space, used memory, free memory, swap usage, uptime, wifi signal quality, voltage and system clock speed. The script is rewritten for Orange Pi Ubuntu image tested also on x86 Ubuntu 22.04 Server.

Raspberry/Orange Pi MQTT monitor integrates with [home assistant](https://www.home-assistant.io/). The script works fine in Python 3 and is very light on the cpu, there are some sleeps in the code due to mqtt communication having problems if the messages are shot with out delay.

Each value measured by the script is sent via a separate message for easier creation of home assistant sensors.

## Differences with kobbejager/pimon

Pimon ...
* some data collection moved from bash to psutil module
* Fixed Home Assistant discovery
* Added memory free in percents and MiB
* has automated installation script

but ...
* is Python 3 only (Python 2 was officially depreciated on January 1 2020!)


## Installation

### Automated Installation
Run this command to use the automated installation:

```bash
bash <(curl -s https://raw.githubusercontent.com/ezhische/pimon/master/remote_install.sh)
```
Pimon MQTT monitor will be intalled in the /opt/pimon.

The auto-installer needs the software below and will install it if its not found:

* python3
* python-pip
* pithon-dev
* git

All dependancies should be handeled by the auto installation. It will also help you configure the host and credentials for the mqtt server in config.yaml and create the sevice for you.

### Manual Installation

These instructions are tested on Orange Pi Ubuntu Jammy, 64bit, and might differ a little on other versions of Raspberry Pi Os and Linux.

Install pip and venv and git if you don't have it:
```bash
sudo apt install python3-pip python3-venv git
```

Clone the repository:
```bash
git clone https://github.com/ezhische/pimon.git
```

Create the virtual environment and install dependencies:
```bash
cd pimon
python -m venv .   # Creating a virtual environment for our application
source bin/activate  # Activating the virtual environment
pip install -r requirements.txt  # Installing requirements
```

### Configuration

Copy ```config.yaml.example``` to ```config.yaml```
```bash
cp config.yaml.example config.yaml
```

Populate the variables for MQTT host, user, password and main topic in ```config.yaml```, as well as other configurable parameters. You can use the command ```nano config.yaml``` to open the file in a text editor.

### Test Pimon

Run the script within an active venv (your command line indicates this):
```bash
python pimon.py
```

Run the script outside the venv:
```bash
./bin/python pimon.py
```

Pimon will run in an infinite loop. Tap Ctrl-C to stop the script.

### Deploy the script

An example Systemd service unit is supplied. Herein, it is assumed that the script was installed in the ```/opt/pimon``` directory. If not, you can change the __3__ occurences of the path in the file ```pimon.service```.

pimonuser chahnge to user wich will run service

Install the service unit in Systemd:
```bash
sudo install -m 644 ./pimon.service /etc/systemd/system/pimon@pimonuser.service
```

Enable and activate the service unit:
```bash
sudo systemctl enable --now pimon@pimonuser.service
```
