

function createcitiBank {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/citiBank.kyc.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/citiBank.kyc.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-citiBank --tls.certfiles ${PWD}/organizations/fabric-ca/citiBank/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-citiBank.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-citiBank.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-citiBank.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-citiBank.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-citiBank --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/citiBank/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-citiBank --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/citiBank/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-citiBank --id.name citiBankadmin --id.secret citiBankadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/citiBank/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/citiBank.kyc.com/peers
  mkdir -p organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-citiBank -M ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/msp --csr.hosts peer0.citiBank.kyc.com --tls.certfiles ${PWD}/organizations/fabric-ca/citiBank/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-citiBank -M ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls --enrollment.profile tls --csr.hosts peer0.citiBank.kyc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/citiBank/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/tlsca/tlsca.citiBank.kyc.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/ca
  cp ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/peers/peer0.citiBank.kyc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/ca/ca.citiBank.kyc.com-cert.pem

  mkdir -p organizations/peerOrganizations/citiBank.kyc.com/users
  mkdir -p organizations/peerOrganizations/citiBank.kyc.com/users/User1@citiBank.kyc.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-citiBank -M ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/users/User1@citiBank.kyc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/citiBank/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/citiBank.kyc.com/users/Admin@citiBank.kyc.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://citiBankadmin:citiBankadminpw@localhost:7054 --caname ca-citiBank -M ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/users/Admin@citiBank.kyc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/citiBank/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/citiBank.kyc.com/users/Admin@citiBank.kyc.com/msp/config.yaml

}


function createsbi {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/sbi.kyc.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/sbi.kyc.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-sbi --tls.certfiles ${PWD}/organizations/fabric-ca/sbi/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-sbi.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-sbi.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-sbi.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-sbi.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/sbi.kyc.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-sbi --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/sbi/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-sbi --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/sbi/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-sbi --id.name sbiadmin --id.secret sbiadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/sbi/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/sbi.kyc.com/peers
  mkdir -p organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-sbi -M ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/msp --csr.hosts peer0.sbi.kyc.com --tls.certfiles ${PWD}/organizations/fabric-ca/sbi/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/sbi.kyc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-sbi -M ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls --enrollment.profile tls --csr.hosts peer0.sbi.kyc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/sbi/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/sbi.kyc.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sbi.kyc.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/sbi.kyc.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sbi.kyc.com/tlsca/tlsca.sbi.kyc.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/sbi.kyc.com/ca
  cp ${PWD}/organizations/peerOrganizations/sbi.kyc.com/peers/peer0.sbi.kyc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/sbi.kyc.com/ca/ca.sbi.kyc.com-cert.pem

  mkdir -p organizations/peerOrganizations/sbi.kyc.com/users
  mkdir -p organizations/peerOrganizations/sbi.kyc.com/users/User1@sbi.kyc.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-sbi -M ${PWD}/organizations/peerOrganizations/sbi.kyc.com/users/User1@sbi.kyc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sbi/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/sbi.kyc.com/users/Admin@sbi.kyc.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://sbiadmin:sbiadminpw@localhost:8054 --caname ca-sbi -M ${PWD}/organizations/peerOrganizations/sbi.kyc.com/users/Admin@sbi.kyc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sbi/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/sbi.kyc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sbi.kyc.com/users/Admin@sbi.kyc.com/msp/config.yaml

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/kyc.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/kyc.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/kyc.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/kyc.com/orderers
  mkdir -p organizations/ordererOrganizations/kyc.com/orderers/kyc.com

  mkdir -p organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/msp --csr.hosts orderer.kyc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/kyc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/tls --enrollment.profile tls --csr.hosts orderer.kyc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/msp/tlscacerts/tlsca.kyc.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/kyc.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/kyc.com/orderers/orderer.kyc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/kyc.com/msp/tlscacerts/tlsca.kyc.com-cert.pem

  mkdir -p organizations/ordererOrganizations/kyc.com/users
  mkdir -p organizations/ordererOrganizations/kyc.com/users/Admin@kyc.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/kyc.com/users/Admin@kyc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/kyc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/kyc.com/users/Admin@kyc.com/msp/config.yaml


}
