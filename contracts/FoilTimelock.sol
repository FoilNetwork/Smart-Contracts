// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FoilTimelock is Ownable {
    IERC20 private token;
    mapping(address => uint256) private amounts; // List of monthly unlocking amounts per address

    constructor(address tokenContract) {
        token = IERC20(tokenContract);
    }

    /**
     * @dev Whitelists the given address to receive the given amount each month,
     * only the owner is authorized to do this action
     *
     * @param _addr    Receiver address.
     * @param _amount   Amount of tokens that will be transferred.
     */
    function whitelist(address _addr, uint256 _amount)
        public
        returns (bool success)
    {
        require(
            msg.sender == owner(),
            "Only the owner is allowed ot perform this action"
        );
        amounts[_addr] = _amount;
        return true;
    }

    /**
     * @dev Whitelisted users can claim the amount of tokens each month that the owner defined
     */
    function claim() public returns (bool success) {
        require(amountClaimable() > 0, "You have no tokens to claim");
        token.transfer(msg.sender, amounts[msg.sender]);
        amounts[msg.sender] = 0;
        return true;
    }

    /**
     * @dev Get the claimable amount for the given address
     */
    function amountClaimable() public view returns (uint256 amount) {
        return amounts[msg.sender];
    }
}
