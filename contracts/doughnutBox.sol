//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "erc721a/contracts/ERC721A.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Customers can exchange the ERC20 doughnut tokens to a doughnut box 
// Customers can choose the flavours of the boxes
// Customers have to choose which boxset they want
// Owner of contract(doughnutBox) can deposit DNuts to vault 
// black box set = 12
// gold box set = 10 
// purple box set = 8
// blue box set = 6
// pink box set = 4
 
contract DoughnutBox is ERC721A {

    address public owner;
    uint8 blackBoxPrice = 12;
    uint8 goldBoxPrice = 10;
    uint8 purpleBoxPrice = 8;
    uint8 blueBoxPrice = 6;
    uint8 pinkBoxPrice = 4;

    IERC20 DNUTS;

    enum BoxColours {
        BLACK,
        GOLD,
        PURPLE,
        BLUE,
        PINK
    }

    BoxColours public boxcolours;

    struct Box {
        uint256 amount;
        bool sprinkles;
        bool smarties;
        bool chocolateSauce;
        address to;
        string[] flavours;
    }

    Box boxes;

    event BoxSold(address to, uint8 _boxcolours);

    constructor(address _dnuts)ERC721A("DoughnutBox", "DBX") {
        owner = msg.sender;
        DNUTS = IERC20(_dnuts);
    }

    function mintBoxes(bool _sprinkles, bool _smarties, bool _chocolateSauce, address to, BoxColours _boxcolours) public payable {
        if(_boxcolours = 0 ) {
            require(blackBoxPrice <= DNUTS.balanceOf(msg.sender), "Not enough token");
            boxcolours = BoxColours.BLACK;
            string[4] memory flavourOptions = ['chocolate', 'strawberry', 'vanilla', 'coffee'];
            flavourOptions.push[];
            boxes = Box(12, true, true, true, to, flavourOptions);
            DNUTS.transferFrom(msg.sender, address(this), blackBoxPrice);
            _safeMint(to, 1);

            emit BoxSold(to, _boxcolours);
        }

        if(_boxcolours = 1) {
            boxcolours = BoxColours.GOLD;
            boxes = Box(10, true, true, true, to, ['chocolate', 'strawberry', 'vanilla', 'coffee']);
        }

        if(_boxcolours = 2) {
            boxcolours = BoxColours.PURPLE;
            boxes = Box(8, true, true, true, to, ['chocolate', 'strawberry', 'vanilla', 'coffee']);
        }

        if(_boxcolours = 3) {
            boxcolours = BoxColours.BLUE;
            boxes = Box(6, true, true, true, to, ['chocolate', 'strawberry', 'vanilla']);
        }

        if(_boxcolours = 4) {
            boxcolours = BoxColours.PINK;
            boxes = Box(4, true, true, true, to, ['chocolate', 'vanilla']);
        }

    }

    function depositToVault (address to, uint256 amount) public onlyOwner {



    }



    modifier onlyOwner{
        require(msg.sender == owner, "Only the owner can withdraw.");
        _;
    }


}

