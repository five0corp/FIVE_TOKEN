pragma solidity ^0.5.2;

/**
 * @title Lockable Token
 */
contract Lockable {
    address public owner;

    mapping(address => bool) public unlockAddress;
    mapping(address => bool) public lockAddress;

    event Locked(address lockAddress, bool status);
    event Unlocked(address unlockedAddress, bool status);


    /**
     * @dev check whether registered in lockAddress or not
     */
    modifier checkLock {
        require(!lockAddress[msg.sender]);
        _;
    }

    modifier isOwner
    {
        require(owner == msg.sender);
        _;
    }

    constructor()
    public
    {
        owner = msg.sender;
    }

    /**
     * @dev add or remove in lockAddress(blacklist)
     */
    function setLockAddress(address target, bool status)
    external
    isOwner
    {
        require(owner != target);
        lockAddress[target] = status;
        emit Locked(target, status);
    }

    /**
     * @dev add or remove in unlockAddress(whitelist)
     */
    function setUnlockAddress(address target, bool status)
    external
    isOwner
    {
        unlockAddress[target] = status;
        emit Unlocked(target, status);
    }
}