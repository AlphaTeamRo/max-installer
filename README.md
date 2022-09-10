# Max-installer

## An install script for our humanoid robot, Max
### This repo is public because we want the one-line installer to work

## Install
As root and in the home directory of the robot user, run the following command
```
apt -y install curl && mkdir max-scripts && curl -sSL https://raw.githubusercontent.com/AlphaTeamRo/max-installer/main/max-scripts/setup.sh | bash
```