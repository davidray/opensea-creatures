const HDWalletProvider = require("@truffle/hdwallet-provider");
const web3 = require("web3");
const MNEMONIC = process.env.MNEMONIC;
const NODE_API_KEY = process.env.INFURA_KEY || process.env.ALCHEMY_KEY;
const FACTORY_CONTRACT_ADDRESS = process.env.FACTORY_CONTRACT_ADDRESS;
const NFT_CONTRACT_ADDRESS = process.env.NFT_CONTRACT_ADDRESS;
const OWNER_ADDRESS = process.env.OWNER_ADDRESS;
const NETWORK = process.env.NETWORK;
const NUM_CREATURES = 12;
const DEFAULT_OPTION_ID = 0;

if (!MNEMONIC || !NODE_API_KEY || !OWNER_ADDRESS || !NETWORK) {
	console.error(
		"Please set a mnemonic, Alchemy/Infura key, owner, network, and contract address.",
	);
	return;
}

const NFT_ABI = [
	{
		constant: false,
		inputs: [
			{
				name: "_to",
				type: "address",
			},
		],
		name: "mintTo",
		outputs: [],
		payable: false,
		stateMutability: "nonpayable",
		type: "function",
	},
];

const FACTORY_ABI = [
	{
		constant: false,
		inputs: [
			{
				name: "_optionId",
				type: "uint256",
			},
			{
				name: "_toAddress",
				type: "address",
			},
		],
		name: "mint",
		outputs: [],
		payable: false,
		stateMutability: "nonpayable",
		type: "function",
	},
];

async function main() {
	const network = NETWORK;
	const provider = new HDWalletProvider(
		MNEMONIC,
		"https://" + network + ".infura.io/v3/" + NODE_API_KEY,
	);
	const web3Instance = new web3(provider);

	if (FACTORY_CONTRACT_ADDRESS) {
		const factoryContract = new web3Instance.eth.Contract(
			FACTORY_ABI,
			FACTORY_CONTRACT_ADDRESS,
			{ gasLimit: "2150000" },
		);

		// Creatures issued directly to the owner.
		for (var i = 0; i < NUM_CREATURES; i++) {
			try {
				const result = await factoryContract.methods
					.mint(DEFAULT_OPTION_ID, OWNER_ADDRESS)
					.send({ from: OWNER_ADDRESS });
				console.log("Minted creature. Transaction: " + result.transactionHash);
			} catch (e) {
				console.log(e);
			}
		}
	} else if (NFT_CONTRACT_ADDRESS) {
		const nftContract = new web3Instance.eth.Contract(
			NFT_ABI,
			NFT_CONTRACT_ADDRESS,
			{ gasLimit: "2150000" },
		);

		// Creatures issued directly to the owner.
		for (var i = 0; i < NUM_CREATURES; i++) {
			try {
				const result = await nftContract.methods
					.mintTo(OWNER_ADDRESS)
					.send({ from: OWNER_ADDRESS });
				console.log("Minted creature. Transaction: " + result.transactionHash);
			} catch (e) {
				console.log(e);
			}
		}
	} else {
		console.error(
			"Add NFT_CONTRACT_ADDRESS or FACTORY_CONTRACT_ADDRESS to the environment variables",
		);
	}
}

main();
