pragma solidity ^0.4.24;

import './HighVibeToken.sol';
import './crowdsale/distribution/FinalizableCrowdsale.sol';

contract HighVibeCrowdsale is FinalizableCrowdsale {

    uint256 public _cap = 8000000000 ether; // total initial supply of tokens
    uint256 public _openingTime; // TBA: Nov 11, 2018
    uint256 public _closingTime; // TBA: Jan 11, 2019

    uint256 public weiRaisedDuringPrivateSale; // TBA

    uint256 public _rate;  // TBA: ETH to HV token conversion rate after last tranche.
    uint256 _tranche1;     // TBA: ETH to HV token conversion rate for tranche 1.
    uint256 _tranche2;     // TBA: ETH to HV token conversion rate for tranche 2.
    uint256 _tranche3;     // TBA: ETH to HV token conversion rate for tranche 3.
    uint256 _tranche4;     // TBA: ETH to HV token conversion rate for tranche 4.

    // HighVibe company wallet address where funds from the crowdsale will be sent to.
    address public _wallet = 0xE1E55F6A87e1a7108Dc2E80b730f7D0485067107; 
    // initial allocation of company tokens
    uint256 public _companyTokens; 

    // Reward pool address
    address public _rewardpool; // TBA
    
    // HighVibe token smart contract address
    HighVibeToken public _hvToken;

    constructor (
            HighVibeToken _token
        )
        public
        Crowdsale(_rate, _wallet, _token)
        TimedCrowdsale(_openingTime, _closingTime) {

        _hvToken = _token;

        // mint company tokens
        _hvToken.mint(_wallet, _companyTokens);
        
        // prevent token holders from selling during the public sale (i.e. disable transfers)
        _hvToken.pause();
    }

    // set address of HighVibe token smart contract.
    function setToken(address _newAddress) public onlyOwner {
        _hvToken = HighVibeToken(_newAddress);
    }

    // return the address of the HighVibe token smart contract.
    function getToken() public view returns (address) {
        return address(_hvToken);
    }

    // determine conversion from wei to tokens
    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256)
    {
        return _weiAmount.mul(getRate());
    }

    // computes total raised from private sale and public sale so far.
    function getTotalFundsRaised() public view returns (uint256) {
        return weiRaisedDuringPrivateSale.add(weiRaised);
    }

    // returns conversion rate of HV tokens per 1 ETH according to the tranches (based on time).
    function getRate() public view returns (uint256 rate) {
        if (now < (_openingTime.add(1 weeks))) { return _tranche1; }
        if (now < (_openingTime.add(2 weeks))) { return _tranche2; }
        if (now < (_openingTime.add(3 weeks))) { return _tranche3; }
        if (now < (_openingTime.add(4 weeks))) { return _tranche4; }

        return _rate;
    }

    function finalization() internal onlyOwner {
        super.finalization();

        // allow token holders to sell their tokens (i.e. enable transfers)
        _hvToken.unpause();

        // transfer remaining unsold tokens to reward pool
        _hvToken.mint(_rewardpool, _cap.sub(_hvToken.totalSupply()));
    }
}