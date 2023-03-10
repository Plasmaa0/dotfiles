# ~/bin/get-volume.sh
#!/bin/bash
# Get the maximum volume of any pulseaudio sink channel
# amixer get MasMter | egrep -o "[0-9]+%"
vol=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "MM" } else { print $2 }}' | head -n 1)

echo Vol: $vol%

exit 0