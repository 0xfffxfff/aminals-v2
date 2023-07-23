// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "forge-std/Test.sol";

import {Aminals} from "src/Aminals.sol";
import {IAminal} from "src/IAminal.sol";

contract FeedBondingCurve {
    address public aminals;

    constructor(address _aminals) {
        aminals = _aminals;
    }

    function ratio_rule(uint256 amount) public returns (uint256) { // ratio rule must equal 1 when amount = 0; and go to 0 when amount --> infinity

        // int c = 1;
        // uint256 constant_v = (999 / 1000) ** (1/c);
        // /// rule in order to ensure that when prior_energy = 0, it takes "c" amount to reach post_energy = 1;
        // /// given energy ranging from [ 0 - 1000];

        // return constant_v ** amount; // need to divide by number > 1 rather than divide by number < 1
    }

    function feedBondingCurve(uint256 aminalID, uint256 amount) public {
        // Aminal storage aminal = aminals[aminalID];
        // //amount = msg.value;
        // uint256 gap = aminal.energyMax - aminal.energyCurrent;
        // uint256 ratio = ration_rule(amount);
        // uint256 newgap = gap * ratio; /// need to make sure that ration is positive for solidity purposes
        // uint256 newEnergy = aminal.energyMax - newgap;
        // aminal.energyCurrent = newEnergy;
    }

    // feed function uses a negative exponential bonding curve, that starts at 0 and asymptotically
    // goes to 100

    // P(S) = C * (1 - e ** (-a * S)) where C = 100 (max value) and a = steepness (e.g. 2)

    // integral :  R(S) = C * (S + e**(-a*S)/a)

    // TODO: Check this new formula, especially the type conversions which were
    // generated by GPT-4! Switch to a fixed point library if this solution
    // doesn't work
    function feedBondingCurveOld(uint256, /* amount*/ uint256 energy) public pure returns (uint256) {
        //simulate 'e' with eN / eD
        uint256 eN = 271_828 * 10 ** 18;

        uint256 C = 100; // maximum value that will never be reached
        uint256 a = 2; // steepness of the curve

        // Ensure that energy is non-negative, as it doesn't make sense to have negative energy in
        // this
        // context
        require(energy >= 0, "Energy must be non-negative");

        // Convert to unsigned integers for the calculation
        uint256 unsignedEnergy = uint256(energy);
        uint256 positiveExponent = a * unsignedEnergy;

        // Compute 1 / (e^x) using the fact that e^(-x) is 1 / e^x
        uint256 divisor = eN ** positiveExponent;
        require(divisor != 0, "Exponentiation resulted in zero");
        uint256 eToTheNegativeValue = 1e36 / divisor; // 1e36 is used for scaling, assuming 18
            // decimals
            // for the representation of 1

        // Now use the result in your equation
        int256 newEnergy = int256(C * (unsignedEnergy + eToTheNegativeValue / a));
        return uint256(newEnergy);
    }
}
