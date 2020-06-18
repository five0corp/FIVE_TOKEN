pragma solidity ^0.5.0;

import "../erc20/ERC20.sol";
import "../erc20/ERC20Detailed.sol";

/**
 * @title FiveToken
 */
contract FiveToken is ERC20, ERC20Detailed {
    uint8 public constant DECIMALS = 18;
    uint256 public constant INITIAL_SUPPLY = 300000000 * (10 ** uint256(DECIMALS));

    /**
     * Constructor that gives msg.sender all of existing tokens.
     */
    constructor () public ERC20Detailed("FiveToken", "FVT", DECIMALS) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}
