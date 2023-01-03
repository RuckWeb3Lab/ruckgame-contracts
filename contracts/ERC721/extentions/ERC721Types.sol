// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract ERC721Types is Ownable {
    struct Type {
        uint256 firstType;
        string firstTypeName;
        uint256 secondType;
        string secondTypeName;
    }

    mapping(uint256 => string) private _typeList;

    string private _secondTypeWord;

    modifier onlyERC721(address contractAddress) {
        IERC721 token = IERC721(contractAddress);
        require(token.supportsInterface(type(IERC721).interfaceId), "includeERC721: Not compliant with IERC721.");
        _;
    }

    constructor() {
        _secondTypeWord = "secondTypeWord";

        _typeList[1] = "nomal";
        _typeList[2] = "fire";
        _typeList[3] = "water";
        _typeList[4] = "electric";
        _typeList[5] = "grass";
        _typeList[6] = "ice";
        _typeList[7] = "fighting";
        _typeList[8] = "poison";
        _typeList[9] = "ground";
        _typeList[10] = "flying";
        _typeList[11] = "psycho";
        _typeList[12] = "bug";
        _typeList[13] = "rock";
        _typeList[14] = "ghost";
        _typeList[15] = "dragon";

    }

    function getType(
        address contractAddress,
        uint256 tokenId
    )
        external
        view
        onlyERC721(contractAddress)
        returns(Type memory)
    {
        Type memory nftType;

        uint256 firstType = _getType(contractAddress, tokenId, "");
        nftType.firstType = firstType;
        nftType.firstTypeName = _typeList[firstType];

        uint256 secondType = _getType(contractAddress, tokenId, _secondTypeWord);
        nftType.secondType = secondType;
        nftType.secondTypeName = _typeList[secondType];

        return nftType;
    }

    function setSecondTypeWord(string memory newWord) external onlyOwner {
        _secondTypeWord = newWord;
    }

    function _getType(
        address contractAddress,
        uint256 tokenId,
        string memory secondTypeWord
    )
        private
        pure
        returns(uint256)
    {
        uint256 number = uint256(keccak256(abi.encodePacked(contractAddress, tokenId, secondTypeWord)));

        while (number > 15) {
            number = number / 2;
        }

        return number;
    }
}
