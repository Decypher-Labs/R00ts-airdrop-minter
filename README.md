# R00ts Airdrop Minter Contract For R00ts Yatch Club 

- ERC721 Contract:
  - Public Free Mint
  - Max 5000 supply (400 reserved for team)
  - 100 NFTs limit per wallet (for each minted, wallet gets one NFT airdropped)
  - 10% Royalties on Opensea
  - Function for team mint (batch mint)
  - Mint function is versatile and can be called by public and team
  
Metadata : https://gateway.pinata.cloud/ipfs/Qmf4GeJzDMxrLKUo3CF6VaVUk4gFK5Edz2YADRnqEwfu9N/1.json

NFT opensea : https://testnets.opensea.io/collection/test-nft-yomm0cnuth

Useful scripts:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat test ./test/sample-test.js
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```
