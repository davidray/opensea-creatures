// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/utils/Strings.sol";
import "openzeppelin-solidity/contracts/finance/PaymentSplitter.sol";
import "./common/meta-transactions/ContentMixin.sol";
import "./common/meta-transactions/NativeMetaTransaction.sol";

contract OwnableDelegateProxy {}

contract ProxyRegistry {
	mapping(address => OwnableDelegateProxy) public proxies;
}

/**
 * @title ERC721Tradable
 * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
 */
abstract contract ERC721Tradable is
	ContextMixin,
	ERC721Enumerable,
	NativeMetaTransaction,
	Ownable,
	PaymentSplitter
{
	using SafeMath for uint256;

	address proxyRegistryAddress;
	uint256 private _currentTokenId = 0;

	constructor(
		string memory _name,
		string memory _symbol,
		address _proxyRegistryAddress,
		address[] memory _payees,
		uint256[] memory _shares
	) payable ERC721(_name, _symbol) PaymentSplitter(_payees, _shares) {
		proxyRegistryAddress = _proxyRegistryAddress;
		_initializeEIP712(_name);
	}

	//Emitted when mint function is called
	event TokenMinted(address to, uint256 tokenId);

	function mint() public payable {
		require(_currentTokenId < 10000, "Exceeds token supply");
		require(msg.value >= 0.05 ether, "Not enough ETH sent: check price.");
		uint256 newTokenId = _getNextTokenId();
		_mint(_msgSender(), newTokenId);
		_incrementTokenId();
		emit TokenMinted(_msgSender(), newTokenId);
	}

	/**
	 * @dev Mints a token to an address with a tokenURI.
	 * @param _to address of the future owner of the token
	 */
	function mintTo(address _to) public onlyOwner {
		uint256 newTokenId = _getNextTokenId();
		_mint(_to, newTokenId);
		_incrementTokenId();
	}

	/**
	 * @dev calculates the next token ID based on value of _currentTokenId
	 * @return uint256 for the next token ID
	 */
	function _getNextTokenId() private view returns (uint256) {
		return _currentTokenId.add(1);
	}

	/**
	 * @dev increments the value of _currentTokenId
	 */
	function _incrementTokenId() private {
		_currentTokenId++;
	}

	function baseTokenURI() public pure virtual returns (string memory);

	function tokenURI(uint256 _tokenId)
		public
		pure
		override
		returns (string memory)
	{
		return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
	}

	/**
	 * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
	 */
	function isApprovedForAll(address owner, address operator)
		public
		view
		virtual
		override
		returns (bool)
	{
		// Whitelist OpenSea proxy contract for easy trading.
		ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
		if (address(proxyRegistry.proxies(owner)) == operator) {
			return true;
		}

		return super.isApprovedForAll(owner, operator);
	}

	/**
	 * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
	 */
	function _msgSender() internal view override returns (address sender) {
		return ContextMixin.msgSender();
	}
}
