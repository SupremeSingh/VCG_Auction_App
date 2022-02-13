// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 

contract basicAuction {

    bool public auctionOpen;
    uint256 public totalBidsAccepted;
    uint256 public totalItemsEntered;
    uint256 minimumEntryFee;

    struct Item {
        uint256 reservePrice;
        bool assigned;
    }

    struct Bid {
        uint256 totalValue;
        uint256[] allItemIDs;
    }
    
    mapping(address => bool) public bidderStatus;
    mapping(address => Bid) public userToBid;

    mapping(uint256 => Item) public itemIDToItem;
    mapping(address => Item) public itemToWinningBidder;

    modifier placeBidOnlyOnce() {
        require(!bidderStatus[msg.sender], "You have already placed a bid");
        _;
    }

    modifier payedEntryFee() {
        require(msg.value >= minimumEntryFee, "You need to bay the base fee to bid");
        _;
    }

    modifier onlyWhenAuctionOff() {
        require(!auctionOpen, "You can only add when auction is off");
        _;
    }

    constructor() {
        auctionOpen = false;
        totalItemsEntered = 0;
        minimumEntryFee = 0 ether;
        totalBidsAccepted = 0;
    }

    function submitBid(uint256 totalValue, uint256[] memory allItemIDs) public payable placeBidOnlyOnce() payedEntryFee() returns(uint256 tokenId) {
       bidderStatus[msg.sender] = true;
      
       totalBidsAccepted += 1;
       Bid memory currentBid = Bid(totalValue, allItemIDs);
       userToBid[msg.sender] = currentBid; 
    
       tokenId = totalBidsAccepted;
       transferOwnerShipTokenToBidder(msg.sender, tokenId);
    }   

    function transferOwnerShipTokenToBidder(address receiver, uint256 tokenID) public {
        // Send the user a 1155 with the metadata being the tokenID
    }

    function addItemToAuction(uint256 reservePrice) public payable onlyWhenAuctionOff() payedEntryFee() {
       Item memory currentItem = Item(reservePrice, false);
       itemIDToItem[totalItemsEntered] = currentItem;
       totalItemsEntered += 1;
    }

    function flipAuctionState() internal {
        auctionOpen = !auctionOpen;
    }

}