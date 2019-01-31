# xosx

Turn Xubuntu into a macOS like experience for powerusers. This is not intended to fully or in part recreate the look of macOS, but mostly just the feel and workflow.

This script installs packages and configurations to make xubuntu feel more like macOS to allow for macOS developers to switch seamlessly between a Linux Desktop OS and macOS. It's also somewhat modeled after my experience with using GalliumOS, but sadly it is designed specifically for chromebooks only.

### Limitations

At the moment the key swap of Alt, Ctrl, and Super is only tested with Lenovo Thinkpads. You can still attempt to apply the Xmodmap file, but it might not work without modification.

To undo Xmodmap changes type in `setxkbmap -layout "us"` and `rm ~/.Xmodmap && rm ~/.xinitrc`

### Changes to Xubuntu

Swap left side keys - Alt is Ctrl (to be like Cmd), Super key is Alt, Ctrl is Super key

### Applications this will install
 vim, konsole, jq, osx-arc-collection, zsh, plank

### TODO

- Install Albert, hide from tray, set hot key ctrl+space, extensions tab enable Applications, Calculator, chrome bookmarks
- Install Chrome stable by default
- Plank icon fix - Create systemd service that updates the directory /usr/share/applications with proper app desktop shortcuts, need to track monitor /var/lib/snapd/desktop/applications/ directory for any snap additions. If a new desktop file is added to standard path make sure it has the proper entry in it StartupWMClass.
- Install Numix Circle icon theme by default
- Add system tray date format to match osx
- Systemd service to modify current theme css to apply proper weight vala-menuapp /gtk-3.0/gtk.css
- Add logic to link konsole.css file to konsole so that tabs will be properly themed. Could be neat to create a background service that always matches the tabs to the konsole bg color automatically.
- Need to add hotcorner lock script and use either xflock4 or lxdm (galliumOS) for login screen
- Need to add logic for adding .Xmodmap dependent on the keyboard plugged in, may want to create a service that monitors the keyboard being used and automatically modify and fix the xmodmap file used on that.
- Added python3 keyswap file for konsole terminal, need to automate the autostart setup.
- Need to add xclip and this shortcut command - sh -c 'sleep 0.5; xdotool type "$(xclip -o -selection clipboard)"' to emulate paste into konsole on Super+V.