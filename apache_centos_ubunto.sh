#!/bin/bash
#--------------------------------------------------------------------------------------
#This script is to install apache on centos and ubunto.
#--------------------------------------------------------------------------------------
OS=$(hostnamectl | sed -n '7p' | awk -F: '{print $2}' | awk '{print $1}')
echo -e "\033[1;3m THIS IS YOUR OPERATING SYSTEM \033[0m \033[1;3;32;47m $OS \033[0m \033[1;3m SO LET'S INSTALL \033[0m \033[1;3;32;47m APACHE \033[0m "
#--------------------------------------------------------------------------------------
#now that we determine the OS we can install apache accordingly
#---------------------------------------------------------------------------------------
    if [[ $OS == CentOS ]]; then 
        which httpd &>/dev/null || yum -y install httpd; echo -e " \033[1;3m apache is now installed \033[0m "
    else
        which apache2 &>/dev/null || apt update && apt -y install apache2; echo -e " \033[1;3m apache is now installed \033[0m " 
    fi
#---------------------------------------------------------------------------------------
#after installation we want to make sure our service is running!
#---------------------------------------------------------------------------------------
id apache &>/dev/null
    if [[ $OS == CentOS ]] && [[ $? == 0 ]]; then   
        read -p 'Do you wish to start and enable apache now?(y/n)? ' answer 
        if [[ $answer == y ]]; then     
        systemctl start httpd && systemctl enable httpd 
    else
        echo -e "\033[1;3m apache won't be running \033[0m \033[1;3;33m !!! \033[0m "
        fi
    fi
which apache2 &>/dev/null
    if [[ $OS == Ubuntu ]] && [[ $? == 0 ]]; then       
        echo -e "\033[1;3m BY DEFAULT APACHE IS ENABLED AFTER INSTALLATION \033[0m "
    fi















