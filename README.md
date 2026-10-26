# Privacy-Friendly Lost-and-Found on Blockchain

Blockchain Lab (CSDC7022) mini project, Experiment 9, Don Bosco Institute of Technology, Kurla.

**Team:** Aaditi Bhatade · Janice Miranda · Piyush Mistry · Shravan Mangale

A lost-and-found system on Ethereum (Sepolia test network). The owner reports an item with only a **hash** of a secret detail, so the private details never go on chain. A claimant must give the detail that matches the hash. The finder hands the item in with `handIn` and gets recorded (and cannot claim it). The lost-and-found desk (custodian) confirms it with `markFound` and records the return with `markReturned`.

- `contract/SimpleLostAndFound.sol`: the Solidity smart contract (also used in Remix IDE)
- `index.html`: the web front end, a single page with four built-in demo roles (Desk, Owner, Finder, Someone else)

**Note:** the demo accounts' keys are inside the page on purpose, so nobody needs to install a wallet. They are for the Sepolia **test** network only and hold free test ETH. Never send real ETH to them.
