#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources 2>> ~/.xsession-errors
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap 2>> ~/.xsession-errors
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources" 2>> ~/.xsession-errors
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap" 2>> ~/.xsession-errors
fi

# Start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f" 2>> ~/.xsession-errors
    done
    unset f
fi

# Set keyboard layout
setxkbmap -option grp:alt_shift_toggle us,ru 2>> ~/.xsession-errors

# Start compositor for transparency
picom -f >> ~/.xsession-errors 2>&1 &

# Set default mouse cursor
xsetroot -cursor_name left_ptr 2>> ~/.xsession-errors

# Launch sxhkd for key bindings
sxhkd >> ~/.xsession-errors 2>&1 &

# Set the background
feh --bg-scale ~/Pictures/devushka_kniga_art.jpg >> ~/.xsession-errors 2>&1 &

# Start polybar
polybar mybar >> ~/.xsession-errors 2>&1 &

# Start bspwm as the main window manager
exec bspwm >> ~/.xsession-errors 2>&1
