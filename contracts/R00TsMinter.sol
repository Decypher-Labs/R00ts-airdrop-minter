//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract R00TsMinter is ERC721, Ownable {

    uint256 public totalSupply = 5000; // 5000 - 400(reserved for team) = 4600
    uint256 public totalMinted = 0;

    address public immutable owner1;
    address public immutable owner2;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    error TotalPublicSupplyReached();
    error TotalSupplyReached();
    error perWalletLimitReached();

    // mapping for keeping track of how many nfts are minted and by whom
    mapping(address => uint256) public ownerOfnfts;

    constructor() ERC721("R00ts Yatch Club", "RTS") {
        // 55% of royalties and 200 NFTs to this wallet
        owner1 = 0x48CEEB78e134F580D56990A77D54240ea9CbC4C3;
        // 45% of royalties and 200 NFTs to this wallet
        owner2 = 0x2d4F4B7D7D0454170cd1394cf8b70Aa65cd2F02d;
    }

    modifier onlyTeam() {
        require(
            msg.sender == owner1 || msg.sender == owner2,
            "Only Team can call this function"
        );
        _;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

    function safeMint() public {
        if (totalMinted > 4600) {
            revert TotalPublicSupplyReached();
        }
        if (ownerOfnfts[msg.sender] >= 100) {
            revert perWalletLimitReached();
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        totalMinted++;
        _safeMint(msg.sender, tokenId);
        ownerOfnfts[msg.sender]++;
        airdropNFT(msg.sender);
    }

    function airdropNFT(address to) internal {
        if (totalMinted > 4600) {
            revert TotalPublicSupplyReached();
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        ownerOfnfts[msg.sender]++;
        totalMinted++;
    }

    function mintTeam() external onlyTeam {
        //Add a condiion here to check if they are a member of the team
        if (totalMinted > 5000) {
            revert TotalSupplyReached();
        }
        if (ownerOfnfts[msg.sender] >= 200) {
            revert perWalletLimitReached();
        }

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        totalMinted++;
        _safeMint(msg.sender, tokenId);
        ownerOfnfts[msg.sender]++;
    }

    function mintBatchTeam(uint256 quantity) external onlyTeam {
        if ((ownerOfnfts[msg.sender] + quantity) > 5000) {
            revert TotalPublicSupplyReached();
        }
        if ((ownerOfnfts[msg.sender] + quantity) > 200) {
            revert perWalletLimitReached();
        }
     
       for (uint256 i = 0; i < quantity; i++) {

            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            totalMinted++;
            _safeMint(msg.sender, tokenId);
            ownerOfnfts[msg.sender]++;
        }
    }
}
