#!/usr/bin/env bash
################################################################################
# author: @t4inha
#
# ! purpose: setup emojis on archlinux. specific used on my distro., manjaro i3.
#
# solution found in: https://chrpaul.de/2019/07/Enable-colour-emoji-support-on-Manjaro-Linux.html
# package: https://archlinux.org/packages/extra/any/noto-fonts-emoji/
################################################################################

set -e # exit in any error

if [[ "$1" = -t ]]; then
echo """# testing area:
  🙂 smile
  🇨🇦 Canada flag (if your font does not support the flag, this may show up as CA)
  Pride flag (part of Emoji 4.0; if your font does not support the flag, this may show up as a white flag and a rainbow)
  🤩 Star-Struck (part of Emoji 5.0)
  🥳 Party head (part of Emoji 11.0)
  🦮 Guide Dog (part of Emoji 12.0)
"""
  exit 0
fi

# 1.install
sudo pacman -S noto-fonts-emoji

# 2.config
mkdir -p ~/.config/fontconfig/

touch ~/.config/fontconfig/fonts.conf
cp ~/.config/fontconfig/fonts.conf{,bak} #bak first

echo '''
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
 <alias>
   <family>sans-serif</family>
   <prefer>
     <family>Noto Sans</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
     <family>DejaVu Sans</family>
   </prefer>
 </alias>

 <alias>
   <family>serif</family>
   <prefer>
     <family>Noto Serif</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
     <family>DejaVu Serif</family>
   </prefer>
 </alias>

 <alias>
  <family>monospace</family>
  <prefer>
    <family>Noto Mono</family>
    <family>Noto Color Emoji</family>
    <family>Noto Emoji</family>
   </prefer>
 </alias>
</fontconfig>
'''>~/.config/fontconfig/fonts.conf # edit config

echo '# run again with "-t" to test the fonts :D'
echo '# you may need restart your computer.'


