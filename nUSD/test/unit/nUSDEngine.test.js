const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { assert, expect } = require("chai");
const { developmentChains } = require("../../helper-hardhat-config");

!developmentChains.includes(network.name) 
   ? describe.skip
   : describe("nUSDEngine",async()=>{
    let nUSDEngine,deployer;
    beforeEach(async () => {
        await deployments.fixture(["all"]);
        deployer = (await getNamedAccounts()).deployer;
        nUSDEngine = await ethers.getContract("nUSDEngine", deployer);
    });

   })