//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VendingMachine is ERC20{

    address public owner;
    uint256 public vendingMachineBalance;
    uint256 public doughnutPrice = 2 ether;

    event Withdrawn(address to, uint256 amount);

    mapping(address => uint256) public doughnutBalances;

    // set the owner as the address that deployed the contract
    // set the initial vending machine balance to 100
    constructor() ERC20("DoughNut", "DNut") {
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
 
        uint256 tokenToReceive = amount * 2;
        
        _mint(msg.sender, tokenToReceive);

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

    function withdraw(address payable to, uint256 amount) public payable onlyOwner {

        require(address(this).balance >= amount, "Insuffient balance to withdraw");
        require(to != address(0), "Can't withdraw to address zero");
        
        to.transfer(amount);

        emit Withdrawn(to, amount);

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