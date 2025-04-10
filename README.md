# Crowd Funding DApp Smart Contract

This repository contains a Solidity-based crowdfunding platform consisting of two main smart contracts:

1. **crowdFunding**: A smart contract that allows users to create campaigns, fund campaigns by contributing to tiers, and withdraw funds if the campaign is successful.
2. **crowdFundingContract**: A factory contract for creating and managing multiple crowdfunding campaigns.

This project is built using Solidity and deployed on a local Ethereum development environment using **Ganache**. MetaMask is used as the wallet for interacting with the contracts.

## Table of Contents

- [Contracts Overview](#contracts-overview)
- [Installation](#installation)
- [Deployment](#deployment)
- [Interacting with the Smart Contracts](#interacting-with-the-smart-contracts)
- [License](#license)

## Contracts Overview

1. **crowdFunding Contract**

    This contract allows users to create crowdfunding campaigns with the following features:

    - **Create a campaign**: A user can create a campaign with a name, description, goal amount, and deadline.
    - **Contribute to tiers**: A campaign owner can define multiple funding tiers, each with a specified amount. Backers can fund campaigns by contributing to one of the available tiers.
    - **Withdraw funds**: If a campaign reaches its goal by the deadline, the owner can withdraw the funds.
    - **Refund**: If the campaign fails (goal amount not reached by the deadline), backers can claim refunds.
<br>

2. **crowdFundingContract (Factory Contract)**

    The factory contract allows users to create and manage multiple crowdfunding campaigns. It supports the following:

    - **Create campaigns**: Users can create new campaigns via the factory contract, which then deploys the crowdFunding contract.
    - **View campaigns**: Users can view the campaigns they have created or all available campaigns.
    - **Pause/unpause contract**: The owner of the factory contract can pause or unpause the contract.

## Installation

To get started, clone this repository and install the necessary dependencies.

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Srinidhi-Yoganand/crowdFundingSmartContract.git
   cd crowdFundingSmartContract
   ```
   
2. **Install dependencies**:
  Make sure you have **Truffle** installed. If not, you can install them via the following commands:

    ```bash 
    npm install -g truffle
    ```

3. **Start Ganache**:
    - Open Ganache (either the desktop application or Ganache CLI).
    - Create a new workspace or use an existing workspace.
    - Ensure the network is running on port 8545 (default).

    ```bash
    ganache-cli -p 8545
    ```

4. **Configure MetaMask**:
    - Open MetaMask and configure it to connect to Ganache by adding a custom RPC network.
    - Use the following configuration:
      - Network Name: Ganache
      - RPC URL: http://127.0.0.1:8545
      - Chain ID: 1337
      - Currency Symbol: ETH
    - To send money to a wallet, you can use the following `curl` command, replacing the `from`, `to`, and `value` with your specific details:

      ```bash
      curl -X POST --data 
      '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"<GANACHE_ADDRESS>","to":"<METAMASK_ADDRESS>","value":"<YOUR_AMOUNT_IN_HEX>"}],"id":1}' 
      http://127.0.0.1:8545
      ```

## Deployment

1. **Compile the contracts**:
    Before deploying, compile the Solidity contracts using Truffle:

    ```bash
    truffle compile
    ```

2. **Deploy the contracts**:
    Once the contracts are compiled, deploy them to the Ganache network:
    ```bash
    truffle migrate --network development
    ```
    This will deploy both the crowdFundingContract (factory) and the crowdFunding contracts to the local Ganache network.
  
3. **Verify deployment**:
    After deployment, Truffle will display the deployed contract addresses. You can use these addresses to interact with the contracts via MetaMask or through Truffle's console.
  
## Interacting with the Smart Contracts

  After deploying the contracts, you will be able to interact with them via our frontend DApp. 

  ### Crowd Funding DApp Frontend (Coming Soon)
  Please refer to the upcoming frontend repository to clone and run the DApp once it’s ready. The repository link and steps will be provided here.
  Stay tuned for further updates!

## License
  This project is licensed under the MIT License 