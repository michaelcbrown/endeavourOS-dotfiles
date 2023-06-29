sudo pacman -Syu code zsh mcfly zoxide alacritty gnome-keyring ranger picom obsidian

chsh -s /usr/bin/zsh

mkdir Documents/repos
cd Documents/repos
git clone https://github.com/michaelcbrown/endeavourOS-dotfiles

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

Use lxappearance to change theme to Zukitwo, mouse cursor to Adwaita

### brightness
yay -Syu brillo

sudo gpasswd -a mb video  
  
sudo touch /etc/udev/rules.d/backlight.rules

Add:
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"
To that file

### xed
[https://www.reddit.com/r/linuxmint/comments/oi9ou0/changing_xed_preferences_from_terminal/](https://www.reddit.com/r/linuxmint/comments/oi9ou0/changing_xed_preferences_from_terminal/)  
  
gsettings monitor org.x.editor.preferences.editor  
  
Then change a setting within xed to see that setting's name, which led to:

gsettings set org.x.editor.preferences.editor use-default-font false
gsettings set org.x.editor.preferences.editor editor-font 'Source Code Pro 16'