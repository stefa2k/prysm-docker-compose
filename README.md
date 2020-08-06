# prysm-docker-compose
This docker-compose suite includes all parts to run and monitor a Prysm Ethereum 2.0 staking node. Please read this README in order to customize it to your needs.

![image](https://user-images.githubusercontent.com/54934211/82576760-5ad63000-9b8a-11ea-9089-c6a60a692fb1.png)

![image](https://user-images.githubusercontent.com/54934211/82309772-d5a11e80-99c3-11ea-831d-e485b48e920e.png)

![image](https://user-images.githubusercontent.com/54934211/82322339-a3e58300-99d6-11ea-8962-7795c46ed778.png)

![image](https://user-images.githubusercontent.com/54934211/82313615-e1431400-99c8-11ea-9e04-eb7f7eda3caf.png)
Credits to [prysm-grafana-dashboard](https://github.com/GuillaumeMiralles/prysm-grafana-dashboard) for providing the dashboards!

![image](https://user-images.githubusercontent.com/54934211/84988542-7a895580-b142-11ea-8e25-d9c8a5499521.png)
Using [docker-elk](https://github.com/stefa2k/docker-elk)

## Services
* geth (beacon conntects to it to see deposits for validators)
* beacon
* validator
* slasher
* prometheus
* grafana

**All services are enabled by default.**

### Minimal Setup (beacon & validator only)
In case you want to run only beacon & validator (geth, slasher, prometheus, grafana get disabled) move the `compose-examples/docker-compose.beacon-validator.override.yaml` file in the same folder as your `docker-compose.yaml` and rename it to `docker-compose.override.yaml`. Read up on [docker-compose files & override](https://docs.docker.com/compose/extends/#multiple-compose-files) to customize your setup further.

## (optional) Configure your node

### Public ip & other Prysm parameters/arguments
Configuration files are located in the folder `./config`. To gain a better connectivity for your beacon node you should specifiy your public ip and/or your dns name in `./config/beacon.yaml`. Follow the guide [Improve Peer-to-Peer Connectivity](https://docs.prylabs.network/docs/prysm-usage/p2p-host-ip/).

## Validator accounts with launchpad
Please complete the steps on [launchpad](https://medalla.launchpad.ethereum.org/) and store the generated files of `~/eth2.0-deposit-cli/validator_keys` in `./launchpad/eth2.0-deposit-cli/validator_keys`. The necessary directories need to be created. Please create the directories `./validator/wallets` and put your wallet password in `./validator/passwords/wallet-password`.

1. Generate your validator(s) using [launchpad](https://medalla.launchpad.ethereum.org/) and complete the process
2. Copy your generated validator(s) from `~/eth2.0-deposit-cli/validator_keys` to `./launchpad/eth2.0-deposit-cli/validator_keys`
2. Run `docker-compose -f create-account.yaml run validator-import-launchpad` and use the **same password** as in the generation of the validator(s)

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
Runs on http://localhost:9090, scrapes data of beacon, validator and slasher.

### Grafana
Grafana listens on http://localhost:3000 and uses the data provided by prometheus service.

Login with username `admin` and password `admin` (Grafana defaults), data source to Prometheus is already established and dashboards installed.

### ELK
To aggregate and display logs with [ELK-Stack](https://www.elastic.co/what-is/elk-stack) use [docker-elk](https://github.com/stefa2k/docker-elk) and easy cluster/standalone setup with [ansible-elk](https://github.com/stefa2k/ansible-elk).

## FAQ
### My `docker-compose` command doesn't work (e. g. `ERROR: Version in "./docker-compose.yaml" is unsupported.`)
Most linux distributions (including Ubuntu) don't serve recent docker-compose versions in their package management. You can install a compatible version by following [official docker.io documentation](https://docs.docker.com/compose/install/).

### I keep missing attestations or keep getting warnings/errors about `roughtime`
E. g. error messages like this:
```
WARN roughtime: Roughtime reports your clock is off by more than 2 seconds offset=4h0m0.345549475s
```
Make sure the OS' clock is synced. For Windows 10 and its subsystem linux might run on different times, to check this run `wsl` and then `date` (may differ by the OS you have installed).

Ask google on how to get your OS' time synced again.

## Support the maintainer
This software is provided under MIT license and therefore freely usable without restrictions. Dontations are always welcome:

ETH - 0xA1DDc7ed6E7b9179C68cDEE24a5e47dE930061eE

BTC - 39n4LUxbcCfJvBGvFVVwQQkGxSJ44JRYV7
