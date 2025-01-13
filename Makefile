-include .env

.PHONY: build test install deploy anvil

build :; forge build

test :; forge test

install :; forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit

deploy-anvil :; forge script script/DeployDao.s.sol:DeployDao --rpc-url http://localhost:8545 --account anvilKey --broadcast -vvvv