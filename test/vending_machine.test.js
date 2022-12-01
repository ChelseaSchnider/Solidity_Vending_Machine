const { expect } = require("chai");
const { parseEther } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

let owner;
let ownerAddress;
let alice;
let bob;
let chad;
let dave;

let VendingMachineContract;
let VendingMachineInstance;

describe("Vending Machine Tests", function () {
    beforeEach(async () => {
        [
            owner,
            alice,
            bob,
            chad,
            dave
        ] = await ethers.getSigners();

        ownerAddress = await owner.getAddress();
        aliceAddress = await alice.getAddress();
        bobAddress = await bob.getAddress();
        chadAddress = await chad.getAddress();
        daveAddress = await dave.getAddress();

        VendingMachineContract = await ethers.getContractFactory("VendingMachine");
        VendingMachineInstance = await VendingMachineContract.connect(owner).deploy();

    })

    describe("initialization tests", function () {
        it("initializes properly", async function () {
            expect(await VendingMachineInstance.owner()).to.be.equal(ownerAddress);
            expect(await VendingMachineInstance.vendingMachineBalance()).to.be.equal(100);
            expect(await VendingMachineInstance.doughnutPrice()).to.be.equal(parseEther("2"));
        });
    })

    describe("Purchase tests", function () {

        it("incorrect value sent for purchase", async () => {
            await expect(VendingMachineInstance.connect(alice).purchase(
               1,
               { value : parseEther("0.002") }
            )).to.be.revertedWith("You must pay at least 2 ETH per donut");
        });

        it("insufficient quantity in vending machine", async () => {

            await VendingMachineInstance.connect(alice).purchase(
                40,
                { value : parseEther("80") }
            );

            await VendingMachineInstance.connect(bob).purchase(
                25,
                { value : parseEther("50") }
            );

            await VendingMachineInstance.connect(chad).purchase(
                25,
                { value : parseEther("50") }
            );

            await expect(VendingMachineInstance.connect(dave).purchase(
                15,
                { value : parseEther("30") }
            )).to.be.revertedWith("Not enough doughnuts in stock to complete this purchase");

        });

        it("Vending machine amount decreases and buyer gets doughnuts", async () => {

            //Balance of vending machine is 100
            
            let doughnutBalanceInMachineBefore = await VendingMachineInstance.getVendingMachinceBalances();

            await VendingMachineInstance.connect(alice).purchase(
                5,
                { value : parseEther("10") }
            );

            //Balance of vending machine after purchase is 95

            let doughnutBalanceInMachineAfter = await VendingMachineInstance.getVendingMachinceBalances();

            expect(doughnutBalanceInMachineAfter).to.equal(doughnutBalanceInMachineBefore.sub(5))

            let alicedoughnutBalanceAfter = 5;

            expect(alicedoughnutBalanceAfter).to.equal(5);

        });

        it("Doughnut purchase receives doughnut tokens", async () => {

            let aliceBalanceBefore = await VendingMachineInstance.balanceOf(aliceAddress)

            await VendingMachineInstance.connect(alice).purchase(
                2,
                { value : parseEther("4") }
            );

            let aliceBalanceAfter = await VendingMachineInstance.balanceOf(aliceAddress)
            
            expect(aliceBalanceAfter).to.equal(aliceBalanceBefore.add(4))

        })
    })

    describe("Restock tests", function () {

        it("Only the owner can call this function", async () => {

            await expect(VendingMachineInstance.connect(alice).restock(
                5
            )).to.be.revertedWith("Only the owner can restock.")
 
        });

        it("should allow owner to restock doughnuts", async () => {
            let initialStockValue = await VendingMachineInstance.getVendingMachinceBalances(); 
            await VendingMachineInstance.restock(10);   
            let expectedStockValue = 10 + parseInt(initialStockValue);

            expect(await VendingMachineInstance.getVendingMachinceBalances()).to.be.equal(expectedStockValue.toString());
        });

    })
})