#!/bin/bash

# Topaz
# BEACON_CONTRACT="0x5ca1e00004366ac85f492887aaab12d0e6418876"

# Witti
BEACON_CONTRACT="0x42cc0FcEB02015F145105Cf6f19F90e9BEa76558"

VALIDATORS=2



LASTVALIDATOR=$(($VALIDATORS-1))

for i in $(seq 0 $LASTVALIDATOR); do
	docker-compose -f create-account.yaml run validator-create-account > /tmp/validatorcreateoutput
	RAWTXDATA=$(sed -n 10,1p /tmp/validatorcreateoutput | tr -d '\r')
	#echo $RAWTXDATA
	SEND_CMD="web3.eth.sendTransaction({ from: web3.eth.coinbase, to: '$BEACON_CONTRACT', value: web3.toWei(32, 'ether'), data: '${RAWTXDATA}' })"
	#echo "$SEND_CMD"
	eval "docker exec -it geth geth attach http://localhost:8545/ --exec=\"$SEND_CMD\""
	echo "sent successful"
done

#rm /tmp/validatorcreateoutput
