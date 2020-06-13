#!/bin/bash

# BEACON_CONTRACT="0x5ca1e00004366ac85f492887aaab12d0e6418876" # Topaz testnet
BEACON_CONTRACT="0x0F0F0fc0530007361933EaB5DB97d09aCDD6C1c8" # Onyx testnet

VALIDATORS=98    # Number of validators to create
GAS_LIMIT=400000 # Max gas for funding transactions


for ((i=1; i<=$VALIDATORS; i++)) do
	docker-compose -f create-account.yaml run validator-create-account > /tmp/validatorcreateoutput
	RAWTXDATA=$(sed -n 8,1p /tmp/validatorcreateoutput | tr -d '\r')
	# echo $RAWTXDATA
	SEND_CMD="web3.eth.sendTransaction({ from: web3.eth.coinbase, to: '$BEACON_CONTRACT', value: web3.toWei(32, 'ether'), data: '${RAWTXDATA}', gas: $GAS_LIMIT })"
	# echo "$SEND_CMD"
	eval "docker exec -it geth geth attach http://localhost:8545/ --exec=\"$SEND_CMD\""
	echo "sent successful, $i"
done

rm /tmp/validatorcreateoutput
