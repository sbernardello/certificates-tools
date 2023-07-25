#!/usr/bin/env bash

set -e

CERTIFICATE_PATH=certificates

if [ ! -d $CERTIFICATE_PATH ]; then
    echo "Creating local folder to save certificates [$CERTIFICATE_PATH]"
    mkdir $CERTIFICATE_PATH
fi

source utils.sh

if [[ -z "$1" ]]; then
    print_error "You need to select the domain to test."
    exit 1
fi

DOMAIN_TO_TEST="$1"
OCSP_URL=""

print_green "Get the server certificate -> [$CERTIFICATE_PATH/$DOMAIN_TO_TEST-certificate.pem]"
openssl s_client -connect "$DOMAIN_TO_TEST:443"  < /dev/null 2>&1 |  sed -n '/-----BEGIN/,/-----END/p' > "$CERTIFICATE_PATH/$DOMAIN_TO_TEST-certificate.pem"

print_green "Get the server intermediate certificate -> [$DOMAIN_TO_TEST-chain.pem]"
openssl s_client -showcerts -connect "$DOMAIN_TO_TEST:443" < /dev/null 2>&1 |  sed -n '/-----BEGIN/,/-----END/p' > "$CERTIFICATE_PATH/$DOMAIN_TO_TEST-chain.pem"

print_green "Get the OCSP Url from certificate..."
OCSP_URL=$(openssl x509 -noout -ocsp_uri -in "$CERTIFICATE_PATH/$DOMAIN_TO_TEST-certificate.pem")

print_green "OCSP URL: $OCSP_URL"

openssl x509 -text -noout -in "$CERTIFICATE_PATH/$DOMAIN_TO_TEST-certificate.pem"

print_green "Certificate expiration:"
openssl x509 -noout -enddate -in "$CERTIFICATE_PATH/$DOMAIN_TO_TEST-certificate.pem"

print_highlight "Checking OCSP for [$DOMAIN_TO_TEST] to [$OCSP_URL]"

openssl s_client -connect $DOMAIN_TO_TEST:443 -tls1_2 -tlsextdebug -status < /dev/null 2>&1

#openssl ocsp -issuer "$DOMAIN_TO_TEST-chain.pem" -cert "$DOMAIN_TO_TEST-certificate.pem" -url "$OCSP_URL"
#openssl ocsp -issuer "$DOMAIN_TO_TEST-chain.pem" -cert "$DOMAIN_TO_TEST-certificate.pem" -text -url "$OCSP_URL"
#openssl ocsp -issuer "wildcard-tribridge-eu-bundle.pem" -cert wildcard-tribridge-eu.pem -text -url http://ocsp.godaddy.com/
