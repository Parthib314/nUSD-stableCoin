// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./StableCoin.sol";
import "./Oracle/Converter.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 *  @title nUSDEngine
 *  @author Parthib Datta
 *  The system is designed to be as minimal as possible, and have the tokens maintain a (1/2 of Price of ETH) token == Price of ETH peg at all times.
 * This is a stablecoin with the properties:
 * - Exogenously Collateralized
 * - ETH Pegged
 * - Algorithmically Stable
 *
 * It is similar to DAI if DAI had no governance, no fees, and was backed by only ETH.
 *
 * @notice This contract is the core of the Decentralized Stablecoin system. It handles all the logic
 * for minting and redeeming DSC, as well as depositing and withdrawing collateral.
 *
 *  This contract is just the ERC20 implementation of our stablecoin system
 *
 */

contract nUSDEngine is ReentrancyGuard {
    error nDSCEngine__NeedsMoreThanZero();
    error nUSDEngine__MintFailed();
    error nUSDEngine__TransferFailed();
    error nDSCEngine__InsufficientBalance();

    StableCoin private immutable i_dsc;
    Convertor private immutable i_convert;

    mapping(address => uint256) private balances;

    uint64 private constant THRESHOLD = 50;

    event Deposited(address indexed User, uint256 indexed amount);
    event Redeemed(address indexed User, uint256 indexed amount);

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert nDSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    /**
     * @param dscAddress: Address of the token
     *  @param _convertorAddress: Address of the converter contract
     */
    constructor(address dscAddress, address _convertorAddress) {
        i_dsc = StableCoin(dscAddress);
        i_convert = Convertor(_convertorAddress);
    }

    /**
     *  The amount of ETH you want to deposit
     */
    function deposite() public payable moreThanZero(msg.value) nonReentrant {
        uint256 amount = msg.value / 1e9;
        uint256 priceAmount = i_convert.getConversionRate(amount);
        uint256 nUSDAmount = (priceAmount * THRESHOLD) / 100;
        if (nUSDAmount <= 0) {
            revert nDSCEngine__NeedsMoreThanZero();
        }
        bool minted = i_dsc.mint(msg.sender, nUSDAmount);
        if (minted != true) {
            revert nUSDEngine__MintFailed();
        }
        balances[msg.sender] += amount;
        emit Deposited(msg.sender, amount);
    }

    /**
     *
     * @param amount: The Amount of ETH you want to redeem in Gwei
     */
    function redeem(uint256 amount) external moreThanZero(amount) {
        if (balances[msg.sender] < amount) {
            revert nDSCEngine__InsufficientBalance();
        }
        balances[msg.sender] -= amount;
        uint256 priceAmount = i_convert.getConversionRate(amount);
        uint256 nUSDAmount = (priceAmount * THRESHOLD) / 100;
        i_dsc.burn(msg.sender, nUSDAmount);
        payable(msg.sender).transfer(amount * 1e9);
        emit Redeemed(msg.sender, amount);
    }

    function getDepositBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    function getBalance(address user) public view returns (uint256) {
        return i_dsc.balanceOf(user);
    }

    function getTotalSupply() public view returns (uint256) {
        return i_dsc.totalSupply();
    }
}
