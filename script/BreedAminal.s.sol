pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {Aminals} from "src/Aminals.sol";
import {IAminal} from "src/IAminal.sol";
import {VisualsAuction} from "src/utils/VisualsAuction.sol";

contract BreedAminal is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Aminals aminals = Aminals(0x3Ca89BaFf371ddC51d7c33C55E03CB377b8A9016);

        for (uint256 i = 1; i <= 2; i++) {
            console.log(
                "Aminal love by ID by user: ",
                aminals.getAminalLoveByIdByUser(i, 0x1f028f240A90414211425bFa38eB4917Cb32c39C)
            );
            console.log("Aminal love total : ", aminals.getAminalLoveTotal(i));
        }

        aminals.breedWith{value: 0.01 ether}(1, 2);
        aminals.breedWith{value: 0.01 ether}(2, 1);

        vm.stopBroadcast();
    }
}
