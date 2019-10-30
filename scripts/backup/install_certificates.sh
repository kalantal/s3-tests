#!/bin/bash

sudo cp Citi_DEVELOPMENT_chain.pem /etc/pki/ca-trust/source/
sudo cp CitiInternalCAChain_LAB.pem /etc/pki/ca-trust/source/
sudo cp CitiInternalCAChain_UAT.pem /etc/pki/ca-trust/source/
sudo cp CitiInternalCAChain_PROD.pem /etc/pki/ca-trust/source/

#sudo cp *.pem /etc/pki/ca-trust/source/

cd /etc/pki/ca-trust/source/ || exit
sudo update-ca-trust extract
