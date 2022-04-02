#!/bin/bash
sudo apt install git
sudo apt install curl
clear
curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 2 

echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="
echo -e "\e[1m\e[32m ENTER_SUBSPACE_WALLET_ADDRESS \e[0m"
read -p "YOUR_SUBSPACE_WALLET_ADDRESS : " SUBSPACE_WALLET_ADDRESS

echo -e "\e[1m\e[32m ENTER_SUBSPACE_NODE_NAME \e[0m"
read -p "YOUR_SUBSPACE_NODE_NAME : " SUBSPACE_NODE_NAME

echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="

cd $HOME
sudo apt update && sudo apt upgrade -y
sudo apt install wget -y
wget -O subspace-node https://github.com/subspace/subspace/releases/download/snapshot-2022-mar-09/subspace-node-ubuntu-x86_64-snapshot-2022-mar-09
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/snapshot-2022-mar-09/subspace-farmer-ubuntu-x86_64-snapshot-2022-mar-09
sudo mv subspace* /usr/local/bin/
sudo chmod +x /usr/local/bin/subspace*

sudo adduser --system --home=/var/lib/subspace subspace

echo -e "\e[1m\e[32m7. Creating service...\e[0m"

echo "[Unit]
Description=Subspace Node
After=network.target
[Service]
Type=simple
User=subspace
ExecStart=subspace-node --chain testnet --wasm-execution compiled --execution wasm --bootnodes \"/dns/farm-rpc.subspace.network/tcp/30333/p2p/12D3KooWPjMZuSYj35ehced2MTJFf95upwpHKgKUrFRfHwohzJXr\" --rpc-cors all --rpc-methods unsafe --ws-external --validator --telemetry-url \"wss://telemetry.polkadot.io/submit/ 1\" --name $SUBSPACE_NODE_NAME
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/subspace-node.service

echo "[Unit]
Description=Subspace Farmer
Requires=subspace-node.service
After=network.target
After=subspace-node.service
[Service]
Type=simple
User=subspace
ExecStart=subspace-farmer farm --reward-address=$SUBSPACE_WALLET_ADDRESS
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/subspace-farmer.service


sudo systemctl daemon-reload
sudo systemctl enable subspace-node subspace-farmer
sudo systemctl restart subspace-node subspace-farmer
