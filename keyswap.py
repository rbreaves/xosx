#!/usr/bin/env python3
# Credit to Jacob Vlijm
# https://askubuntu.com/questions/786055/how-can-i-automatically-mute-an-application-when-not-in-focus

from os.path import expanduser
import subprocess, time

home = expanduser("~")

# ---set the proc to pause when not the active window
wclass = "konsole"
# ---

def get(cmd):
    # just a helper function to not repeat verbose subprocess sections
    try:
        return subprocess.check_output(cmd).decode("utf-8").strip()
    except subprocess.CalledProcessError:
        pass

while True:
    # the longer period: application is not running (saving fuel)
    time.sleep(5)
    front1 = ""
    while True:
        # if the application runs, switch to a shorter response time
        time.sleep(0.5)
        # get the possible pid, get() returns "None" if not running,
        # script then switches back to 5 sec check
        pid = get(["pgrep", wclass])
        if pid:
            front2 = wclass in get([
                "xprop", "-id", get(["xdotool", "getactivewindow"])
                ])
            # run either kill -stop or kill -cont only if there is
            # a change in the situation
            if front2 != front1:
                if front2 == True:
                    cm = ["setxkbmap", "-layout", '"us"']
                    print("run") # just a test indicator, remove afterwards
                else:
                    cm = ["xmodmap", home + "/.Xmodmap"]
                    print("stop") # just a test indicator, remove afterwards
                subprocess.Popen(cm)
            front1 = front2
        else:
            break