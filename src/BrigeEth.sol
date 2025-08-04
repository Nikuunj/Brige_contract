// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BrigeEth is Ownable {

     uint256 public balance;
     address public tokenAddress;
     mapping(address => uint256) public pendingBalance;
     event Deposite(address indexed depositor, uint256 amount);
     constructor(address _tokenAddress) Ownable(msg.sender) {
          tokenAddress = _tokenAddress;
     }

     function lock(IERC20 _tokenAddress, uint256 _amount) public {
          require(tokenAddress  == address(_tokenAddress));
          require(_amount > 0);
          require(_tokenAddress.allowance(msg.sender, address(this)) >= _amount);
          require(_tokenAddress.transferFrom(msg.sender, address(this), _amount));
          pendingBalance[msg.sender] += _amount;
          emit Deposite(msg.sender, _amount);
     }

     function unlock(uint256 _amount, IERC20 _tokenAddress) public {
          require(tokenAddress  == address(_tokenAddress));
          require(pendingBalance[msg.sender] >= _amount);
          pendingBalance[msg.sender] -= _amount;
          _tokenAddress.transfer(msg.sender, _amount);
     }

     function burnedOnOtherSide(uint256 _amount, address userAccount) public onlyOwner {
          pendingBalance[userAccount] += _amount;
     }
}
