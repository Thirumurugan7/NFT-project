// contracts/onChainNFT.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";


/* 
    A library that provides a function for encoding some bytes in base64
    Source: https://github.com/zlayine/epic-game-buildspace/blob/master/contracts/libraries/Base64.sol
*/


library Base64 {
    bytes internal constant TABLE =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
                )
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
                )
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
                )
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}


contract OnChainNFT is ERC721URIStorage, Ownable,ERC2981 {
    event Minted(uint256 tokenId);
event randomColreurn(uint rand);


    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    

        uint256 public maxMintLimit = 100; // Set your desired maximum minting limit

    modifier hasMintPermission() {
        require(_tokenIds.current() <= maxMintLimit, "Exceeds maximum mint limit");
        _;
    }

    uint96 fee = 10;

    constructor() ERC721("OnChainNFT", "ONC") {
            _setDefaultRoyalty(msg.sender, 100);

    }
//for face and fire and hand
     string[27] public colors = [
        "#00FF00",
        "#00ffcc",
        "#0FFEFF",
        "#2F3FFF",
        "#3E00FF",
        "#40e0d0",
        "#5f2fce",
        "#71FABA",
        "#77FE6B",
        "#8400F5",
        "#9400d3",
        "#9CFF2E",
        "#C4E114",
        "#CCFE06",
        "#e0115f",
        "#E2CE90",
        "#E5E56F",
        "#F7B813",
        "#F7FE71",
        "#ff0000",
        "#FB186A",
        "#ff00cc",
        "#FF66FF",
        "#ff7e00",
        "#ffd700",
        "#FFFF00"
    ];

    //for background
  string[9] public colors2 = [
        "#000000",
        "#2200AA",
        "#00AA8B",
        "#076FF5",
        "#9F01E9",
        "#176465",
        "#453B5F",
        "#11EEBB",
        "#FF7E00"
    ];

   string[] private z = ['<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" x="0px" y="0px" viewBox="0 0 500 500" style="enable-background:new 0 0 500 500;" xml:space="preserve"><style type="text/css">.st0{fill:',
    ';}','.st1{fill:none;}.st2{fill:#FFFFFF;}.st3{fill:', '.st4{fill:' ];
      string[] private ze = ['</style><rect class="st0" width="500" height="500"/><rect x="-15.4" y="-30.9" class="st1" width="530.8" height="530.8"/><polygon class="st2" points="388.5,452.5 420.5,453.8 423.2,448.8 439.6,448.8 435.9,431.2 433,431.2 431.4,389.6 425.4,370.5   424.2,344.4 416,344.4 408.6,332.7 399.6,338.5 389.3,314.6 384.3,366.4 381.9,363.3 382.7,401.6 378.6,392.7 "/><polygon class="st2" points="59.1,438.5 77.6,446.6 108.6,452.5 123.4,445.5 125,332.6 118.5,322.2 84.8,342.2 73.5,375.3   69.4,404.6 "/><path class="st2" d="M323.3,409.3l-1.7-19.7l-11.4-7.7l-19.3,0.9l-1.7-20.5l-89.5,4.4l1,47.7l83.8-3.4L323.3,409.3z"/><path class="st2" d="M215.4,431.2l8.6,0.2l2.2,42.9l-32.7,0.7l0.8-9.4l24.8,0.9L215.4,431.2z"/><path class="st2" d="M286.1,428.1l2.2,43.4l38.8,2.6l-3.5-26.4h-18.4l-0.2,7l10.9,1.3l-0.7,6.2l-17.9-1.2l-1.1-25.3l21.4,0.2  l0.3-8.8L286.1,428.1z"/><path class="st2" d="M274.7,460.5l-0.4-29.6l-32.4-0.4l-1,43.7l9.9-0.1l0.5-11.2L274.7,460.5z M253.2,439.9l14-1.1l0.3,11.3  l-14.1,2.3l-0.3-11.3L253.2,439.9z"/><polygon class="st3" points="60.7,500 83.9,500 90.9,464.8 68.7,461.6 "/><polygon class="st3" points="405.1,467.9 411.3,500 435.9,500 429.8,463.8 "/><polygon class="st2" points="139,452.5 138.2,500 187.8,500 187.3,493.9 178.2,493.7 178.2,418.6 188.8,411.7 190.3,359.3   290.1,353.3 323.5,377.9 326.5,388.5 326.5,416.8 337.6,416.4 338.6,472.7 330.6,472.9 329.8,500 368.6,500 372.4,500 377,309.9   365.9,325.7 365.9,292.5 333.4,294.1 316.1,294.1 305.4,302.3 305.4,297.8 285.7,309.7 245,314.6 213.8,288.3 206.4,287.1   201.1,280.9 135.7,309.7 131.2,436.7 140.7,439.2 "/><polygon class="st2" points="321.6,500 322.4,487.8 203.4,490.7 203.5,500 "/><path class="st4" d="M259,425.9c-1.2,0-1.8-0.1-1.9-0.1l0.5-2.7l0.5-2.7c0.3,0,6.8,1.1,13.7-7.4c0.7-1,1-3,1.3-5  c0.6-4.9,1.5-11.6,9.1-15.7l5.1-2.8l-1.1,5.6c-0.7,3.6-1,9.4,0.6,11.4c0.2,0.3,0.6,0.5,1.3,0.5c5.7-0.1,8.9-5.8,12.6-13.2  c3.8-7.9,12.3-11.3,12.6-11.5l8.4-3.4l-5.1,7.4c-2,3-3.9,7.3-3.3,8.8c0,0.1,0.1,0.2,0.6,0.4c4.8,1.2,6.8-1.9,7-2.2l2.7-5.3l2.1,5.6  c0.3,0.7,2.8,7.6-3.5,22.6c0.1,0.3,0.3,0.6,0.5,0.8c0.5,0.3,2,0.1,4.5-1.2l2.5,4.8c-3.9,2.1-7.2,2.5-9.8,1.2  c-3.1-1.7-3.4-5.3-3.4-5.6v-0.6l0.2-0.6c2.9-6.8,3.8-11.7,4-14.8c-2.1,1.1-4.9,1.5-8.4,0.6c-2.8-0.6-3.9-2.4-4.5-3.7  c-0.5-1.4-0.5-2.9-0.2-4.4c-0.8,1-1.7,2.1-2.3,3.4c-3.5,7.1-8,16-17.4,16.2c-2.2,0-4.1-0.8-5.5-2.4c-1.8-2.1-2.4-5.4-2.4-8.5  c-1.1,2.1-1.5,4.6-1.8,7.1c-0.4,2.9-0.7,5.6-2.4,7.8C269.3,424.8,262.3,425.9,259,425.9z"/><path class="st4" d="M319,334.2l-3.1-3.3l-1.7,4.2c-0.8,1.9-2.5,4.6-5.8,5.9c-1,0.4-1.9,0.4-3-0.1c-0.9-0.4-1.1-1-1.2-1.4  c-0.7-3.6-0.4-13.2,9-22.1l5.7-6.1c0,0-41.6,19.1-47.9,48.6c-4.8,12.3-7.7,24.4-14.4,23.9c-1.1-0.1-2.3-0.3-2.6-1.1  c-1-2.2,2.3-8.3,5.1-11.9l3.1-4l-5.1-0.4c-7.9-0.7-15.6,3.7-23.1,13c-5.7,7.1-9.7,15.2-11.3,18.7c-0.2,0.5-0.6,1.1-0.7,1.3  c-2.6,4.8-6.9,10-13.2,7.7c-1-0.3-1.1-0.8-1.1-0.9c-0.4-1.8,2-5.8,4-8l4.5-5l-6.8,0.4c-15.8,1-23.1,9.7-26.6,17  c-3.6,7.7-3.5,15-3.5,15.3h5.3c0-1,0.1-20.9,18.7-25.7c-1.1,2.3-2,5-1.3,7.4c0.3,1.5,1.5,3.7,4.6,4.8c7.8,2.8,15.1-0.9,20.2-10.3  c0.2-0.3,0.4-0.9,0.8-1.5c9.1-18.8,17.3-25.9,23.6-28c-2.1,3.7-4,8.8-2.3,12.5c0.8,1.8,2.6,4,7.3,4.4c5.1,0.3,9.5-2.4,13.3-8.4  c3.1-4.8,4-12,6.8-19c6.1-15.3,10.1-25.2,23.3-31c-0.7,2.7-1.7,4.8-0.8,9.5c0.4,2.4,2,4.4,4.4,5.5s5.1,1.2,7.5,0.2  c3.5-1.4,4.3-3,5.9-5.9c2.8,4.4,7.8,10.7,2.5,18.8c-1.2,1.2-0.7,4,1.2,4.6c1.9,0.6,3.6-1.6,3.6-1.6  C331.9,349.8,323.9,339.5,319,334.2z"/><g><path class="st4" d="M311.6,500c1.3-1.5,2.6-3.1,3.9-4.8c3.1-4,6.3-8.1,10.9-10.9c-1.2,2.9-1.9,6.6-1.5,11.1   c0.2,1.8,0.1,3.3-0.1,4.6h5.4c0.2-1.5,0.2-3.2,0-5.1c-1-9.6,5-14,5.2-14.2l10.2-7.3l-12.3,2.4c-11.5,2.2-17.2,9.6-22.2,16   c-2.5,3.3-4.8,6.3-7.6,8.2L311.6,500L311.6,500z"/><path class="st4" d="M297.4,500c0.1-0.6,0.2-1.2,0.4-1.7l1.2-3.5l-3.7-0.1c-5.4-0.2-9.5,2.1-12.5,5.3L297.4,500L297.4,500z"/></g><path class="st4" d="M213.2,500c0.1-0.4,0.1-0.8,0.1-1.2c0.4-3.9,1-8.3,6.4-10.3c-0.2,1.8,0,3.7,1.2,5.2c1.7,2.2,4.8,2.6,9.2,1.4  l0.2-0.1c0.2-0.1,5.2-2,8.7-6.8c4.3-6,8-7.9,14.2-10.5c-2.6,4.1-3,7.5-1.1,10.4c1.4,2.2,3.8,3.3,6.8,3.2c4.1-0.1,8.7-2.7,10.5-5.8  c-0.3-5.2-5.1-2.8-5.1-2.8c-0.8,1.2-3.4,2.9-5.6,2.9c-0.8,0-1.4-0.2-1.7-0.6c-0.7-1.1,0.4-3.9,4.7-8.1c2.7-2.6,5.5-4.8,7-5.9  c0.2-0.1,0.4-0.3,0.6-0.5l0.1-0.1c0.1-0.1,0.3-0.2,0.4-0.3l0,0c2.1-1.9,3.7-4.4,3.7-4.4c1.7-5.9-2.8-4.5-2.8-4.5  c-0.7,2-3.4,3.8-5.8,5.1c-0.5,0.3-1.1,0.6-1.8,0.9c-2.2,1.1-5.2,2.4-7.9,3.5c-1,0.4-1.8,0.8-2.7,1.2c-7.3,3-12.6,5.2-18.4,13.1  c-2.3,3.2-5.5,4.6-6,4.8c-1.7,0.5-2.6,0.4-2.9,0.4c0-0.8,0.5-2.6,1.3-4.1l2.6-4.9l-5.5,0.6c-14.5,1.6-17.1,11.6-17.7,16.5  c-0.1,0.6-0.2,1.3-0.3,1.8h7.6V500z"/><path class="st3" d="M249.3,286.7c61.7,0,111.7-48.4,111.7-108.1S311,70.5,249.3,70.5s-111.7,48.4-111.7,108.1  S187.6,286.7,249.3,286.7z"/><path class="st3" d="M158.7,250.6l-36.6,16.3l43.6,4.8L158.7,250.6z"/><path class="st3" d="M114.5,232.9l20.7-11.7l2.9,19.7L114.5,232.9z"/><path class="st3" d="M131,181l-36-20.4l39-4.5L131,181z"/><path class="st3" d="M121.2,98.1l14.9,27.2l12.8-17.9L121.2,98.1z"/><path class="st3" d="M150.4,58.2l5,22.7l16.1-7.8l-7-2.1L150.4,58.2z"/><path class="st3" d="M183.5,35.3l8.9,38.5L206,62L183.5,35.3z"/><path class="st3" d="M257.9,12.3l-16.7,34.3l27.9,8.9L257.9,12.3z"/><path class="st3" d="M302.3,51.6l11.8,18.6l23.5-22.7L302.3,51.6z"/><path class="st3" d="M339.9,95.8l9.9,20.1l32.4-20.2L339.9,95.8z"/><path class="st3" d="M374.5,149l1.2,19.2l37.5-7.6L374.5,149z"/><path class="st3" d="M376.8,222.3l13.3-15.5l15.8,14.2l-1.7,3.1L376.8,222.3z"/><path class="st3" d="M356.3,261.2l9.7-3.9l7.9,12.1L356.3,261.2z"/><path class="st3" d="M317.5,278.2l18.7-3.7l5.4,42.8L317.5,278.2z"/><polygon points="364.1,183.8 315.9,184.6 313.3,178.8 231.7,166.8 156.5,149.1 142.3,155.7 132.5,159.8 127.1,228 132.7,229.1   134.2,235.5 153.1,235.5 168,247.6 171.6,241.9 190.1,237.7 194.6,244 194.7,245.5 200.1,242.9 198.5,235.8 203.8,218.3   213.1,206.7 224.7,231.5 218.8,238.5 267,255.8 302,253.2 314.1,208.2 318.4,207.4 321.1,198 364.2,195 "/><path class="st2" d="M151.3,172.6l3.5-1.5l6.5,17.6l19.7-7.3l5.3,4.2L166,196.1l5.3,14.1l-4.2,2l-8.3-13.3l-14.2,5.1l-0.6-9l8.1-3.4  l-2.1-18.5L151.3,172.6z"/><path class="st2" d="M241,218.1l18.7-11.5l-9.7-13.7l3.4-2.9l12.8,12.7l16.9-5.6l3.8,7.5l-12.7,7.1l9.6,11.8l-4.4,4l-11.7-11.9  l-21.7,6.8L241,218.1z"/></svg>'];

    /* Converts an SVG to Base64 string */
    function svgToImageURI()
        public
        
        returns (string memory)
    {
        string memory baseURL = "data:image/svg+xml;base64,";
      uint256 combinedRandomness = uint256(keccak256(abi.encodePacked(block.timestamp,_tokenIds.current())));
        uint256 combinedRandomness1 = uint256(keccak256(abi.encodePacked(combinedRandomness,block.timestamp,_tokenIds.current())));
        uint256 combinedRandomness2 = uint256(keccak256(abi.encodePacked(combinedRandomness1,block.timestamp,_tokenIds.current())));

        uint256 randomCol = combinedRandomness % 25;
        uint256 randombgCol = combinedRandomness1 % 9;
        uint256 randomFireCol = combinedRandomness2 % 25;



       emit randomColreurn(randomCol);
       emit randomColreurn(randombgCol);
       emit randomColreurn(randomFireCol);

          string memory svgBase64Encoded = Base64.encode(bytes(abi.encodePacked(z[0],colors2[randombgCol],z[1],z[2],colors[randomCol],z[1],z[3],colors[randomFireCol],z[1],ze[0])));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }


function supportsInterface(bytes4 interfaceId)
  public view virtual override(ERC721URIStorage, ERC2981)
  returns (bool) {
    return super.supportsInterface(interfaceId);
}

    /* Generates a tokenURI using Base64 string as the image */
    function formatTokenURI(string memory imageURI)
        public
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "on-chain nft of a person svg", "description": "This id done for neevan.eth", "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }


     /* Mints the token */
    function mint(uint noofNFt)payable public hasMintPermission {
           require(noofNFt > 0 && noofNFt <= 10, "Number of NFTs should be between 1 and 10");

         uint mintPrice = 0.0069 ether;

    // Calculate the expected value for the specified number of NFTs
    uint expectedValue = mintPrice * noofNFt;

    // Check if msg.value is equal to the expected value
    require(msg.value == expectedValue, "Incorrect amount sent for minting");

       for (uint i; i< noofNFt; i++){
         string memory imageURI = svgToImageURI();
        string memory tokenURI = formatTokenURI(imageURI);

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

              _setTokenRoyalty(newItemId, owner(), fee);


        emit Minted(newItemId);
       }
           payable(owner()).transfer(msg.value);

    }
}