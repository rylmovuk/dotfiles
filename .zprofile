
# Set default terminal (for i3-sensible-terminal)
export TERMINAL=urxvt

# Default browser
if [ -n "$DISPLAY" ]; then
    export BROWSER=firefox
else 
    export BROWSER=links
fi

# Load X & i3 on startup
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

