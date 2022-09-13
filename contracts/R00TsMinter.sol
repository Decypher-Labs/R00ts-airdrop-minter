//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract R00TsMinter is ERC721Enumerable, Ownable {
    // This is for opensea contract name display
    // string public name = "R00ts Yatch Club";
    using Strings for uint256;
    // uint256 public totalSupply = 5000; // 5000 - 400(reserved for team) = 4600
    uint256 public totalMinted = 0;
    string public baseURI;
    string public baseExtension = ".json";
    address public immutable owner1;
    address public immutable owner2;
    address public immutable team;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    error TotalPublicSupplyReached();
    error TotalSupplyReached();
    error perWalletLimitReached();

    // mapping for keeping track of how many are minted and by who
    mapping(address => uint256) public ownerOfnfts;

    // Added setBaseURI feature in constructor for metadata
    constructor() ERC721("R00ts Yacht Club", "RTS") {
        owner1 = 0x48CEEB78e134F580D56990A77D54240ea9CbC4C3;
        owner2 = 0x2d4F4B7D7D0454170cd1394cf8b70Aa65cd2F02d;
        team = 0x2D751a936E6f59CaF65097E2a8E737ccf9eA25de;
        setBaseURI("ipfs://Qmf4GeJzDMxrLKUo3CF6VaVUk4gFK5Edz2YADRnqEwfu9N/");
        _tokenIdCounter.increment();
    }

    modifier onlyTeam() {
        require(
            msg.sender == owner1 || msg.sender == owner2,
            "Only Team can call this function"
        );
        _;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
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
        teamMint(team);
        if (totalMinted >= 5000) {
            revert TotalSupplyReached();
        }
        if (ownerOfnfts[msg.sender] >= 150) {
            revert perWalletLimitReached();
        }

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        totalMinted++;
        _safeMint(msg.sender, tokenId);
        ownerOfnfts[msg.sender]++;
    }

    function mintBatchTeam(uint256 quantity) external onlyTeam {
        teamMint(team);
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

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    function teamMint(address _team) internal {
        if (ownerOfnfts[team] < 100) {
            for (uint256 i = 0; i < 100; i++) {
                uint256 tokenId = _tokenIdCounter.current();
                _tokenIdCounter.increment();
                totalMinted++;
                _safeMint(_team, tokenId);
                ownerOfnfts[_team]++;
            }
        }
    }
}