// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";

/**
 * @title Potorazzi
 * Potorazzi - a contract for my non-fungible Potorazzis.
 */
contract Potorazzi is ERC721Tradable {
    constructor(address _proxyRegistryAddress)
        ERC721Tradable("Potorazzi", "PRZI", _proxyRegistryAddress)
    {}

    function baseTokenURI() override public pure returns (string memory) {
        return "ipfs://Qmbg8PufaMX9teWoGNs6ZSz3cnfDzp3ijUWNBWHUeX7iWP";
    }

    function contractURI() public pure returns (string memory) {
        return "ipfs://QmbfbMn2YFhz21LhJqS3rbbZmrc29HqZoWnuJDRyHaFCLF";
    }
}
