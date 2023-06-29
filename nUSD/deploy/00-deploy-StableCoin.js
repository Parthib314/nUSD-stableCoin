const { network } = require("hardhat");
const { verify } = require("../utils/verify");
const {
  developmentChains,
  VERIFICATION_BLOCK_CONFIRMATIONS,
} = require("../helper-hardhat-config");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;
  const waitBlockConfirmations = developmentChains.includes(network.name)
    ? 1
    : VERIFICATION_BLOCK_CONFIRMATIONS;

  log("----------------------------------------------------");
  const args = [];
  if (chainId == 31337) {
    log("local network detected! Deploying convertor...");
    await deploy("Convertor", {
      contract: "Convertor",
      from: deployer,
      log: true,
      args: [],
    });
    log("Convertor deployed!");
  }
  const stableCoin = await deploy("StableCoin", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: waitBlockConfirmations,
  });

  if (
    !developmentChains.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    log("Verifying...");
    await verify(stableCoin.address, args);
  }
  log("----------------------------------------------------");
};


module.exports.tags = ["all", "coin"];
