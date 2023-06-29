# nUSD-stableCoin

It's a Stable Coin named nUSD. It is backed by ETH (similar to DAI). Here users can deposit ETH and receive 50% of its value in nUSD. Additionally, there is a redeem function to convert nUSD back into either ETH.
 
![Screenshot from 2023-06-29 11-26-55](https://github.com/Parthib314/nUSD-stablecoin/assets/94271200/107721eb-b26d-4a45-b454-1e4a2f2fcf6f)

## For the frontend 
After cloning the repo 
### To Run
```
cd nusd_frontend
yarn
yarn dev
```
### For build
```
yarn build
```
## For Backend

There are three contracts 
 - Covertor: The converting the price of ETH to USD
 - StableCoin: The main ERC20 token
 - nUSDEngine: This is the contract to deposit and redeem the token in exchange for ETH.

All the contracts are deployed on the Sepolia TestNet

## To compile 
```
yarn hardhat compile
```

## To deploy the contracts
```
yarn hardhat deploy --network sepolia
```
## For testing

```
yarn hardhat test
```

