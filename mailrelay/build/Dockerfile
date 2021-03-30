FROM debian:buster-slim
MAINTAINER fire fire@fire7.ru
RUN \
  apt-get -y update && \
apt-get -y upgrade && \
  apt-get -y --no-install-recommends install \
    procps \
    postfix \
    libsasl2-modules \
    opendkim \
    opendkim-tools \
    rsyslog && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
# Default config:
# Open relay, trust docker links for firewalling.
# Try to use TLS when sending to other smtp servers.
# No TLS for connecting clients, trust docker network to be safe
ENV \
  POSTFIX_smtpd_banner='$myhostname ESMTP' \
  POSTFIX_myhostname=mx.example.com \
  POSTFIX_mydestination=localhost \
  POSTFIX_relay_domains="example.com example1.com example2.com" \
  POSTFIX_relay_transport=hash:/etc/postfix/transport \
  POSTFIX_transport_maps=hash:/etc/postfix/transport \
  POSTFIX_smtpd_relay_restrictions='permit_mynetworks permit_sasl_authenticated defer_unauth_destination' \
  POSTFIX_smtpd_recipient_restrictions='permit_mynetworks,reject_unauth_destination,reject_invalid_hostname,reject_unauth_pipelining,reject_non_fqdn_sender,reject_unknown_recipient_domain,reject_unknown_sender_domain' \
  POSTFIX_mynetworks='127.0.0.0/8 192.168.0/24' \
  POSTFIX_mailbox_size_limit=1048576000 \
  POSTFIX_virtual_mailbox_limit=1048576000 \
  POSTFIX_compatibility_level=2 \
  POSTFIX_smtp_tls_security_level=may \
  POSTFIX_smtpd_tls_loglevel=1 \
  POSTFIX_smtp_use_tls=yes \
# Disable SSLv2/3 as they are vulnerable
  POSTFIX_smtpd_tls_protocols='!SSLv2, !SSLv3' \ 
  POSTFIX_smtp_tls_protocols='!SSLv2, !SSLv3' \
# Insist on stronger ciphers
  POSTFIX_smtpd_tls_ciphers=high \
  POSTFIX_smtp_tls_ciphers=high \
# keys
  POSTFIX_smtp_tls_cert_file=/etc/letsencrypt/live/example.com/fullchain.pem \
  POSTFIX_smtp_tls_key_file=/etc/letsencrypt/live/example.com/privkey.pem \
  POSTFIX_smtpd_tls_cert_file=/etc/letsencrypt/live/example.com/fullchain.pem \
  POSTFIX_smtpd_tls_key_file=/etc/letsencrypt/live/example.com/privkey.pem
#  POSTFIX_smtpd_tls_security_level=none
COPY rsyslog.conf /etc/rsyslog.conf
COPY opendkim.conf /etc/opendkim.conf
RUN mkdir -p /etc/opendkim/keys
COPY run /root/
VOLUME ["/var/lib/postfix", "/var/mail", "/var/spool/postfix", "/etc/opendkim/keys"]
EXPOSE 25/tcp
CMD ["/root/run"]