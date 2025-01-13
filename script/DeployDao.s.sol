// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MyGovernor} from "../src/MyGovernor.sol";
import {GovToken} from "../src/GovToken.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {Box} from "../src/Box.sol";
import {Script} from "forge-std/Script.sol";

contract DeployDao is Script {
    uint256 public constant MIN_DELAY = 3600;
    address[] proposers;
    address[] executors;

    function run() external returns (GovToken, TimeLock, MyGovernor, Box) {
        GovToken govToken = new GovToken();
        TimeLock timelock = new TimeLock(MIN_DELAY, proposers, executors);
        MyGovernor governor = new MyGovernor(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.TIMELOCK_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));
        timelock.revokeRole(adminRole, msg.sender);

        Box box = new Box();
        box.transferOwnership(address(timelock));
        return (govToken, timelock, governor, box);
    }
}
