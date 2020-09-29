#!/bin/bash

echo "---------安装postfix dovecot邮件服务---------"
yum -y install postfix dovecot
sleep 1s
postconf -e 'myhostname = server.yutan.me'
postconf -e 'mydestination = localhost, localhost.localdomain'
postconf -e 'myorigin = $mydomain'
postconf -e 'mynetworks = 127.0.0.0/8'
postconf -e 'inet_interfaces = all'
postconf -e 'inet_protocols = all'
postconf -e 'mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain'
postconf -e 'home_mailbox = Maildir/'
postconf -e 'smtpd_sasl_type = dovecot'
postconf -e 'smtpd_sasl_path = private/auth'
postconf -e 'smtpd_sasl_auth_enable = yes'
postconf -e 'broken_sasl_auth_clients = yes'
postconf -e 'smtpd_sasl_authenticated_header = yes'
postconf -e 'smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination'
postconf -e 'smtpd_use_tls = yes'
postconf -e 'smtpd_tls_cert_file = /etc/pki/dovecot/certs/dovecot.pem'
postconf -e 'smtpd_tls_key_file = /etc/pki/dovecot/private/dovecot.pem'
sleep 1s
sed -i "s/#smtps/smtps/g" /etc/postfix/master.cf
sed -i "s/#  -o smtpd_tls_wrappermode=yes/   -o smtpd_tls_wrappermode=yes/g" /etc/postfix/master.cf
sleep 1s
systemctl enable postfix.service
systemctl start  postfix.service
sleep 1s
echo "配置Dovecot"
echo "修改dovecot.conf"
sed -i '$assl_cert = </etc/pki/dovecot/certs/dovecot.pem' /etc/dovecot/dovecot.conf
sed -i '$assl_key = </etc/pki/dovecot/private/dovecot.pem\n' /etc/dovecot/dovecot.conf
sed -i '$aprotocols = imap pop3 lmtp' /etc/dovecot/dovecot.conf
sed -i '$alisten = *' /etc/dovecot/dovecot.conf
sed -i '$amail_location = Maildir:~/Maildir' /etc/dovecot/dovecot.conf
sed -i '$adisable_plaintext_auth = no' /etc/dovecot/dovecot.conf
echo "修改 10-master.conf"
sed -i '96c unix_listener /var/spool/postfix/private/auth {' /etc/dovecot/conf.d/10-master.conf
sed -i '97c mode = 0666' /etc/dovecot/conf.d/10-master.conf
sed -i '98c }' /etc/dovecot/conf.d/10-master.conf
systemctl enable dovecot.service
systemctl start  dovecot.service
useradd lvcfm
passwd lvcfm
echo "输入密码以后，将下列代码复制执行一次"
echo 'echo "Mail Content" | mail -s "Mail Subject" lvcfm_520@163.com'
su lvcfm