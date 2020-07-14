#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/msp/tlscacerts/tlsca.kyc.com-cert.pem
export PEER0_CitiBank_CA=${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls/ca.crt
export PEER0_Sbi_CA=${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.kyc.com/peers/peer0.org3.kyc.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/msp/tlscacerts/tlsca.kyc.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/kyc.com/users/Admin@kyc.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  echo "Using organization ${USING_ORG}"
  if [ "$USING_ORG" = "citiBank" -o $USING_ORG = 1 ]; then

    export CORE_PEER_LOCALMSPID="CitiBankMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CitiBank_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/citiBank.kyc.com/users/Admin@citiBank.kyc.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ "$USING_ORG" = "sbi" -o $USING_ORG = 2 ]; then
    export CORE_PEER_LOCALMSPID="SbiMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_Sbi_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/sbi.kyc.com/users/Admin@sbi.kyc.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.kyc.com/users/Admin@org3.kyc.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.citiBank"
    ## Set peer adresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_CitiBank_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}
