sudo apt -y install wget
mkdir max-scripts
wget https://raw.githubusercontent.com/AlphaTeamRo/max-installer/main/max-scripts/setup.sh -P max-scripts
cd max-scripts
chmod +x setup.sh
sudo ./setup.sh