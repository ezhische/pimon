# Pimon: a Raspberry Pi MQTT system monitor

**This is a fork of [hjelev/rpi-mqtt-monitor](https://github.com/hjelev/rpi-mqtt-monitor). See below for an overview of the differences**

Gather system information and send it to MQTT server. Pimon is written in python and gathers information about your system cpu load, cpu temperature, free space, used memory, swap usage, uptime, wifi signal quality, voltage and system clock speed. The script is written for Raspberry Pi OS but can also be used on any Linux system.

Raspberry Pi MQTT monitor integrates with [home assistant](https://www.home-assistant.io/). The script works fine in Python 3 and is very light on the cpu, there are some sleeps in the code due to mqtt communication having problems if the messages are shot with out delay.

Each value measured by the script is sent via a separate message for easier creation of home assistant sensors.

## Differences with hjelev/rpi-mqtt-monitor

Pimon ...
* is optimised to run in a python venv (better dependency management)
* uses a YAML configuration file
* implements a loop (no need to create a cron job)
* has more MQTT options (better topic prefix, QoS, retain messages)
* features a bulk output in JSON format
* removes redunant code
* was renamed to Pimon, because I like short names ;-)

but ...
* is Python 3 only (Python 2 was officially depreciated on January 1 2020!)
* has no automated installation scripts (yet?)

The changes are heavily influenced by the design of [PiJuice MQTT](https://github.com/dalehumby/PiJuice-MQTT).

## Installation

### Automated Installation
Not (yet) implemented. If you are not accustomed to install Python software on Linux/Raspberry Pi, it is advisable to use the original [hjelev/rpi-mqtt-monitor](https://github.com/hjelev/rpi-mqtt-monitor).

### Manual Installation

These instructions are tested on Rasberry Pi OS Lite bullseye, 64bit, and might differ a little on other versions of Raspberry Pi Os and Linux.

Install pip and venv if you don't have it:
```bash
sudo apt install python3-pip python3-venv
```

Clone the repository:
```bash
git clone https://github.com/ezhische/pimon.git
```

Create the virtual environment and install dependencies:
```bash
cd pimon
python -m venv venv   # Creating a virtual environment for our application
source venv/bin/activate  # Activating the virtual environment
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
./venv/bin/python pimon.py
```

Pimon will run in an infinite loop. Tap Ctrl-C to stop the script.

### Deploy the script

An example Systemd service unit is supplied. Herein, it is assumed that the script was installed in the ```/opt/pimon``` directory. If not, you can change the __3__ occurences of the path in the file ```pimon.service```.

Install the service unit in Systemd:
```bash
sudo install -m 644 ./pimon.service /etc/systemd/system/pimon.service
```

Enable and activate the service unit:
```bash
sudo systemctl enable --now pimon.service
```
