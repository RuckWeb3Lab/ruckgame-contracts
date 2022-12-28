// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "operator-filter-registry/src/DefaultOperatorFilterer.sol";

contract RepDogsNFT is ERC721Enumerable, Ownable, AccessControl, DefaultOperatorFilterer {
    bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');

    string private baseURI;

    struct TokenMeta {
        address creator;
        uint tokenId;
        uint256 createdAt;
        uint256 updatedAt;
        uint tranferCount;
        string nftType;
    }

    mapping(uint256 => TokenMeta) private _tokenMetaList;

    modifier onlyMinter() {
        require(hasRole(MINTER_ROLE, msg.sender), "Minter: permission denied");
        _;
    }

    modifier existingToken(uint256 _tokenId) {
        require(_exists(_tokenId), "Nonexistent token");
        _;
    }

    event Mint(uint256 tokenId, address _receiver);
    event Burn(uint256 tokenId);
    event TokenTransfer(uint256 tokenId, address oldOwner, address newOwner);

    constructor(string memory name, string memory symbol, string memory newBaseURI) ERC721(name, symbol) {
        baseURI = newBaseURI;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory newBaseURI) public onlyOwner () {
        baseURI = newBaseURI;
    }

    function setApprovalForAll(address operator, bool approved) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function tokenInfo(uint256 tokenId) public view existingToken(tokenId) returns (TokenMeta memory) {
        TokenMeta memory token = _tokenMetaList[tokenId];
        return token;
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override {
        super._transfer(from, to, tokenId);

        TokenMeta memory token = _tokenMetaList[tokenId];

        token.tranferCount += 1;
        token.updatedAt = block.timestamp;

        _tokenMetaList[tokenId] = token;

        emit TokenTransfer(tokenId, from, to);
    }

    function mint(address _receiver, string memory _type, uint256 _tokenId) external onlyMinter {
        _mintToken(_receiver, _type, _tokenId);
    }

    function bulkMint(address[] memory _tos, string[] memory _types, uint256[] memory _tokenIds) external onlyMinter {
        uint8 i;
        for (i = 0; i < _tos.length; i++) {
          _mintToken(_tos[i], _types[i], _tokenIds[i]);
        }
    }

    function _mintToken(address _receiver, string memory _type, uint256 _tokenId) internal returns (uint256) {
        TokenMeta memory list = TokenMeta(
            _receiver,
            _tokenId,
            block.timestamp,
            block.timestamp,
            0,
            _type
        );

        _tokenMetaList[_tokenId] = list;
        _safeMint(_receiver, _tokenId);

        emit Mint(_tokenId, _receiver);
        return _tokenId;
    }

    function burn(uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "burn caller is not owner nor approved");
        _burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdraw() public onlyOwner {
        uint amount = address(this).balance;
        require(amount > 0, "Insufficient balance");
        (bool success, ) = payable(owner()).call {
            value: amount
        }("");

        require(success, "Failed to send Matic");
    }

    receive() payable external {}
}
