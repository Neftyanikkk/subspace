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
rm -rf subspace*
wget -O subspace-node https://github.com/subspace/subspace/releases/download/snapshot-2022-mar-09/subspace-node-ubuntu-x86_64-snapshot-2022-mar-09
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/snapshot-2022-mar-09/subspace-farmer-ubuntu-x86_64-snapshot-2022-mar-09
chmod +x subspace*
mv subspace* /usr/local/bin/

echo -e "\e[1m\e[32m7. Creating service...\e[0m"

echo "[Unit]
Description=Subspace Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which subspace-node) --chain testnet --wasm-execution compiled --execution wasm --bootnodes \"/dns/farm-rpc.subspace.network/tcp/30333/p2p/12D3KooWPjMZuSYj35ehced2MTJFf95upwpHKgKUrFRfHwohzJXr\" --rpc-cors all --rpc-methods unsafe --ws-external --validator --telemetry-url \"wss://telemetry.polkadot.io/submit/ 1\" --name $SUBSPACE_NODE_NAME
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/subspaced.service


echo "[Unit]
Description=Subspaced Farm
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which subspace-farmer) farm
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/subspaced-farmer.service

mv $HOME/subspaced* /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced subspaced-farmer
sudo systemctl restart subspaced
sudo systemctl restart subspaced-farmer
echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="
echo -e "\e[1m\e[32m Public key : \e[0m"
subspace-farmer identity view --public-key
echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="
echo -e "\e[1m\e[32m Save your mnemonic : \e[0m"
subspace-farmer identity view --mnemonic
echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="
