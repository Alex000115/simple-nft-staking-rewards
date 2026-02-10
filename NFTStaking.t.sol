// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./NFTStaking.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockNFT is ERC721 {
    constructor() ERC721("MockNFT", "MNFT") {
        _mint(msg.sender, 1);
    }
}

contract MockToken is ERC20 {
    constructor() ERC20("Reward", "RWD") {
        _mint(msg.sender, 10000e18);
    }
}

contract StakingTest is Test {
    NFTStaking public staking;
    MockNFT public nft;
    MockToken public token;
    address public user = address(0x1);

    function setUp() public {
        nft = new MockNFT();
        token = new MockToken();
        staking = new NFTStaking(address(nft), address(token), address(this));
        
        token.transfer(address(staking), 5000e18);
        nft.transferFrom(address(this), user, 1);
    }

    function testStakeAndReward() public {
        vm.startPrank(user);
        nft.approve(address(staking), 1);
        staking.stake(1);

        // Fast forward 1 hour
        vm.warp(block.timestamp + 3600);
        
        uint256 reward = staking.calculateRewards(1);
        assertEq(reward, 10e18);

        staking.unstake(1);
        vm.stopPrank();

        assertEq(token.balanceOf(user), 10e18);
        assertEq(nft.ownerOf(1), user);
    }
}
