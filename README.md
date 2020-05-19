# prysm-docker-compose
This docker-compose suite includes all parts to run and monitor a Prysm Ethereum 2.0 staking node. Please read this README in order to customize it to your needs.

![image](https://user-images.githubusercontent.com/54934211/82322232-77ca0200-99d6-11ea-80cb-622da470768a.png)

![image](https://user-images.githubusercontent.com/54934211/82309772-d5a11e80-99c3-11ea-831d-e485b48e920e.png)

![image](https://user-images.githubusercontent.com/54934211/82322339-a3e58300-99d6-11ea-8962-7795c46ed778.png)

![image](https://user-images.githubusercontent.com/54934211/82313615-e1431400-99c8-11ea-9e04-eb7f7eda3caf.png)
Credits to [prysm-grafana-dashboard](https://github.com/GuillaumeMiralles/prysm-grafana-dashboard) for providing the dashboards!

## Services
* beacon
* validator
* slasher
* prometheus
* grafana

**All services are enabled by default.** In case you want to only run beacon & validator move the `compose-examples/docker-compose.override.yml_beacon_validator` file in the same folder as your `docker-compose.yaml` and rename it to `docker-compose.override.yml`. Read up on [docker-compose files & override](https://docs.docker.com/compose/extends/#multiple-compose-files) to customize your setup.

## (optional) Prepare your .env before running your node
Edit `.env` file to set different options for the node:
```
IMAGE_VERSION_TAG=[prysm-version]
PUBLIC_IP=[your-public-ip4-address]
PUBLIC_HOST_DNS=[your-public-host-dns]
PUBLIC_TCP_PORT=13000
```

### prysm-version
This table gets updated every time a new release happens until prysm dev team adds a "stable" tag or something similar. https://github.com/prysmaticlabs/documentation/issues/103

Version | IMAGE_VERSION_TAG
--------|------------------
schlesi | schlesi
alpha.8 | HEAD-f831a7

### your-public-ip4-address & your-public-host-dns
To gain a better connectivity for your beacon node you need to specifiy your public ip and/or your dns name there and follow the guide [Improve Peer-to-Peer Connectivity](https://docs.prylabs.network/docs/prysm-usage/p2p-host-ip/).

## Validator accounts
Please read up on how to use the [validator](https://docs.prylabs.network/docs/how-prysm-works/prysm-validator-client/) to stake funds and how to [activate the validator](https://docs.prylabs.network/docs/install/lin/activating-a-validator/). These are only short steps to make it work fast:

1. Put your desired password into `./validator/keystore.json`.
2. Run `docker-compose -f create-account.yaml run validator-create-account` and use the **same password**.
3. Use the `Raw Transaction Data` of the output at https://prylabs.net/participate to send GöETH to the smart contract.
4. Run at least the `beacon` and the `validator` (see chapter below) and wait until the deposit is complete and your node is active.

You can repeat step 2 & 3 as often as you like, make sure to restart your validator to make it notice your new accounts!

## Run your prysm Ethereum 2.0 staking node

### Start it up
Run with (as deamon with "-d")
```
docker-compose up -d
```
or run only certain services (in this case only beacon and validator)
```
docker-compose up -d beacon validator
```

### Stop it
Stop services (or everything) like this
```
docker-compose stop validator slasher
```

### Shut it down for good
Shut down your services (or everything) like this:
```
docker-compose down
```
Please note: This will also erase your logs, they are stored with your containers and will be deleted as well.

## Monitoring
### Logging
Docker takes care of log files and log file rotation as well as limit (set to 10x100mb log files for each service).
View logs of a certain service (in this case beacon, only the last 100 lines)
```
docker-compose logs --tail=100 beacon
```

### Prometheus
To enable Prometheus delete the `prometheus` service in `docker-compose.override.yaml`.

Runs on localhost:9090, scrapes data of beacon, validator and slasher.

### Grafana
To enable Grafana delete the `grafana` service in `docker-compose.override.yaml`.

Grafana runs on localhost:3000 and uses the data provided by prometheus service.

Login with username `admin` and password `admin` (Grafana defaults), data source to Prometheus is already established. I recommend using https://github.com/GuillaumeMiralles/prysm-grafana-dashboard.
