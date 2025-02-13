# Jade City Token

## Prerequisites

Before deploying the token, ensure you have:
- Installed [Foundry](https://getfoundry.sh/)
- An Ethereum RPC provider (e.g., Alchemy, Infura)
- Your private key available for deployment

## Step 1: Set Up Environment Variables

### Add Ethereum RPC Node
Use a provider like Alchemy or Infura to obtain an RPC URL.
```sh
export ETH_RPC_URL="https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID"
```

### Add Keys for Deployment
```sh
export PRIVATE_KEY="YOUR_PRIVATE_KEY"
export ETHERSCAN_API_KEY="YOUR_ETHERSCAN_API_KEY"
export RECEIVER_ADDRESS="YOUR_TOKEN_RECEIVER_ADDRESS"
```

## Step 2: Deploy the Contract
Run the following command to deploy the contract using Foundry:
```sh
forge script script/DeployJadeCity.s.sol --rpc-url $ETH_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

## Step 3: Verify the Contract on Etherscan
Use the following command to verify the contract on Etherscan. Change DEPLOYED_TOKEN_ADDRESS variable to your current token address.
```sh
forge verify-contract \
--chain 1 \
--etherscan-api-key $ETHERSCAN_API_KEY \
--constructor-args $(cast abi-encode "constructor(address)" $RECEIVER_ADDRESS) \
--watch \
<DEPLOYED_TOKEN_ADDRESS> \
src/JadeCity.sol:JadeCity
```

### Build

```shell
$ forge build
```

### Test
Add RECEIVER_ADDRESS variable for tesing deployment script

```shell
export RECEIVER_ADDRESS="YOUR_TOKEN_RECEIVER_ADDRESS"
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```
