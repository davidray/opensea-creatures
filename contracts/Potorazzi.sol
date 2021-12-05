// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";

/**
 * @title Potorazzi
 * Potorazzi - a contract for my non-fungible Potorazzis.
 */
contract Potorazzi is ERC721Tradable {
	constructor(
		address _proxyRegistryAddress,
		address[] memory _payees,
		uint256[] memory _shares
	)
		ERC721Tradable("Potorazzi", "PRZI", _proxyRegistryAddress, _payees, _shares)
	{}

	function baseTokenURI() public pure override returns (string memory) {
		return
			"https://gateway.pinata.cloud/ipfs/QmRfzcmN7FVSDWccwVZeKFARECNLgYL4GoKsvH7PCD2Lg8/";
	}

	function contractURI() public pure returns (string memory) {
		return
			"https://gateway.pinata.cloud/ipfs/QmNqtCLZZzJTm3r38VcqVeTUm24girMfereRrCpVByRAgx/";
	}

	/**
	 * Override isApprovedForAll to auto-approve OS's proxy contract
	 */
	function isApprovedForAll(address _owner, address _operator)
		public
		view
		override
		returns (bool isOperator)
	{
		// if OpenSea's ERC721 Proxy Address is detected, auto-return true
		if (_operator == address(0x58807baD0B376efc12F5AD86aAc70E78ed67deaE)) {
			return true;
		}

		// otherwise, use the default ERC721.isApprovedForAll()
		return ERC721.isApprovedForAll(_owner, _operator);
	}
}
