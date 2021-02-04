// SPDX-License-Identifier: MIT

/**
 *Submitted for verification at Etherscan.io on 2021-01-12
 */

pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title TokenMintERC20Token
 * @author TokenMint (visit https://tokenmint.io)
 *
 * @dev Standard ERC20 token with burning and optional functions implemented.
 * For full specification of ERC-20 standard see:
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 */
contract TokenMintERC20Token is ERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Constructor.
     * @param name_ name of the token
     * @param symbol_ symbol of the token, 3-4 chars is recommended
     * @param decimals_ number of decimal places of one token unit, 18 is widely used
     * @param totalSupply total supply of tokens in lowest units (depending on decimals)
     * @param tokenOwnerAddress address that gets 100% of token supply
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 totalSupply,
        address payable feeReceiver,
        address tokenOwnerAddress
    ) payable ERC20(name_, symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;

        // set tokenOwnerAddress as owner of all tokens
        _mint(tokenOwnerAddress, totalSupply);

        // pay the service fee for contract deployment
        feeReceiver.transfer(msg.value);
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param value The amount of lowest token units to be burned.
     */
    function burn(uint256 value) public {
        _burn(msg.sender, value);
    }

    // optional functions from ERC20 stardard

    /**
     * @return the name of the token.
     */
    function name() public view override returns (string memory) {
        return _name;
    }

    /**
     * @return the symbol of the token.
     */
    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    /**
     * @return the number of decimals of the token.
     */
    function decimals() public view override returns (uint8) {
        return _decimals;
    }
}
