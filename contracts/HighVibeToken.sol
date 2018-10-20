pragma solidity ^0.4.24;

import './token/ERC20/MintableToken.sol';
import './token/ERC20/PausableToken.sol';
import './token/ERC20/DetailedERC20.sol';

/**
 * @title HighVibe Token
 * @dev Pausable, Mintable token
 */
contract HighVibeToken is DetailedERC20, PausableToken, MintableToken {

    string public _name = "HighVibe Token"; // name of token
    string public _symbol = "HV"; // token symbol
    uint public _totalSupply; // TBA
    uint8 public _decimals = 18; // decimal places

    /**
    * @dev Constructor for the HighVibe Token contract.
    *
    * This contract creates a Pausable, Mintable token
    * Pausing freezes all token functions - transfers, allowances, minting
    * Minting will stop if finishMinting() is called
    * finishMinting() is permanent 
    */
    constructor()
        DetailedERC20(_name, _symbol, _decimals)
        MintableToken() public {
        totalSupply_ = _totalSupply;
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

    /**
    * @dev Special override for the standard finishMinting function
    *
    * The finishMinting function is not overridden in the PausableToken so we must
    * override here to include the whenNotPaused modifier
    */
    function finishMinting() public whenNotPaused returns (bool) {
        return super.finishMinting();
    }

}