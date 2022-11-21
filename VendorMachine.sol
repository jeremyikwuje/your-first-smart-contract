// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VendingMachine {

    // state variables
    address public owner;
    mapping (address => uint) public donutBalances;

    // se the owner as the address that deployed the contract
    // set the inital vending machine to 100
    constructor() {
        owner = msg.sender;
        donutBalances[address(this)] = 1;
    }

    function getVendingMachineBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    // Let the ower restock the vending machines
    function restock(uint amount) public {
        require(msg.sender == owner, "Only the owner is allowed to restock the vending machine.");
        donutBalances[address(this)] += amount;
    }

    // Purchase donuts from the vending machine
    // require minimum ether payment
    // require if enough donuts in stock
    function purchaseDonut(uint amount) public payable {
        require(getVendingMachineBalance() >= amount, "There is no enough donuts in stocks to complete the purchase.");
        require(msg.value >= amount * 2 ether, "You must pay at least 2 ether per donut.");
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;
    }
}
