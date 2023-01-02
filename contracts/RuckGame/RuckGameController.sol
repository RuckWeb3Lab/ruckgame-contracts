// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./services/GachaService.sol";
import "./services/IncludeNftService.sol";

contract RuckGameController is Ownable, GachaService, IncludeNftService {
    constructor(address ruckGameContract)
        GachaService(ruckGameContract)
        IncludeNftService(ruckGameContract)
    {}
}
