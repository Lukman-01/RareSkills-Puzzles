// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Importing the necessary modules from the Forge Standard Library
import {Test, console2} from "forge-std/Test.sol";

// Importing the HelloWorld contract to access and test its functionalities
import {HelloWorld} from "../src/HelloWorld.sol";

/**
 * @title HelloWorldTest
 * @dev This contract is designed to test the functionality of the HelloWorld contract.
 * It uses the Forge standard library's Test utilities to perform assertions and checks.
 */
contract HelloWorldTest is Test {
    /// @notice Holds an instance of the HelloWorld contract to be tested
    HelloWorld public helloWorld;

    /**
     * @notice Deploys a new instance of HelloWorld contract before each test case
     * @dev This function is called automatically before each test method to ensure a fresh state.
     */
    function setUp() public {
        helloWorld = new HelloWorld(); // Deploying a new HelloWorld contract instance
    }

    /**
     * @notice Tests the `sayHelloWorld` function of HelloWorld contract
     * @dev Checks if the function returns the correct greeting for a given address.
     * @return success A boolean value indicating the success of the test case.
     */
    function test_SayHelloWorld() public returns (bool success) {
        // Invoking the sayHelloWorld function and storing the returned greeting message
        string memory greetings = helloWorld.sayHelloWorld(0x3e4B43D8bF9d69d2f142c39575fAD96E67c8Dc05);

        // Using the `require` statement to validate the returned message
        // The keccak256 hashing function is used for accurate comparison of the strings
        require(
            keccak256(abi.encodePacked(greetings)) == keccak256(abi.encodePacked("Hello World")),
            "Greeting message does not match expected output"
        );

        return true; // Indicating the test has passed successfully
    }
}

