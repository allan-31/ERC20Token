-include .env

.PHONY: install remove deploy-anvil

install:; forge install OpenZeppelin/openzeppelin-contracts --no-commit

remove:; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

deploy-anvil:; forge script script/DeployOurToken.s.sol:DeployOurToken --rpc-url $(ANVIL_URL) --account anvilaccount --broadcast

deploy-sepolia:; forge script script/DeployOurToken.s.sol:DeployOurToken --rpc-url $(SEPOLIA_URL) --account myaccount2 --broadcast

snapshot:; forge snapshot

coverage:; forge coverage