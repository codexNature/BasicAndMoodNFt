//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol"; //we use Base64 to encode, check what it does on Openze[pelin.

contract MoodNft is ERC721 {
    //Error
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter; //Here, we declare a variable s_tokenCounter, which will keep track of the total number of tokens that have been created. The private keyword means that this variable can only be accessed from within this contract and not from outside.
    string private s_sadSvgImageUri; //stores the svg representations in the variables.
    string private s_happySvgImageUri; //stores the svg representations in the variables.

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MN") {
        //This is a constructor function, which gets called automatically when the contract is deployed. It takes two parameters: sadSvg and happySvg, which are SVG images representing sad and happy moods, respectively. Inside the constructor, we initialize the contract by calling the constructor of the inherited ERC721 contract with the name "Mood NFT" and the symbol "MN". Additionally, we initialize the s_tokenCounter, s_sadSvg, and s_happySvg variables with the values provided
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    } //These lines set the initial values for the s_tokenCounter, s_sadSvg, and s_happySvg variables with the values passed to the constructor.

    //Now we make it so anybody can mint one of this.
    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] == Mood.HAPPY; //defau;t mood is happy when minted.
        s_tokenCounter++;
    } //This is a function named mintNft, which allows anyone to create a new token representing a mood. When someone calls this function, it creates a new token and assigns it to the caller (msg.sender). It uses the _safeMint function inherited from the ERC721 contract to actually create the token. After minting the token, it increments the s_tokenCounter variable to keep track of the total number of tokens created.

    function flipMood(uint256 tokenId) public {
        //This line defines a function called flipMood that accepts one parameter tokenId, which represents the unique identifier of a token.
        //only NFT owner to be able to change the mood.
        /* if (!_isApprovedOrOwner(msg.sender, tokenId)) {  //!_isApprovedOrOwner is from ERC721.sol and it told us what args it takes. 
            revert MoodNft__CantFlipMoodIfNotOwner();
        } */
        //The Above has been removed from ERC721 and replaced with below.
        address from = _ownerOf(tokenId);
        _checkAuthorized(from, msg.sender, tokenId); //_checkAuthorized is from ERC721.sol and it told us what args it takes.
        //This line checks if the caller of the function (the person who is trying to change the mood of the NFT) is the owner of the NFT associated with the given tokenId. If the caller is not the owner, the function stops and reverts the transaction, indicating that the mood cannot be flipped if the caller is not the owner.
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        } //This line checks the current mood of the NFT associated with the given tokenId. If the mood is currently set to "HAPPY", it changes it to "SAD". If the mood is not "HAPPY" (which means it's "SAD"), it changes it to "HAPPY". This effectively flips the mood of the NFT between "HAPPY" and "SAD".
    }

    function _baseURI() internal pure override returns (string memory) {
        //override because ERC721.sol has its own _baseURI that we override.
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        //We need to have it in bytes in order to use the openzeppelin base64 encoder.
        return
            string(
                abi.encodePacked( //
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(), //{"name": "MoodNft"}
                                '", "description": "An NFT that reflects the owners mood.", "attributes": [{"traits_type": "moodiness", "value": 100}], "image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
