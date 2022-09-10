# Max-installer

## An install script for our humanoid robot, Max
### This repo is public because we want the one-line installer to work

## Install
In the home directory of the robot user, run the following command
```
sudo apt update && sudo apt -y install curl && curl https://raw.githubusercontent.com/AlphaTeamRo/max-installer/main/max-scripts/run.sh | bash && sudo ./setup.sh
```