const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { assert, expect } = require("chai");
const { developmentChains } = require("../../helper-hardhat-config");

!developmentChains.includes(network.name)
  ? describe.skip
  : describe("StableCoin", async () => {
      let stablecoin, deployer;
      beforeEach(async () => {
        await deployments.fixture(["all"]);
        deployer = (await getNamedAccounts()).deployer;
        stablecoin = await ethers.getContract("StableCoin", deployer);
      });

      describe("mint", async () => {
        it("should mint 100 tokens to the deployer", async () => {
          await stablecoin.mint(deployer, 100);
          const balance = await stablecoin.balanceOf(deployer);
          assert.equal(balance.toString(), "100");
        });

      });

      describe("burn", async () => {
        it("should burn 100 tokens from the deployer", async () => {
          await stablecoin.mint(deployer, 100);
          await stablecoin.burn(deployer, 100);
          const balance = await stablecoin.balanceOf(deployer);
          assert.equal(balance.toString(), "0");
        });

      });
    });
