pragma solidity ^0.5.2;

import "../erc20/ERC20.sol";
import "./Lockable.sol";
import "../lifecycle/Pausable.sol";

/**
 * @title Pausable & Lockable token
 * @dev ERC20 modified with pausable & lockable transfers.
 */
contract ERC20Extended is ERC20, Pausable, Lockable {
    
    /**
     * If this flag is true, admin can use enableTokenTranfer(), emergencyTransfer().
     */
    bool public adminMode;

    event TokenBurned(address burnAddress, uint256 amountOfTokens);
    event SetTokenTransfer(bool transfer);
    event SetAdminMode(bool adminMode);

    
    modifier isAdminMode {
        require(adminMode);
        _;
    }


    /**
     * @dev Burn tokens can only use by owner
     */
    function burnTokens(uint256 tokensAmount)
    public
    isAdminMode
    isOwner
    {
        require(_balances[msg.sender] >= tokensAmount);

        _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);
        _supply = _supply.sub(tokensAmount);
        emit TokenBurned(msg.sender, tokensAmount);
    }


    /**
     * @dev Set the tokenTransfer flag.
     * If true, 
     * - unregistered lockAddress can transfer()
     * - registered lockAddress can not transfer()
     * If false, 
     * - registered unlockAddress & unregistered lockAddress 
     * - can transfer(), unregistered unlockAddress can not transfer()
     */
    function setTokenTransfer(bool _tokenTransfer) external isAdminMode isOwner {
        tokenTransfer = _tokenTransfer;
        emit SetTokenTransfer(tokenTransfer);
    }

    function setAdminMode(bool _adminMode) public isOwner {
        adminMode = _adminMode;
        emit SetAdminMode(adminMode);
    }




    function transfer(address to, uint256 value) public isTokenTransfer checkLock whenNotPaused returns (bool) {
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public isTokenTransfer checkLockwhenNotPaused returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function approve(address spender, uint256 value) public checkLock whenNotPaused returns (bool) {
        return super.approve(spender, value);
    }

    function increaseAllowance(address spender, uint addedValue) public checkLock whenNotPaused returns (bool success) {
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint subtractedValue) public checkLock whenNotPaused returns (bool success) {
        return super.decreaseAllowance(spender, subtractedValue);
    }
}
