const Potorazzi = artifacts.require("./Potorazzi.sol");

console.log("Running the deployer.");

module.exports = async (deployer, network, addresses) => {
	let proxyRegistryAddress = "";
	let payees = [];
	let shares = [];
	if (network === "rinkeby") {
		proxyRegistryAddress = "0xf57b2c51ded3a29e6891aba85459d600256cf317";
	} else if (network === "mumbai") {
		proxyRegistryAddress = "0x58807bad0b376efc12f5ad86aac70e78ed67deae";
		payees = [
			"0x0D38D230C30682f3124C083A6998F77db4223f02",
			"0x4c004A9a1Ae8Ef1ee72199a932700cf38a727d04",
		];
		shares = [60, 40];
	} else if (network === "polygon") {
		proxyRegistryAddress = "0x58807bad0b376efc12f5ad86aac70e78ed67deae";
		payees = ["0x0D38D230C30682f3124C083A6998F77db4223f02"];
		shares = [100];
	} else {
		proxyRegistryAddress = "0xa5409ec958c83c3f309868babaca7c86dcb077c1";
	}

	await deployer.deploy(Potorazzi, proxyRegistryAddress, payees, shares, {
		gas: 5000000,
	});
};
