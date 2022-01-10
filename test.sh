dotfilesrepo="https://github.com/lukesmithxyz/voidrice.git
progsfile="https://raw.githubusercontent.com/LukeSmithxyz/LARBS/master/progs.csv

pacman --noconfirm -S archlinux-keyring
pacman --noconfirm --needed -S artix-keyring artix-archlinux-support

pacman -Sy >/dev/null 2>&1
			pacman-key --populate archlinux
      
      manualinstall() { # Installs $1 manually. Used only for AUR helper here.
	# Should be run after repodir is created and var is set.
	dialog --infobox "Installing \"$1\", an AUR helper..." 4 50
	sudo -u "$name" mkdir -p "$repodir/$1"
	sudo -u "$name" git clone --depth 1 "https://aur.archlinux.org/$1.git" "$repodir/$1" >/dev/null 2>&1 ||
		{ cd "$repodir/$1" || return 1 ; sudo -u "$name" git pull --force origin master;}
	cd "$repodir/$1"
	sudo -u "$name" -D "$repodir/$1" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
}



#main repo
curl ca-certificates base-devel git ntp zsh




sudo -u "$name" $aurhelper -S libxft-bgra-git















xorg-server
xorg-xwininfo
xorg-xinit
ttf-linux-libertine
    lf-git
bc
xcompmgr
xorg-xprop
arandr
dosfstools
libnotify
dunst
exfat-utils
sxiv
xwallpaper
ffmpeg
gnome-keyring
    gtk-theme-arc-gruvbox-git
neovim
mpd
mpc
mpv
man-db
ncmpcpp
newsboat
    brave-bin
noto-fonts-emoji
ntfs-3g
pipewire
pipewire-pulse
pulsemixer
pamixer
    sc-im
maim
    abook
unclutter
unrar
unzip
lynx
xcape
xclip
xdotool
xorg-xdpyinfo
youtube-dl
zathura
zathura-pdf-mupdf
poppler
mediainfo
atool
fzf
highlight
xorg-xbacklight
    zsh-fast-syntax-highlighting-git
    task-spooler
    simple-mtpfs
    htop-vim-git
https://github.com/LukeSmithxyz/dwmblocks.git
https://github.com/lukesmithxyz/dmenu.git
https://github.com/lukesmithxyz/st.git
https://github.com/lukesmithxyz/dwm.git
    mutt-wizard-git
slock
socat
moreutils
