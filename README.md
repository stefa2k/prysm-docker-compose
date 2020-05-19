# prysm-docker-compose
This docker-compose suite includes all parts to run and monitor a Prysm Ethereum 2.0 staking node. Please read this README in order to customize it to your needs.

![image](https://user-images.githubusercontent.com/54934211/82309544-907cec80-99c3-11ea-9c62-e3442a25b14f.png)

![image](https://user-images.githubusercontent.com/54934211/82309772-d5a11e80-99c3-11ea-831d-e485b48e920e.png)

![image](https://user-images.githubusercontent.com/54934211/82313615-e1431400-99c8-11ea-9e04-eb7f7eda3caf.png)
Credits to [prysm-grafana-dashboard](https://github.com/GuillaumeMiralles/prysm-grafana-dashboard) for providing the dashboards!

## Services
* beacon
* validator
* slasher (disabled by default)
* prometheus (disabled by default)
* grafana (disabled by default)

## Prepare your .env before running your node
Create a `.env` file in the same directory as your `docker-compose.yaml` with the following content:
```
IMAGE_VERSION_TAG=[prysm-version]
PUBLIC_IP=[your-public-ip4-address]
PUBLIC_HOST_DNS=
PUBLIC_TCP_PORT=13000
```

### prysm-version
This table gets updated every time a new release happens until prysm dev team adds a "stable" tag or something similar. https://github.com/prysmaticlabs/documentation/issues/103

Version | IMAGE_VERSION_TAG
--------|------------------
schlesi | schlesi
alpha.8 | HEAD-f831a7

### your-public-ip4-address
To gain a better connectivity for your beacon node you need to specifiy your public ip there and follow the guide [Improve Peer-to-Peer Connectivity](https://docs.prylabs.network/docs/prysm-usage/p2p-host-ip/).

## Validator accounts
Gain staking rewards by putting your validator account files in the directory `./validator`. See [Activating a Validator](https://docs.prylabs.network/docs/install/lin/activating-a-validator/) to guide you through the process of setting them up.

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

## Logging
Docker takes care of log files and log file rotation as well as limit (set to 10x100mb log files for each service).
View logs of a certain service (in this case beacon, only the last 100 lines)
```
docker-compose logs --tail=100 beacon
```

## Validator
Please read up on how to use the [validator](https://docs.prylabs.network/docs/how-prysm-works/prysm-validator-client/) and how to [activate the validator](https://docs.prylabs.network/docs/install/lin/activating-a-validator/).

Use the directory `./validator` as your datadir of the validator, put your desired password into `keystore.json`, the file is already prepared.

## Slasher
To enable the slasher delete the `slasher` service in `docker-compose.override.yaml`.

## Prometheus
To enable Prometheus delete the `prometheus` service in `docker-compose.override.yaml`.

Runs on localhost:9090, scrapes data of beacon, validator and slasher.

## Grafana
To enable Grafana delete the `grafana` service in `docker-compose.override.yaml`.

Grafana runs on localhost:3000 and uses the data provided by prometheus service.

Login with username `admin` and password `admin` (Grafana defaults), data source to Prometheus is already established. I recommend using https://github.com/GuillaumeMiralles/prysm-grafana-dashboard.
