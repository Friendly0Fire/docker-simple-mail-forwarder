DOCKER_IMAGE_NAME="simple-postfix"
DOCKER_CONTAINER_NAME="postfix"

# This should be set to whatever your mailserver domain is (i.e. the domain pointed to by your MX entry)
DOCKER_HOSTNAME="mail.example.com"

# This should be set to a host-side (i.e. not within the container) file containing a sequence of private keys and certificates, c.f. http://www.postfix.org/postconf.5.html#smtpd_tls_chain_files @ /etc/postfix/chains.pem
DOCKER_CERT_FILES="/some/local/privkey.pem;/some/local/cert.pem"