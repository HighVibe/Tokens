pragma solidity ^0.5.0;

import './token/ERC20/ERC20Mintable.sol';
import './token/ERC20/ERC20Pausable.sol';
import './token/ERC20/ERC20Detailed.sol';

/**
 * @title HighVibe Token
 * @dev Pausable, Mintable token
 */
contract HighVibeToken is ERC20Detailed, ERC20Pausable, ERC20Mintable {

    string public _name = "HighVibe Token"; // name of token
    string public _symbol = "HV"; // token symbol
    uint public _totalSupply; // TBA
    uint8 public _decimals = 18; // decimal places

    /**
    * @dev Constructor for the HighVibe Token contract.
    *
    * This contract creates a pausable, mintable token
    * Pausing freezes all token functions - transfers, allowances, minting
    */
    constructor()
        ERC20Detailed(_name, _symbol, _decimals)
        ERC20Mintable() public {
    }

    /**
    * @dev Special override for the standard mint function
    *
    * The mint function is not overridden in the PausableToken so we must
    * override here to include the whenNotPaused modifier
    *
    * @param _to Recipient of new tokens
    * @param _amount Amount to mint
    */
    function mint(address _to, uint256 _amount) public whenNotPaused returns (bool) {
        return super.mint(_to, _amount); 
    }
}