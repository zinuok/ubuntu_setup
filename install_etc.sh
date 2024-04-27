# install terminator
echo "install chrome start"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install -y google-chrome-stable
sudo rm -rf /etc/apt/sources.list.d/google.list

# install terminator
echo "install terminator start"
sudo apt install -y terminator

# install visual studio code
echo "install vscode start"
sudo apt install -y curl


# sudo sh -c 'curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg'
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# sudo apt update
# sudo apt install -y code

# since VScode drops its support for Ubuntu 18.04 from 2024 Feb., need previous stable version 
wget https://update.code.visualstudio.com/1.85.2/linux-deb-x64/stable

