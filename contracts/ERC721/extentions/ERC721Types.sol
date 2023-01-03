// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract ERC721Types {
    struct Token {
        address contractAddress;
        uint256 tokenId;
    }

    mapping (address => uint8) private _includedERC721;

    modifier onlyERC721(address contractAddress) {
        IERC721 token = IERC721(contractAddress);
        require(token.supportsInterface(type(IERC721).interfaceId), "includeERC721: Not compliant with IERC721.");
        _;
    }

    constructor() {}

    function isIncludedERC721(address contractAddress) external view returns (uint8) {
        return _includedERC721[contractAddress];
    }

    function includeERC721(
        address contractAddress
    )
        external
        onlyERC721(contractAddress)
    {
        _includedERC721[contractAddress] = 1;
    }

    function excludeERC721(address contractAddress) external {
        _includedERC721[contractAddress] = 0;
    }

    function getType(address contractAddress, uint256 tokenId) external pure returns(uint256) {
        bytes32 nftId = keccak256(abi.encodePacked(contractAddress, tokenId));

        uint256 i;
        uint256 typeId = nftId.length + tokenId;
        while (typeId >= 15) {
            typeId = typeId / 2;
            i++;
        }

        return typeId;
    }

    function _getNftId(
        address contractAddress,
        uint256 tokenId
    )
        private
        view
        onlyERC721(contractAddress)
        returns(bytes32)
    {
        return keccak256(abi.encodePacked(contractAddress, tokenId));
    }
}
