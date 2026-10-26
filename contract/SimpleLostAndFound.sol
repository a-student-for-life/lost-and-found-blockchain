// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Simple Privacy-Friendly Lost-and-Found
/// @notice The owner reports a lost item but stores only a HASH of a secret
///         detail, not the detail itself. A claimant must give the detail that
///         matches the hash. The lost-and-found desk (custodian) records the return.
contract SimpleLostAndFound {
    enum Status { Lost, Found, Claimed, Returned }

    struct Item {
        address owner;        // who reported it
        string  category;     // public, general: "Wallet", "Phone"
        bytes32 secretHash;   // keccak256 of the secret detail
        Status  status;
        address finder;       // who found it and handed it to the desk
        address claimant;     // who proved ownership
    }

    address public custodian;            // the lost-and-found desk
    uint256 public itemCount;
    mapping(uint256 => Item) public items;

    event ItemReported(uint256 itemId, string category);
    event ItemFound(uint256 itemId, address finder);
    event ItemClaimed(uint256 itemId, address claimant);
    event ItemReturned(uint256 itemId, address claimant, address finder);

    modifier onlyCustodian() {
        require(msg.sender == custodian, "Only the custodian can do this");
        _;
    }

    constructor() {
        custodian = msg.sender;          // whoever deploys is the desk
    }

    // 1. Owner reports the item with only a hash of the secret detail
    function reportLost(string memory category, bytes32 secretHash) public {
        itemCount++;
        items[itemCount] = Item(msg.sender, category, secretHash, Status.Lost, address(0), address(0));
        emit ItemReported(itemCount, category);
    }

    // 2. Finder hands the item to the desk; desk logs it and records the finder
    function markFound(uint256 itemId, address finder) public onlyCustodian {
        require(items[itemId].status == Status.Lost, "Item is not in Lost state");
        items[itemId].status = Status.Found;
        items[itemId].finder = finder;
        emit ItemFound(itemId, finder);
    }

    // 3. Claimant gives the secret detail; the contract checks it against the hash
    function claimItem(uint256 itemId, string memory secretDetail) public {
        Item storage it = items[itemId];
        require(it.status == Status.Found, "Item is not available to claim");
        require(msg.sender != it.finder, "Finder cannot claim the item");
        require(keccak256(abi.encodePacked(secretDetail)) == it.secretHash, "Wrong detail, claim rejected");
        it.status = Status.Claimed;
        it.claimant = msg.sender;
        emit ItemClaimed(itemId, msg.sender);
    }

    // 4. Desk records that the item was physically returned
    function markReturned(uint256 itemId) public onlyCustodian {
        require(items[itemId].status == Status.Claimed, "No verified claim yet");
        items[itemId].status = Status.Returned;
        emit ItemReturned(itemId, items[itemId].claimant, items[itemId].finder);
    }

    // Helper: owner uses this to get the hash before reporting
    function getHash(string memory secretDetail) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(secretDetail));
    }
}
