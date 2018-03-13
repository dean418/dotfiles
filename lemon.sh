#!/usr/bin/bash

clock() {
        DATETIME=$(date "+%a %b %d, %T")
        echo -n "%{F#FFFFFF}%{B#32373B} $DATETIME"
}

volume() {
	vol=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
	echo $vol
}

battery() {
        batPerc=$(acpi --battery | cut -d, -f2)
	batNum=$(acpi --battery | grep -o -P '(?<=g, ).*(?=%)')
	batState=$(acpi --battery | cut -d, -f1 | grep -o -P '(?<=:).*')
	if [[ $batNum -le 15 ]]
	    then
  		echo "%{F#FF0000}%{B#32373B} $batPerc" " $batState"
	    else
		echo "%{F#FFFFFF}%{B#32373B} $batPerc" " $batState"
	fi
}

network() {
    read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
    if iwconfig $int1 >/dev/null 2>&1; then
        wifi=$int1
        eth0=$int2
    else
        wifi=$int2
        eth0=$int1
    fi
    ip link show $eth0 | grep 'state UP' >/dev/null && int=$eth0 ||int=$wifi

    ping -c 1 8.8.8.8 >/dev/null 2>&1 && 
        echo "%{F#00FF00} $int connected" || echo "%{F#FF0000} $int disconnected"
}

groups() {
    output=""
    for row in $(echo "$(i3-msg -t get_workspaces)" | jq -r '.[] | @base64'); do
        json=$(echo ${row} | base64 --decode)
        num=$(echo ${json} | jq .num | cut -d"\"" -f2)
        
        if $(echo ${json} | jq .focused)
       	    then
                output="${output} [${num}]" 
	    else
                output="${output} ${num}"
        fi
    done
    echo $output
}

while :; do
	buf=""
	buf="${buf} $(groups)    "
	echo -e "%{l}%{F#FFFFFF}%{B#32373B} $buf" "%{c}%{A:gsimplecal:}   %{A} $(clock)" "%{r}%{F#FFFFFF}%{B#32373B} $(network) %{F#FFFFFF}%{B#32373B} |    $(volume)% | $(battery)"
	sleep 0.2
done
