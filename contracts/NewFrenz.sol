// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract NewFrenz is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string svgPart1 =
        "<svg width='262' height='183' viewBox='0 0 262 183' fill='none' xmlns='http://www.w3.org/2000/svg'><path fill='#000' d='M0 0h262v183H0z'/><path fill-rule='evenodd' clip-rule='evenodd' d='M44 24h7v5h161v-5h7v8h-6v120h6v8h-7v-5H51v5h-7v-8h5V32h-5v-8Z' fill='";
    string svgPart2 = "' fill-opacity='.5'/><path fill='";
    string svgPart3 =
        "' d='M50 25h163v5H50zm0 128h163v5H50zM60 35h143v5H60zm0 108h143v5H60z'/><path fill='";
    string svgPart4 =
        "' d='M65 38h5v107h-5zm128 0h5v107h-5zm10 2h5v103h-5zM55 40h5v103h-5zm158-10h5v112h-5zM45 30h5v122h-5zm153-1h5v8h-5zM60 29h5v8h-5zm148 11h5v6h-5z'/><path fill='";
    string svgPart5 =
        "' d='M49 40h11v6H49zm159-20h15v5h-15zM40 20h15v5H40z'/><path fill='";
    string svgPart6 =
        "' d='M223 20v15h-5V20zM45 20v15h-5V20zm15 127h5v6h-5zm138 0h5v6h-5zm10-9h5v5h-5zm-158 0h10v5H50zm163 2h5v13h-5zm5 7h5v16h-5zm-10 11h5v5h-5zm5 0h5v5h-5zM40 147h5v15h-5zm10 10h5v5h-5z'/><path fill='";
    string svgPart7 =
        "' d='M44 157h7v5h-7z'/><text x='50%' y='60%' dominant-baseline='middle' text-anchor='middle' style='fill:#fff;font-family:sans-serif;font-size:12px'>";
    string svgPart8 =
        "</text><path d='M126.75 67h7.125v1.188h1.187v4.75h-1.187v1.187H131.5v5.938h2.375v2.374H131.5v1.188h2.375V86h-4.75V74.125h-2.375v-1.188h-1.188v-4.75h1.188V67Z' fill='#fff'/><path d='M127.938 69.375h4.75v2.375h-4.75v-2.375Z' fill='#11444B'/><path fill='#fff' d='M53 33h4v4h-4zm0 113h4v4h-4zM206 33h4v4h-4zm0 113h4v4h-4z'/></svg>";
    string[] colors = [
        "rgb(52, 173, 172)",
        "rgb(46, 78, 171)"
        "rgb(221, 125, 205)",
        "rgb(196, 81, 129)",
        "rgb(233, 182, 167)",
        "rgb(50, 147, 114)",
        "rgb(163, 125, 220)",
        "rgb(48, 107, 147)",
        "rgb(108, 50, 171)"
    ];

    event collectibleMinted(address sender, uint256 tokenId);

    constructor() ERC721("newfrenz", "NEWFRENZ") {
        console.log("Wassup.");
    }

    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COLOR", Strings.toString(tokenId)))
        );
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function createSvgOne(uint256 newItemId)
        internal
        view
        returns (string memory)
    {
        string memory randomColor = pickRandomColor(newItemId);

        string memory finalSvg = string(
            abi.encodePacked(
                svgPart1,
                randomColor,
                svgPart2,
                randomColor,
                svgPart3,
                randomColor,
                svgPart4,
                randomColor
            )
        );

        return finalSvg;
    }

    function createSvgTwo(string memory name, uint256 newItemId)
        internal
        view
        returns (string memory)
    {
        string memory randomColor = pickRandomColor(newItemId);

        string memory finalSvg = string(
            abi.encodePacked(
                svgPart5,
                randomColor,
                svgPart6,
                randomColor,
                svgPart7,
                name,
                svgPart8
            )
        );

        return finalSvg;
    }

    function create(string calldata name) public {
        require(bytes(name).length > 0, "Empty string.");
        require(bytes(name).length < 17, "Name too long.");
        uint256 newItemId = _tokenIds.current();
        string memory svgPartOne = createSvgOne(newItemId);
        string memory svgPartTwo = createSvgTwo(name, newItemId);

        string memory finalSvg = string(
            abi.encodePacked(svgPartOne, svgPartTwo)
        );

        console.log("finalSvg", finalSvg);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        name,
                        '", "description": "Your collectible to enter the world of web3.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();

        emit collectibleMinted(msg.sender, newItemId);
    }
}
