#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

ORG="citiBank"
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/citiBank.kyc.com/tlsca/tlsca.citiBank.kyc.com-cert.pem
CAPEM=organizations/peerOrganizations/citiBank.kyc.com/ca/ca.citiBank.kyc.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/citiBank.kyc.com/connection-citiBank.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/citiBank.kyc.com/connection-citiBank.yaml

ORG="sbi"
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/sbi.kyc.com/tlsca/tlsca.sbi.kyc.com-cert.pem
CAPEM=organizations/peerOrganizations/sbi.kyc.com/ca/ca.sbi.kyc.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sbi.kyc.com/connection-sbi.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sbi.kyc.com/connection-sbi.yaml
