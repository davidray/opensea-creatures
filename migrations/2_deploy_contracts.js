const Potorazzi = artifacts.require("./Potorazzi.sol");

console.log("Running the deployer.");

module.exports = async (deployer, network, addresses) => {
	let proxyRegistryAddress = "";
	if (network === "rinkeby") {
		proxyRegistryAddress = "0xf57b2c51ded3a29e6891aba85459d600256cf317";
	} else if (network === "mumbai") {
		proxyRegistryAddress = "0x58807bad0b376efc12f5ad86aac70e78ed67deae";
	} else if (network === "polygon") {
		proxyRegistryAddress = "0x58807bad0b376efc12f5ad86aac70e78ed67deae";
	} else {
		proxyRegistryAddress = "0xa5409ec958c83c3f309868babaca7c86dcb077c1";
	}

	await deployer.deploy(Potorazzi, proxyRegistryAddress, { gas: 5000000 });
};
