// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NFTStaking
 * @dev Professional implementation of an NFT staking reward system.
 */
contract NFTStaking is ERC721Holder, Ownable {
    IERC721 public nftCollection;
    IERC20 public rewardToken;

    uint256 public rewardRatePerHour = 10e18; // 10 tokens per hour per NFT

    struct Stake {
        address owner;
        uint256 timestamp;
    }

    mapping(uint256 => Stake) public vault;

    constructor(address _nft, address _reward, address _owner) Ownable(_owner) {
        nftCollection = IERC721(_nft);
        rewardToken = IERC20(_reward);
    }

    function stake(uint256 tokenId) external {
        nftCollection.safeTransferFrom(msg.sender, address(this), tokenId);

        vault[tokenId] = Stake({
            owner: msg.sender,
            timestamp: block.timestamp
        });
    }

    function calculateRewards(uint256 tokenId) public view returns (uint256) {
        Stake memory stakedItem = vault[tokenId];
        uint256 stakedDuration = block.timestamp - stakedItem.timestamp;
        return (stakedDuration * rewardRatePerHour) / 3600;
    }

    function unstake(uint256 tokenId) external {
        Stake memory stakedItem = vault[tokenId];
        require(stakedItem.owner == msg.sender, "Not the owner");

        uint256 reward = calculateRewards(tokenId);
        delete vault[tokenId];

        rewardToken.transfer(msg.sender, reward);
        nftCollection.safeTransferFrom(address(this), msg.sender, tokenId);
    }
}
