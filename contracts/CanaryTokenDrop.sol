// this is a simple contract that may contain security issues. DO NOT USE THAT IN PRODUCTION
pragma solidity ^0.8.9;

interface Token{
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}

contract CanaryTokenDrop {
    Token canary;
    Token l2Eth;
    address public owner;

    event Droped(address claimer, uint256 amount_claimed);

    constructor(address _canary, address _l2Eth, address _owner) {
        canary = Token(_canary);
        l2Eth = Token(_l2Eth);
        owner = _owner;
    }

    function drop(uint256 _amount) external {
        require(canary.balanceOf(address(this)) >= _amount, "not enough to drop");
        uint256 amountToPay = _amount / 5;
        l2Eth.transferFrom(msg.sender, address(this), amountToPay);
        canary.transfer(msg.sender, _amount);
    }

    function withdrawFunds() external {
        require(msg.sender == owner, "Only owner");
        uint256 balance = canary.balanceOf(address(this));
        canary.transfer(owner, balance);
    }
}