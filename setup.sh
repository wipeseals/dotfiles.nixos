# get current directory
current_dir=$(pwd)

# backup current /etc/nixos
sudo cp -r /etc/nixos /etc/nixos.bak

# remove current /etc/nixos
sudo rm -r /etc/nixos
# create symbolic link to current_dir/etc/nixos
sudo ln -s "$current_dir/etc/nixos" "/etc/nixos"