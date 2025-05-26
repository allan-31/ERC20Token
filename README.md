# OurToken (OT)

A simple ERC20 token built with [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts) and deployed using [Foundry](https://book.getfoundry.sh/).

## Overview

**OurToken (OT)** is a demonstration project showcasing the basic implementation of an ERC20 token. It uses OpenZeppelin’s battle-tested library and leverages Foundry for development, scripting, and testing.

* Built with Solidity `^0.8.2`
* Powered by OpenZeppelin ERC20
* Tested and deployed with Foundry

## Quick Start

### 1. Install Dependencies

```bash
make install
```

### 2. Remove Installed Modules (if needed)

```bash
make remove
```

### 3. Compile Contracts

```bash
forge build
```

### 4. Deploy Contracts

#### Local (Anvil)

Start Anvil locally:

```bash
anvil
```

Then deploy:

```bash
make deploy-anvil
```

#### Sepolia Testnet

Ensure your `.env` file contains:

```env
SEPOLIA_URL
```

Also make sure you've set up a Foundry account alias named `myaccount2`.

Then deploy:

```bash
make deploy-sepolia
```

### 5. Run Tests

```bash
forge test
```

### 6. Take a Snapshot (Gas Report)

```bash
make snapshot
```

### 7. Run Coverage Report

```bash
make coverage
```

## Contract Details

* **Name**: Our Token
* **Symbol**: OT
* **Decimals**: 18 (default)
* **Initial Supply**: Passed as constructor argument and minted to the deployer (`msg.sender`)

## 🧪 Testing

To write or run tests, add test files in the `test/` directory using Foundry's test framework.

Run tests:

```bash
forge test
```

## 👤 Author

**Arinaitwe Allan**
Solidity Developer
ermlabs.d@gmail.com
📅 Building since 2023

