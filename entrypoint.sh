#!/usr/bin/env bash

mountHelp=$(cat <<'EOF'
To work with watchfaces on your computer, mount the directory containing the
watchface(s) to /workspace, e.g.:

    docker run -it --rm \
      # [...] \
      -v $(pwd):/workspace \
      # [...] \  
     watchface
EOF
)

waylandHelp=$(cat <<'EOF'
When running wayland, run the container like this:

    docker run -it --rm  \
      -e XDG_RUNTIME_DIR=/tmp \
      -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
      -e QT_QPA_PLATFORM=wayland \
      -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY  \
      # [...] \
      watchface
EOF
)

# TODO: not tested yet
usbHelp=$(cat <<'EOF'
To give the container access to your watch via USB, run the container like this:

    docker run -it --rm \
      # [...] \
      --device=/dev/ttyUSB0 # replace with path to your device \
      watchface
EOF
)

# TODO: figure out when and how to display which message

# delegate to watchface script
$*

