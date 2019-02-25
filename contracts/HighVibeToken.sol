pragma solidity ^0.5.0;

import './token/ERC20/ERC20Mintable.sol';
import './token/ERC20/ERC20Pausable.sol';
import './token/ERC20/ERC20Detailed.sol';
import './ownership/Ownable.sol';

/**
 * @title HighVibe Token
 * @dev Pausable, Mintable token
 */
contract HighVibeToken is ERC20Detailed, ERC20Pausable, ERC20Mintable, Ownable {
    uint256 public deploymentTime = now;
    uint256 public year = 31557600;
    uint256 public inflationRate = 10;
    uint256 public maxInflationRate = 10;

    address public wallet_for_rewards_pool = 0xeA336D1C8ff0e0cCb09a253230963C7684ceE061;

    // initial token allocation
    address public wallet_for_team_and_advisors = 0xA6548F72549c647dd400b0CC8c31C472FC97215c;
    address public wallet_for_authors = 0xB29101d01C229b1cE23d75ae4af45349F7247142;
    address public wallet_for_reserve = 0xA23feA54386A5B12C9BC83784A99De291fe923A3;
    address public wallet_for_public_sale = 0x79ceBaF4cD934081E39757F3400cC83dc5DeBb78;
    address public wallet_for_bounty = 0xAE2c66BEFb97A2C353329260703903076226Ad0b;

    /**
    * @dev Constructor for the HighVibe Token contract.
    *
    * This contract creates a pausable, mintable token
    * Pausing freezes all token functions - transfers, allowances, minting
    */
    constructor()
        ERC20Detailed("HighVibe Token", "HV", 18)
        ERC20Mintable() public {
            super.mint(wallet_for_team_and_advisors, 1600000000 ether);
            super.mint(wallet_for_authors, 800000000 ether);
            super.mint(wallet_for_reserve, 1600000000 ether);
            super.mint(wallet_for_public_sale, 3600000000 ether);
            super.mint(wallet_for_bounty, 400000000 ether);
    }

    function mint(address _to, uint256 _amount) whenNotPaused public returns (bool) {   
        revert("tokens cannot be minted other than inflation tokens");
    }

    function mintInflation() onlyOwner external {
        require(now >= deploymentTime + year, "new inflation tokens cannot be minted yet");
        uint256 _supplyIncrease = (super.totalSupply() * inflationRate) / 100;
        super.mint(wallet_for_rewards_pool, _supplyIncrease);
        deploymentTime += year; // increase the time since deployment
    }

    function changeInflationRate(uint256 _rate) external onlyOwner {
        require(_rate <= maxInflationRate, "inflation rate must be less than or equal to 10%");
        inflationRate = _rate;
    }
}