//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract VendingMachine {

    address public owner;
    uint256 public vendingMachineBalance;
    uint256 public doughnutPrice = 2 ether;

    mapping(address => uint256) public doughnutBalances;

    // set the owner as the address that deployed the contract
    // set the initial vending machine balance to 100
    constructor() {
        owner = msg.sender;
        vendingMachineBalance = 100;
    }

    // ------------------------------------------ //
    //      PUBLIC STATE-MODIFYING FUNCTIONS      //
    // ------------------------------------------ //

    // Purchase donuts from the vending machine
    function purchase(uint256 amount) public payable {

        require(msg.value >= amount * doughnutPrice, "You must pay at least 2 ETH per donut");

        require(vendingMachineBalance >= amount, "Not enough doughnuts in stock to complete this purchase");

        vendingMachineBalance -= amount;

        doughnutBalances[msg.sender] += amount;

    }

    // ------------------------------------------ //
    //           ONLY OWNER FUNCTIONS             //
    // ------------------------------------------ //

    // Let the owner restock the vending machine
    function restock(uint256 amount) public onlyOwner {

        vendingMachineBalance += amount;

    }

    // ------------------------------------------ //
    //             VIEW FUNCTIONS                 //
    // ------------------------------------------ //

    function getVendingMachinceBalances() public view returns (uint256) {
        return vendingMachineBalance;

    }

    // ------------------------------------------ //
    //                MODIFIERS                   //
    // ------------------------------------------ //

    modifier onlyOwner{
        require(msg.sender == owner, "Only the owner can restock.");
        _;
    }


}