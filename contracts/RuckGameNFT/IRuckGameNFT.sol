// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/interfaces/IERC721Enumerable.sol";
import "@openzeppelin/contracts/access/IAccessControl.sol";

interface IRuckGameNFT is IERC721Enumerable, IAccessControl {
    function setBaseURI(string memory newBaseURI) external;
    function safeMint(address to) external;
    function burn(uint256 tokenId) external;
}
