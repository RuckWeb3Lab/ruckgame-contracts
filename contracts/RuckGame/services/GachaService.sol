// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../RuckGameNFT/IRuckGameNFT.sol";

abstract contract GachaService is Ownable {
    IRuckGameNFT ruckGameNFT;

    // unixtime 15分に一度
    uint256 freeGachaPeriod = 3600 / 4;

    mapping(address => uint256) private _freeGachaExecutedAtList;

    modifier checkFreeGachaConditions() {
        require(
            _checkFreeGachaConditions(),
            "checkFreeGachaConditions: does not meet the conditions"
        );
        _;
    }

    constructor(address ruckGameNFTAddress) {
        ruckGameNFT = IRuckGameNFT(ruckGameNFTAddress);
    }

    /// @dev 無料ガチャ対象がを確認
    function isFreeGacha() external view returns(bool) {
        return _checkFreeGachaConditions();
    }

    /// @dev 無料ガチャの期間を設定する
    function setFreeGachaPeriod(uint256 unixtime) external onlyOwner {
        freeGachaPeriod = unixtime;
    }

    /// @dev 無料ガチャを回す
    function rollFreeGacha() external checkFreeGachaConditions {
        ruckGameNFT.safeMint(msg.sender);

        _freeGachaExecutedAtList[msg.sender] = block.timestamp;
    }

    /// @dev 有料ガチャを回す
    function rollPaidGacha() external {
        //
    }

    function _checkFreeGachaConditions() private view returns (bool) {
        if (_freeGachaExecutedAtList[msg.sender] == 0) {
            return true;
        } else {
            return (block.timestamp - _freeGachaExecutedAtList[msg.sender]) > freeGachaPeriod;
        }
    }
}

