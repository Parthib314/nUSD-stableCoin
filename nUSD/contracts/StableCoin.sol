// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/** 
*  @title DecentralizedStableCoin
*  @author Parthib Datta
*  Collateral: Exogenous(ETH)
*  Minting: Algorihmic
*  Relative Stability: Pegged to ETH
*
*  This contract is just the ERC20 implementation of our stablecoin system
*
*/
contract StableCoin is ERC20{
  error DecentralizedStableCoin__AmountMustBeMoreThanZero();
  error DecentralizedStableCoin__BurnAmountExceedsBalance();
  error DecentralizedStableCoin__NotZeroAddress();

  constructor()ERC20("StableCoin","nUSD") {}

  /**
   * 
   * @param _to : The transfer address account
   * @param _amount : How much you want to mint
   */
  function mint(address _to, uint256 _amount) external returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin__AmountMustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }

  /**
   * 
   * @param account : The account from where to burn
   * @param _amount : The Amount to burn
   */
  function burn(address account,uint256 _amount) external {
        if (_amount <= 0) {
            revert DecentralizedStableCoin__AmountMustBeMoreThanZero();
        }
        _burn(account, _amount);
    }
}