# Chainlink-falls-hackathon-smart-contract

Smart Contracts built with Hardhat for OpenMarket Project on Chainlink Falls Hackathon.

[Live Demo Hosted in Fleek](https://open-market-chainlink-falls-hackathon.on.fleek.co/#/)

**Note:** Be sure to use Polygon Mumbai Network.

OpenMarket is a marketplace where you can create chat to ask private questions before you want to buy a product. Also as a seller you can make sure that the buyer have the number.

With Chainlink datafeeds the price of the product could be in Matic or USD. Also, in order to make the most secure way to sell products, we create a random number with VRF and it is given to the buyer after deposit the money. And the seller needs this number to witdraw the money and transfer the nft.


## Important Links

[SmartContracts Repo](https://github.com/leopacheco18/chainlink-falls-hackathon-smart-contract)


[NodeJs Backend Repo](https://github.com/leopacheco18/chainlink-falls-hackathon-backend)


[Events Repo](https://github.com/leopacheco18/chainlink-falls-hackathon-events)


## Requirements

* NodeJs >= 16.17.0

## How to run

**IMPORTANT:** For live testing be use to use Mumbai Network.

1. Clone the repository.

`git clone https://github.com/leopacheco18/chainlink-falls-hackathon-smart-contract`


2. Enter to the folder.

`cd chainlink-falls-hackathon-smart-contract`


3. Install dependencies

`npm install`

You are all set.

### Testing on a live network

Open the `.env.example` file and replace the keys for your own, you must provide a wallet Private key.

**IMPORTANT NOTE**

Do not use your wallet private key without knowing the risks, is 100% recommended to use a wallet without real assets for testing and velopment porpuses
