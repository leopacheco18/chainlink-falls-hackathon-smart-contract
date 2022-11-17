// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract OpenMarket is ERC721URIStorage, VRFConsumerBase {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    AggregatorV3Interface internal immutable priceFeed;
    struct NFT {
        int256 price;
        address owner;
        bool status;
        string priceType;
    }

    bytes32 internal keyHash;
    uint256 internal fee;
    mapping(bytes32 => uint256) public randomByRequestId;
    mapping(uint256 => uint256) private randomNumbers;
    mapping(uint256 => uint256) public deposits;
    mapping(uint256 => NFT) public NFTData;

    event RequestedRandomness(
        bytes32 requestId,
        address from,
        address to,
        string objectId
    );
    event nftMinted(
        uint256 tokenId,
        string name,
        int256 price,
        address owner,
        string image,
        string category,
        string flag
    );
    event makeDeposit(string objectId);
    event withdraw(string objectId, bool result);

    constructor()
        VRFConsumerBase(
            0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, // VRF Coordinator
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB // LINK Token
        )
        ERC721("OpenMarket", "OM")
    {
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4; // hash of randomness
        fee = 0.001 * 10**18; // 0.001 LINK
        priceFeed = AggregatorV3Interface(
            0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
        ); //Matic address on mumbai
    }

    function addItem(
        string memory tokenURI,
        int256 price,
        string memory name,
        string memory image,
        string memory category,
        string memory flag,
        string memory priceType
    ) public returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        NFTData[newItemId] = NFT(price, msg.sender, true, priceType);
        emit nftMinted(
            newItemId,
            name,
            price,
            msg.sender,
            image,
            category,
            flag
        );
        _tokenIds.increment();
        return newItemId;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function getMaticPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    function changePriceType(string memory priceType, uint256 tokenId)
        public
        returns (string memory)
    {
        require(NFTData[tokenId].owner == msg.sender, "You are not the owner");
        NFTData[tokenId].priceType = priceType;
        return priceType;
    }

    function changePrice(int256 price, uint256 tokenId)
        public
        returns (int256)
    {
        require(NFTData[tokenId].owner == msg.sender, "You are not the owner");
        NFTData[tokenId].price = price;
        return price;
    }

    function changeStatus(bool status, uint256 tokenId) public returns (bool) {
        require(NFTData[tokenId].owner == msg.sender, "You are not the owner");
        NFTData[tokenId].status = status;
        return status;
    }

    function getRandomNumber(address to, string memory objectId)
        public
        returns (bytes32)
    {
        require(
            LINK.balanceOf(address(this)) > fee,
            "Not enough LINK - fill contract with faucet"
        );
        bytes32 requestId = requestRandomness(keyHash, fee);
        emit RequestedRandomness(requestId, msg.sender, to, objectId);
        return requestId;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomByRequestId[requestId] = randomness;
        randomNumbers[randomness] = randomness;
    }

    function deposit(bytes32 requestId, string memory objectId) public payable {
        require(msg.value > 0, "Is not the price.");
        deposits[randomByRequestId[requestId]] += msg.value;
        emit makeDeposit(objectId);
    }

    function refund(
        uint256 randomNumber,
        string memory objectId
    ) public {
        require(randomNumber != 0, "RandomNumber does not exist.");
        require(
            randomNumbers[randomNumber] == randomNumber,
            "RandomNumber does not exist."
        );
        uint256 value = deposits[randomNumber];
        deposits[randomNumber] = 0;
        payable(msg.sender).transfer(value);
        emit withdraw(objectId, false);
    }

    function withdrawMoney(
        uint256 randomNumber,
        uint256 tokenId,
        address from,
        address to,
        string memory objectId
    ) public {
        require(randomNumber != 0, "RandomNumber does not exist.");
        require(
            randomNumbers[randomNumber] == randomNumber,
            "RandomNumber does not exist."
        );
        uint256 value = deposits[randomNumber];
        deposits[randomNumber] = 0;
        payable(msg.sender).transfer(value);
        transferFrom(from, to, tokenId);
            NFTData[tokenId].status = false;
            NFTData[tokenId].price = 0;
            NFTData[tokenId].owner = to;
            emit withdraw(objectId, true);
    }
}
