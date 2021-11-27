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
        return "https://gateway.pinata.cloud/ipfs/QmRfzcmN7FVSDWccwVZeKFARECNLgYL4GoKsvH7PCD2Lg8";
    }

    function contractURI() public pure returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmNqtCLZZzJTm3r38VcqVeTUm24girMfereRrCpVByRAgx";
    }
}
