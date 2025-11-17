// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./IERC721Receiver.sol";
//контракт получателя
contract MyContract is IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
