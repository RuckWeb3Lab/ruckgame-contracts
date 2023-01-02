// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract IncludeNftService is Ownable {
    address[] private _nftContractList;

    constructor(address ruckGameContract) {
         _nftContractList.push(ruckGameContract);
    }

    modifier onlyIncludedNftContract(address nftContractAddress) {
        require(
            _checkIncludedNftContract(nftContractAddress) == false,
            "onlyIncludedNftContract: Invalid contract address"
        );
        _;
    }

     /// @dev 対象のNFTコントラクトを追加する
    function includeNftContract(address nftContractAddress) external onlyOwner {
        require(_checkIncludedNftContract(nftContractAddress) == true, "includeNftContract: Already included");

        _nftContractList.push(nftContractAddress);
    }

    /// @dev 対象のNFTコントラクトを削除する
    function excludeNftContract(address nftContractAddress) external onlyOwner {
        for (uint8 i; i < _nftContractList.length; i++) {
            if (_nftContractList[i] == nftContractAddress) {
                delete _nftContractList[i];
            }
        }
    }

    /// @dev 対象のNFTコントラクトを取得する
    function getIncludedNftContracts() external view returns(address[] memory) {
        return _nftContractList;
    }

    function _checkIncludedNftContract(address nftContractAddress) private view returns(bool) {
        bool isIncluded = false;
        for (uint8 i; i < _nftContractList.length; i++) {
            if (_nftContractList[i] == nftContractAddress) {
                isIncluded = true;
            }
        }

        return isIncluded;
    }
}
