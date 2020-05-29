#!/bin/bash

BEACON_CONTRACT="0x5ca1e00004366ac85f492887aaab12d0e6418876"

VALIDATORS=98



LASTVALIDATOR=$(($VALIDATORS-1))

for i in $(seq 0 $LASTVALIDATOR); do
	docker-compose -f create-account.yaml run validator-create-account > /tmp/validatorcreateoutput
	RAWTXDATA=$(sed -n 9,1p /tmp/validatorcreateoutput | tr -d '\r')
	# echo $RAWTXDATA
	SEND_CMD="web3.eth.sendTransaction({ from: web3.eth.coinbase, to: '$BEACON_CONTRACT', value: web3.toWei(32, 'ether'), data: '${RAWTXDATA}' })"
	# echo "$SEND_CMD"
	eval "docker exec -it geth geth attach http://localhost:8545/ --exec=\"$SEND_CMD\""
	echo "sent successful, $seq"
done

rm /tmp/validatorcreateoutput
