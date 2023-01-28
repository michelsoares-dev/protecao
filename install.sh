#!/bin/sh
set -e

usage() {
	echo "$0: configura e instala as dependencias de seguranca e monitoria"
	echo 'Revision: $Id$'
	echo ""
	echo "Use: $0:                    Mostrar esta mensagem."
	echo "Use: $0 iptables            Configurar o iptables."
	echo "Use: $0 fail2ban            Configurar o fail2ban."
	echo "Use: $0 monitor             Instala o monitor de clientes."
	echo "Use: $0 installdeps         Instalar os pacotes necessarios."
}
installdeps()
{
	yum -y install epel-release
	yum -y install fail2ban fail2ban-systemd GeoIP GeoIP-data GeoIP-GeoLite-data iptables-services mariadb
	systemctl disable firewalld
	systemctl stop firewalld
}
installmonitor()
{
	cd /bin
	wget -t 1 --timeout=30 --timestamping https://ipbx.agecomnet.com.br/coletaeventos.sh
	chmod 777 /bin/coletaeventos.sh
	cd -

}
configfreepbxf2b()
{
read -p "Digite a senha do MYSQL? " internetshare
	/usr/sbin/fwconsole ma downloadinstall logfiles
	/usr/bin/mysql -p$mysqlpass asterisk << EOF
INSERT logfile_logfiles (name,permanent,readonly,disabled,debug,dtmf,error,fax,notice,verbose,warning,security) values ('security','0','0','0','off','off','off','off','off','off','off','on');
EOF
/usr/sbin/fwconsole r
}
setdosasynprotection()
{
	echo -e "net.ipv4.conf.all.log_martians = 1" > /etc/sysctl.conf
	echo -e "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
	echo -e "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
	echo -e "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.conf
	echo -e "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.conf
	if [ $1 -eq 1 ]
	then
		echo -e "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
	fi
	sysctl -p >/dev/null
}
setiptablesfile()
{
	echo -e "*filter" > /etc/sysconfig/iptables
	echo -e ":INPUT DROP [0:0]" >> /etc/sysconfig/iptables
	echo -e ":FORWARD ACCEPT [0:0]" >> /etc/sysconfig/iptables
	echo -e ":OUTPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
	echo -e "#               Liberacoes padrao, nao alterar sem previa autorizacao." >> /etc/sysconfig/iptables
	echo -e "# IPs confiaveis, redes locais e loopback" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -i lo -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 127.0.0.1 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 192.168.0.0/16 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 172.16.0.0/16 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 10.0.0.0/8 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 200.204.160.206 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 200.49.34.48/29 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 189.126.200.240/28 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 200.155.163.48/29 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 200.201.138.240/28 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 18.231.140.201 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 189.19.223.154 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s 179.110.69.59 -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -s djchacalap.ddns.net -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "# Inicio da area para liberacao de IPs personalizados" >> /etc/sysconfig/iptables
	echo -e "# Fim da area para liberacao de IPs personalizados" >> /etc/sysconfig/iptables
	echo -e "#               Portas dos servicos" >> /etc/sysconfig/iptables
	echo -e "# Porta SSH" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -p tcp -m tcp --dport $sshport -j ACCEPT" >> /etc/sysconfig/iptables
	if [ -f "/etc/httpd/conf/httpd.conf" ]
	then
		echo -e "# Porta HTTP" >> /etc/sysconfig/iptables
		echo -e "-A INPUT -p tcp -m tcp --dport $httplistenport -j ACCEPT" >> /etc/sysconfig/iptables
	fi
	echo -e "# Portas IPBX" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -p udp -m udp --dport $sipport -j ACCEPT" >> /etc/sysconfig/iptables
	for i in "${pjsipports[@]}"
	do :
		echo -e "-A INPUT -p udp -m udp --dport $rtpstart:$rtpend -j ACCEPT" >> /etc/sysconfig/iptables
		echo -e "-A INPUT -p udp -m udp --dport $i -j ACCEPT" >> /etc/sysconfig/iptables
	done
	if [ -f "/var/agecom/callroute/Callroute-pro.ini" ]
	then
		echo -e "# Porta PostgreSQL" >> /etc/sysconfig/iptables
		echo -e "-A INPUT -p tcp -m tcp --dport 5432 -j ACCEPT" >> /etc/sysconfig/iptables
		echo -e "# Portas Callrouting" >> /etc/sysconfig/iptables
		for i in "${callroutingports[@]}"
		do :
			echo -e "-A INPUT -p tcp -m tcp --dport $i -j ACCEPT" >> /etc/sysconfig/iptables
		done
	fi
	echo -e "# Inicio da area para liberacao de portas personalizadas" >> /etc/sysconfig/iptables
	echo -e "# Fim da area para liberacao de portas personalizadas" >> /etc/sysconfig/iptables
	echo -e "# Conexao de retorno" >> /etc/sysconfig/iptables
	echo -e "-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables
	echo -e "-A OUTPUT -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables

	echo -e "COMMIT" >> /etc/sysconfig/iptables
	if [ $1 -eq 1 ]
	then
		echo -e "*nat" >> /etc/sysconfig/iptables
		echo -e ":PREROUTING ACCEPT [0:0]" >> /etc/sysconfig/iptables
		echo -e ":POSTROUTING ACCEPT [0:0]" >> /etc/sysconfig/iptables
		echo -e ":OUTPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
		echo -e "COMMIT" >> /etc/sysconfig/iptables
	fi
	/bin/systemctl restart iptables.service
	/bin/systemctl restart fail2ban.service
}
configfail2ban()
{
	while true; do
                read -p "Configurar FreePBX para Fail2Ban? " ff2b
                case $ff2b in
                        [SsYy]* ) configfreepbxf2b; break;;
                        [Nn]* ) echo -e "Pulando configuracao FreePBX"; break;;
                        * ) echo "RESPONDA sim ou nao.";;
                esac
        done

	rm -Rf /etc/fail2ban
	cp -Rf ./fail2ban /etc
	echo -e "# - Store banned IP in SQL db while it's banned." > /etc/fail2ban/action.d/banned_db.conf
	echo -e "# - Remove banned IP from SQL db while it's unbanned." >> /etc/fail2ban/action.d/banned_db.conf
	echo -e "" >> /etc/fail2ban/action.d/banned_db.conf
	echo -e "[Definition]" >> /etc/fail2ban/action.d/banned_db.conf
	echo -e "actionstart =" >> /etc/fail2ban/action.d/banned_db.conf
	echo -e "actioncheck =" >> /etc/fail2ban/action.d/banned_db.conf
	echo -e "" >> /etc/fail2ban/action.d/banned_db.conf
	echo -e "actionban   = /usr/local/bin/fail2ban_banned_db ban <ip> <port> <protocol> <name> <ipjailfailures> <ipjailmatches>" >> /etc/fail2ban/action.d/banned_db.conf
	echo -e "actionunban = /usr/local/bin/fail2ban_banned_db unban <ip>" >> /etc/fail2ban/action.d/banned_db.conf
	echo -e "actionstop  = /usr/local/bin/fail2ban_banned_db cleanup <name>" >> /etc/fail2ban/action.d/banned_db.conf
	cp ./adds/fail2ban_banned_db /usr/local/bin/
	chmod 0550 /usr/local/bin/fail2ban_banned_db
	/bin/systemctl restart fail2ban.service
	/bin/systemctl enable fail2ban.service
}
configiptables()
{
	httplistenport=$(grep 'Listen' /etc/httpd/conf/httpd.conf | grep -v '^#' | cut -d " " -f2)
	sshport=$(grep 'Port ' /etc/ssh/sshd_config | grep -v '^#' | cut -d " " -f2)
	sipport=$(grep 'udpbindaddr' /etc/asterisk/sip_general_additional.conf | grep -v '^#' | cut -d ":" -f2)
	rtpstart=$(grep 'rtpstart=' /etc/asterisk/rtp_additional.conf | grep -v '^#' | cut -d "=" -f2)
	rtpend=$(grep 'rtpend=' /etc/asterisk/rtp_additional.conf | grep -v '^#' | cut -d "=" -f2)
	pjsipports=$(grep 'bind=' /etc/asterisk/pjsip.transports.conf | grep -v '^#' | cut -d ":" -f2 | grep -v '^bind')
	if [ -f "/var/agecom/callroute/Callroute-pro.ini" ]
	then

		callroutingports=$(grep -i 'port =' /var/agecom/callroute/Callroute-pro.ini | grep -v '^Manager' | cut -d "=" -f2 | sed -e 's/^[[:space:]]*//')
	fi
	readarray -t callroutingports <<<"$callroutingports"

	#IFS='\n' read -r -a callroutingports <<< "$string"

	for i in "${pjsipports[@]}"
	do
		:
		if [ $i -eq 5060 ]
		then
			echo -e "${RED} Porta PJSIP padrao(5060),${NC} favor alterar"
		fi
	done
	if [ -z "$sshport" ]
	then
		sshport=22
		echo -e "${RED} Porta SSH padrao(22),${NC} favor alterar"
	fi

	while true; do
		read -p "Deseja ativar o compartilhamento de internet? " internetshare
		case $internetshare in
			[SsYy]* ) setdosasynprotection 1; break;;
			[Nn]* ) setdosasynprotection 0; break;;
			* ) echo "RESPONDA sim ou nao.";;
		esac
	done
	case $internetshare in
		[SsYy]* ) setiptablesfile 1; break;;
		[Nn]* ) setiptablesfile 0; break;;
	esac
}
RED='\033[0;31m'
NC='\033[0m' # No Color
clear;
echo -e "
############################################################
#                   Configurador Firewall                  #
#                                                          #
#                       By Alessandro                      #
############################################################
"
case "$1" in
	iptables)
		configiptables
		;;
	fail2ban)
		configfail2ban
		;;

	installdeps)
		installdeps
		;;
	monitor)
		installmonitor
		;;
	'')
		usage
		exit 0
		;;
	*)
		usage
		exit 1
		;;
esac

