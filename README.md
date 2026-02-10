# Simple NFT Staking Rewards

This repository provides a high-quality, beginner-friendly framework for building an NFT Staking ecosystem. It allows collectors to generate passive value from their digital assets without selling them.

## Workflow
1. **Staking:** Users transfer their NFT to the staking contract.
2. **Accrual:** The contract tracks the time elapsed. Rewards are calculated per block based on a fixed emission rate.
3. **Claiming:** Users can claim their accumulated ERC-20 tokens at any time.
4. **Unstaking:** Users withdraw their original NFT, and any remaining rewards are paid out.



## Features
- **Efficiency:** Uses a "pull" mechanism to calculate rewards, saving gas on every transaction.
- **Flexible Rewards:** Easily adjust the reward rate per NFT per block.
- **ERC-721 & ERC-20 Integration:** Seamlessly bridges two of the most popular Ethereum standards.

## Tech Stack
- **Solidity ^0.8.20**
- **OpenZeppelin Contracts**
- **Foundry**
