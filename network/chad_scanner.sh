#!/bin/sh

HEADING='\033[0;32m'
NOCOLOR='\033[0;0m'

echo " ${HEADING}
░█▀▀░█░█░█▀█░█▀▄░░░█▀▀░█▀▀░█▀█░█▀█░█▀█░█▀▀░█▀▄
░█░░░█▀█░█▀█░█░█░░░▀▀█░█░░░█▀█░█░█░█░█░█▀▀░█▀▄
░▀▀▀░▀░▀░▀░▀░▀▀░░░░▀▀▀░▀▀▀░▀░▀░▀░▀░▀░▀░▀▀▀░▀░▀
${NOCOLOR}"

show_help() {
	echo "Usage: $0 [-i IP_ADDRESS] [-s START_PORT] [-e END_PORT]"
}

target=""
strt=""
end=""

while getopts ":i:s:e:h" opt; do
	case $opt in
	i)
		target="$OPTARG"
		;;
	s)
		strt="$OPTARG"
		;;
	e)
		end="$OPTARG"
		;;
	h)
		show_help
		exit 0
		;;
	\?)
		echo "Invalid option -$OPTARG" >&2
		show_help
		exit 1
		;;
	:)
		echo "Option -$OPTARG requires an argument." >&2
		show_help
		exit 1
		;;
	esac
done

if [ -z "$target" ] || [ -z "$strt" ] || [ -z "$end" ]; then
	echo "Missing parameters :("
	show_help
	exit 1
fi

for port in $(seq $strt $end); do
	(echo >/dev/tcp/$target/$port) >/dev/null 2>&1 && echo "$port is open"
done
