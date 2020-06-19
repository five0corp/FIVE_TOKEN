pragma solidity ^0.5.0;

import "../erc20/ERC20.sol";
import "../erc20/ERC20Detailed.sol";
import "../extensions/ERC20Burnable.sol";
import "../extensions/TokenTimelock.sol";

/**
 * @title FiveToken
 */
contract FiveToken is ERC20, ERC20Detailed,ERC20Burnable {
    uint8 public constant DECIMALS = 18;
    uint256 public constant INITIAL_SUPPLY = 300000000 * (10 ** uint256(DECIMALS));

    // Lock
    mapping (address => address) public lockStatus;
    event Lock(address _receiver, uint256 _amount);

    /**
     * Constructor that gives msg.sender all of existing tokens.
     */
    constructor () public ERC20Detailed("FiveToken", "FVT", DECIMALS) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /**
     * TokenTimeLock function
     */
    function lockToken(address beneficiary, uint256 amount, uint256 releaseTime) public {
        TokenLock lockContract = new TokenTimelock(this, beneficiary, releaseTime );

        transfer(address(lockContract), amount);
        lockStatus[beneficiary] = address(lockContract);
        emit Lock(beneficiary, amount);
    }

}
