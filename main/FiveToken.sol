pragma solidity ^0.5.2;

import "../erc20/ERC20Pausable.sol";
import "../ownership/Ownable.sol";
import "../extensions/TokenLock.sol";

/**
 * @title FiveToken
 */
contract FiveToken is ERC20Pausable, Ownable {

    string public constant name = "FIVE TOKEN";
    string public constant symbol = "FVT";
    uint public constant decimals = 18;
    uint public constant INITIAL_SUPPLY = 30000 * (10 ** decimals);

    // Lock
    mapping (address => address) public lockStatus;
    event Lock(address _receiver, uint256 _amount);

    constructor() public {
    _mint(msg.sender, INITIAL_SUPPLY);
    }


    function LockToken(address beneficiary, uint256 amount, uint256 releaseTime, bool isOwnable) onlyOwner public {
        TokenLock lockContract = new TokenLock(this, beneficiary, msg.sender, releaseTime, isOwnable);

        transfer(address(lockContract), amount);
        lockStatus[beneficiary] = address(lockContract);
        emit Lock(beneficiary, amount);
    }

}
