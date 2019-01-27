pragma solidity ^0.5.0;

import './HighVibeToken.sol';
import './crowdsale/distribution/FinalizableCrowdsale.sol';
import './crowdsale/validation/WhitelistCrowdsale.sol';
import './ownership/Ownable.sol';

contract HighVibeCrowdsale is FinalizableCrowdsale, WhitelistCrowdsale, Ownable {

    uint256 public _cap = 8000000000 ether; // total initial supply of tokens
    uint256 public _openingTime; // TBA
    uint256 public _closingTime; // TBA

    uint256 public weiRaisedDuringPrivateSale; // TBA

    uint256 public _rate;  // TBA: ETH to HV token conversion rate after last tranche.
    uint256 _tranche1;     // TBA: ETH to HV token conversion rate for tranche 1.
    uint256 _tranche2;     // TBA: ETH to HV token conversion rate for tranche 2.
    uint256 _tranche3;     // TBA: ETH to HV token conversion rate for tranche 3.
    uint256 _tranche4;     // TBA: ETH to HV token conversion rate for tranche 4.

    // HighVibe company wallet address where funds from the crowdsale will be sent to.
    address public _company_wallet = 0xE1E55F6A87e1a7108Dc2E80b730f7D0485067107; 
    // initial allocation of company tokens
    uint256 public _company_allocation;  // TBA

    // private sale address
    address public _privatesale_wallet; // TBA
    // allocation of tokens for private sale
    uint256 public _privatesale_allocation; // TBA

    // airdrop & bounty address
    address public _airdrop_bounty_wallet; // TBA
    // initial allocation of tokens for airdrops & bounties
    uint256 public _airdrop_bounty_allocation; // TBA

    // team & advisors address
    address public _team_advisors_wallet = 0xA6548F72549c647dd400b0CC8c31C472FC97215c;
    // initial allocation of tokens for team & advisors
    uint256 public _team_advisors_allocation = 1600000000;

    // contributors & authors address
    address public _contributors_authors_wallet = 0xB29101d01C229b1cE23d75ae4af45349F7247142;
    // initial allocation of tokens for  contributors & authors
    uint256 public _contributors_authors_allocation = 800000000;

    // bonus address
    address public _bonus_wallet; // TBA
    // initial allocation of tokens for bonuses
    uint256 public _bonus_allocation; // TBA

    // Reward pool address
    address public _rewardpool_wallet; // TBA
    
    // HighVibe token smart contract address
    HighVibeToken public _hvToken;

    constructor(
            HighVibeToken _token
        )
        public
        Crowdsale(_rate, _company_wallet, _token)
        TimedCrowdsale(_openingTime, _closingTime) {

        _hvToken = _token;

        // mint tokens
        _hvToken.mint(_company_wallet, _company_allocation);
        _hvToken.mint(_privatesale_wallet, _privatesale_allocation);
        _hvToken.mint(_airdrop_bounty_wallet, _airdrop_bounty_allocation);
        _hvToken.mint(_team_advisors_wallet, _team_advisors_allocation);
        _hvToken.mint(_contributors_authors_wallet, _contributors_authors_allocation);
        _hvToken.mint(_bonus_wallet, _bonus_allocation);
        
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
        return weiRaisedDuringPrivateSale.add(weiRaised());
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
        super.finalize();

        // allow token holders to sell their tokens (i.e. enable transfers)
        _hvToken.unpause();

        // mint remaining unsold tokens to reward pool
        _hvToken.mint(_rewardpool_wallet, _cap.sub(_hvToken.totalSupply()));
    }
}