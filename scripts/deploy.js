const hre = require("hardhat");
const fs = require('fs');

async function main() {
  const VendingMachine = await hre.ethers.getContractFactory("VendingMachine");
  const vendingMachine = await VendingMachine.deploy();
  await vendingMachine.deployed();
  console.log("vendingMachine deployed to:", vendingMachine.address);

  fs.writeFileSync('./config.js', `
    export const vendingmachineAddress = "${vendingMachine.address}"
  `)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
