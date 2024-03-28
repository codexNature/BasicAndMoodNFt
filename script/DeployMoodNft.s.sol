//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./img/sad.svg"); //This line reads the content of a file named "sad.svg" from a specific location (./img/sad.svg) and stores it as a string variable named sadSvg.
        string memory happySvg = vm.readFile("./img/happy.svg"); //This line does the same as the previous line but reads the content of a file named "happy.svg" and stores it as a string variable named happySvg.

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageURI(sadSvg),
            svgToImageURI(happySvg)
        ); //This line creates a new instance of the MoodNft contract. It passes two arguments to the constructor of MoodNft: the URI (Uniform Resource Identifier) of the sad SVG image and the URI of the happy SVG image. These URIs are generated by calling the svgToImageURI function on the sad and happy SVG strings.
        vm.stopBroadcast();
        return moodNft; //This line returns the newly created MoodNft contract instance to the caller of the run function.
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) { //This line declares a function called svgToImageURI. It takes a single parameter svg, which is a string representing an SVG image. The function is marked as public, meaning it can be called from outside the contract. It's also marked as pure, indicating that it doesn't read or modify state variables and only returns a value based on its inputs. The function returns a string representing a Uniform Resource Identifier (URI).
        string memory baseURL = "data:image/svg+xml;base64,"; //This line declares a string variable baseURL and initializes it with the text "data:image/svg+xml;base64,". This text is the beginning part of a data URI scheme that specifies the type of data being represented (an SVG image) and how it's encoded (in Base64 format).
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        ); //This line encodes the input SVG string into Base64 format. First, it converts the SVG string into bytes, then it encodes those bytes into a Base64 string using a function called Base64.encode. The resulting Base64-encoded string represents the SVG image in a format that can be included in a data URI.
        return string(abi.encodePacked(baseURL, svgBase64Encoded)); //This line combines the baseURL and the Base64-encoded SVG string into a single string, forming a complete data URI representing the SVG image. It returns this combined string as the output of the function. This data URI can be used to display the SVG image in web browsers or other applications that support data URIs.
    }
}