#!/bin/sh

# A basic password generator that generates passwords
# based on inputs from user as well as randomization
# for /dev/urandom which is available on all linux distribution
# apart from that. This script has many potential. If
# you want to change it feel free to fork it and go your
# customizations. Maybe put up a pull request if you think
# it is good enough for others to use.

HEADING='\033[0;32m'
NOCOLOR='\033[0;0m'

echo "${HEADING}
░█▀▀░█░█░▀█▀░█▀▄░▀█▀░█▀▄░▀█▀░░░█▀▀░█▀▀░█▀█░█▀▀░█▀▄░█▀█░▀█▀░█▀█░█▀▄
░▀▀█░█▀▄░░█░░█▀▄░░█░░█░█░░█░░░░█░█░█▀▀░█░█░█▀▀░█▀▄░█▀█░░█░░█░█░█▀▄
░▀▀▀░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀░░▀▀▀░░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀░▀
${NOCOLOR}"

len=16
n=1
file="passwords"

show_help() {
	echo "Usage: $0 [-l LENGTH] [-n NUMBER_OF_PASSWORDS] [-f FILE]"
	echo "    -l LENGTH: Length of each password (default: $len)"
	echo "    -n NUMBER_OF_PASSWORDS: Number of passwords to generate (default: $n)"
	echo "    -f FILE: File to store the passwords (default: $file)"
}

while getopts "l:n:f:h" opt; do
	case "$opt" in
	l) len="$OPTARG" ;;
	n) n="$OPTARG" ;;
	f) file="$OPTARG" ;;
	h)
		show_help
		exit 0
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
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

case "$len" in
*[!0-9]* | '')
	echo "Error: Length must be a positive integer." >&2
	show_help
	exit 1
	;;
*)
	if [ "$len" -le 0 ]; then
		echo "Error: Length must be a positive integer." >&2
		show_help
		exit 1
	fi
	;;
esac

case "$n" in
*[!0-9]* | '')
	echo "Error: Number of passwords must be a positive integer." >&2
	show_help
	exit 1
	;;
*)
	if [ "$n" -le 0 ]; then
		echo "Error: Number of passwords must be a positive integer." >&2
		show_help
		exit 1
	fi
	;;
esac

i=1
while [ "$i" -le "$n" ]; do
	LC_CTYPE=C </dev/urandom tr -dc '[[:alnum:]]@#$%^&*()_+{}|:<>?[]\;,./~' | head -c "$len" >>"$file"
	echo "" >>"$file"
	i=$((i + 1))
done

echo "Passwords have been generated and stored in $file"
