sudo pacman -Syu code zsh mcfly zoxide alacritty gnome-keyring ranger picom

chsh -s /usr/bin/zsh

--- go to .config, delete folders that I have versions of

mkdir Documents/repos
cd Documents/repos
git clone https://github.com/michaelcbrown/endeavourOS-dotfiles
cd endeavourOS-dotfiles
ln -sf ~/Documents/repos/endeavourOS-dotfiles/bspwm ~/.config/bspwm
ln -sf ~/Documents/repos/endeavourOS-dotfiles/sxhkd ~/.config/sxhkd
ln -sf ~/Documents/repos/endeavourOS-dotfiles/polybar ~/.config/polybar
ln -sf ~/Documents/repos/endeavourOS-dotfiles/picom ~/.config/picom
ln -sf ~/Documents/repos/endeavourOS-dotfiles/rofi ~/.config/rofi
ln -sf ~/Documents/repos/endeavourOS-dotfiles/alacritty ~/.config/alacritty

mkdir -p ~/.local/share/fonts
ln -sf $REPO/fonts ~/.local/share/fonts
fc-cache -fv

cd ~/Documents/repos
wget --no-check-certificate http://install.ohmyz.sh -O - | sh
git clone https://github.com/robbyrussell/oh-my-zsh.git
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

[https://github.com/CameronNemo/brillo/blob/trunk/doc/man/brillo.1.md](https://github.com/CameronNemo/brillo/blob/trunk/doc/man/brillo.1.md)


### xed[https://www.reddit.com/r/linuxmint/comments/oi9ou0/changing_xed_preferences_from_terminal/](https://www.reddit.com/r/linuxmint/comments/oi9ou0/changing_xed_preferences_from_terminal/)  
  
gsettings monitor org.x.editor.preferences.editor  
  
Then change a setting within xed to see that setting's name, which led to:  
  
gsettings set org.x.editor.preferences.editor editor-font 'Source Code Pro 16'  
  
Can also do  
  
gsettings set org.x.editor.preferences.editor scheme tango  
  
But that seems to be the default theme right now anyway
