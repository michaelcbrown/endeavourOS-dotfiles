sudo pacman -Syu code zsh mcfly zoxide alacritty gnome-keyring ranger picom obsidian dropbox

chsh -s /usr/bin/zsh

mkdir Documents/repos
cd Documents/repos
git clone https://github.com/michaelcbrown/endeavourOS-dotfiles

# Turns out I do need to delete the existing config folders before doing this
ln -sf ~/Documents/repos/endeavourOS-dotfiles/bspwm ~/.config
ln -sf ~/Documents/repos/endeavourOS-dotfiles/sxhkd ~/.config
ln -sf ~/Documents/repos/endeavourOS-dotfiles/polybar ~/.config
ln -sf ~/Documents/repos/endeavourOS-dotfiles/picom ~/.config
ln -sf ~/Documents/repos/endeavourOS-dotfiles/rofi ~/.config
ln -sf ~/Documents/repos/endeavourOS-dotfiles/alacritty ~/.config

ln -s ~/Documents/repos/endeavourOS-dotfiles/fonts ~/.local/share/fonts
fc-cache -fv

wget --no-check-certificate http://install.ohmyz.sh -O - | sh
ln -sf $REPO/zshrc/.zshrc ~/.zshrc

yay -Syu zuki-themes

# Use lxappearance: theme > Zuiktwo, system font > Cantarell 14, mouse > Adwaita
# Or, the config file appears to be in ~/.config/gtk-3.0/settings.ini

yay -Syu brillo
sudo gpasswd -a mb video
sudo touch /etc/udev/rules.d/backlight.rules
sudo xed /etc/udev/rules.d/backlight.rules

#Add this:
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"

# Can adjust xed settings with this:
gsettings set org.x.editor.preferences.editor use-default-font false
gsettings set org.x.editor.preferences.editor editor-font 'Source Code Pro 16'

# Also, can figure out similar settings using this:
gsettings monitor org.x.editor.preferences.editor  
# Then change a setting within xed to see that setting's name