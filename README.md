# xosx

Turn Xubuntu into a macOS like experience for powerusers. This is not intended to fully or in part recreate the look of macOS, but mostly just the feel and workflow.

This script installs packages and configurations to make xubuntu feel more like macOS to allow for macOS developers to switch seamlessly between a Linux Desktop OS and macOS. It's also somewhat modeled after my experience with using GalliumOS, but sadly it is designed specifically for chromebooks only.

### Limitations

At the moment the key swap of Alt, Ctrl, and Super is only tested with Lenovo Thinkpads. You can still attempt to apply the Xmodmap file, but it might not work without modification.

To undo Xmodmap changes type in `setxkbmap -layout "us"` and `rm ~/.Xmodmap && rm ~/.xinitrc`

### Changes to Xubuntu

Swap left side keys - Alt is Ctrl (to be like Cmd), Super key is Alt, Ctrl is Super key

### TODO

Create function that reads the xmodmap and recreates new xmodmap files for swapping keys in a manner that aligns with macOS.

