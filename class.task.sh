#!/bin/bash
#----------------------------------------------------------------------------------
#THIS SCRIPT IS WRITTEN TO AUTOMATE SOME OF THE SIMPLE TASKS WE HAD IN LINUX.
#----------------------------------------------------------------------------------
PS3='PLEASE CHOOSE THE TASK YOU WISH THE SCRIPT DO IT FOR YOU : '
tasks=("ADDING USER" "INFO ABOUT YOUR SERVER" "INSTALL APACHE" "NOTHING")
select job in "${tasks[@]}"
	do
	case $job in 
	"ADDING USER")
	echo -e "\033[1;3m ADDING USER TO THE SYSTEM \033[0m "
	read -p "please type in a name for the user: " username
#----------------------------------------------------------------------------------
#first checking if the user already exists in the system or not!
#----------------------------------------------------------------------------------
	id $username &>/dev/null
if [[ $? == 0 ]]; then 
echo -e "this \033[1;3;34;47m $username \033[0m already exists"
	break
else
	read -p "do you want to assign a password to $username? (y/n) " password
	read -p "do you want this user to have root privileges? (y/n) " privilege
if [[ $password == y ]]; then
	read -sp " please type in a password for the $username: " key
echo
fi
fi
#----------------------------------------------------------------------------------
#now encrypting the password of the user and saving it to the variable key
#----------------------------------------------------------------------------------
echo -e "\033[1;3m installing perl to add user with a password \033[0m"
which perl &>/dev/null || yum -y install perl 
pass=$(perl -e 'print crypt($ARGV[0], "password")' $key)
if [[ $password == y ]] && [[ $privilege == y ]]; then
useradd -m -g wheel -p $pass $username
elif [[ $password == n ]] && [[ $privilege == n ]]; then
useradd $username
elif [[ $password == y ]] && [[ $privilege == n ]]; then
useradd -m -p $pass $username
else
useradd -m -g wheel $username
fi
echo -e "\033[1;3;31;47m successfully added \033[0m \033[1;3;34;47m $username \033[0m to the system"
echo -e " \033[1;3m BELLOW YOU CAN SEE THE INFORMATION OF THE $username \033[0m "
uid=$(cat /etc/passwd | grep -i mori | awk -F: '{print $3}')
time=$(date +"%H:%M:%S")
group=$(id $username | awk '{print $3}' | cut -d = -f 2)
passkey=$(cat /etc/shadow | grep -i $username | awk -F: '{print $2}')
#----------------------------------------------------------------------------------
#print out the information of the created user on the terminal
#----------------------------------------------------------------------------------
printf "user:\t%s\nuid:\t%s\ntime:\t%s\ncreated by:\t%s\ngroup:\t%s\npasskey:\t%s\n" "$username" "$uid" "$time" "$USER" "$group" "$passkey"
       	echo
	sleep 5
	;;
	"INFO ABOUT YOUR SERVER")
	echo -e " \033[1;3m BELOW IS THE INFO ABOUT YOUR SERVER \033[0m "
kernel=$(hostnamectl | sed -n '9p' | awk -F: '{print $2}')
OS=$(hostnamectl | sed -n '7p' | awk -F: '{print $2}')
server=$(hostnamectl | head -n 1 | awk -F: '{print $2}')
ip=$(ifconfig | grep -i inet | sed -n '1p' | awk '{print $2}')
echo -e "\033[1;3m"
	printf "kernel:\t%s\nOS:\t%s\nserver:\t%s\ndate:\t%s\nusername:\t%s\nip addr:\t%s\n" "$kernel" "$OS" "$server" "$(date)" "$USER" "$ip"
echo -e "\033[0m"
	sleep 1
	;;
	"INSTALL APACHE")
	which httpd &>/dev/nul
	if [[ $? == 0 ]]; then echo -e "\033[1;3m YOU ALREADY HAVE APACHE \033[0m"
	fi
	which httpd &>/dev/null
	if [[ $? != 0 ]]; then echo -e "\033[1;3m let's install \033[0m \033[1;3;31;47m  apache \033[0m "; yum -y install httpd
	read -p 'DO YOU WANT TO START AND ENABLE IT?(Y/N) ' answer
	if [[ $answer == y ]]; then systemctl start httpd && systemctl enable httpd; echo -e "\033[1;3m apache is enabled and started \033[0m "
	else 
	echo -e " \033[1;3m APACHE IS NOW  INSTALLED BUT NOT ENABELD \033[0m "
	fi
	fi
	;;
	"NOTHING")
	echo -e "\033[1;3m ok! thanks for answering bye!\033[0m "
	break
	;;
	*)
	echo "SORRY,INVALID TASK.$REPLY"
	;;
esac
done
