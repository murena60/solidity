// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMyContract {
    function setData(uint256 _data) external;
    function getData() external view returns (uint256);
    function processArray(uint256[] calldata _arr) external pure returns (uint256);
}
