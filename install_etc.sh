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
sudo apt install -y curl software-properties-common apt-transport-https wget


# current ubuntu version
UbuntuVersion=$(lsb_release -rs)

if [[ "$UbuntuVersion" == "18.04" ]]; then
    echo "Detected Ubuntu 18.04. Installing VSCode for 18.04..."
    sudo sh -c 'curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg'
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
elif [[ "$UbuntuVersion" == "20.04" || "$UbuntuVersion" == "22.04" ]]; then
    echo "Detected Ubuntu $UbuntuVersion. Installing VSCode for 20.04 and later..."
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install -y code
else
    echo "Unsupported Ubuntu version: $UbuntuVersion"
    exit 1
fi

# install AntiGravity (ref: https://ko.ubunlog.com/Linux%EC%97%90-Antigravity%EB%A5%BC-%EC%84%A4%EC%B9%98%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95/)
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
sudo apt update
sudo apt install antigravity


