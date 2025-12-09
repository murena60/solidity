// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMyContract {
    function setData(uint256 _data) external;
    function getData() external view returns (uint256);
    function processArray(uint256[] calldata _arr) external pure returns (uint256);

}

contract MyContract is IMyContract {
    uint256 public storedData; // Переменная хранения

    // Функция сохранения данных в хранилище
    function setData(uint256 _data) external override {
        storedData = _data;
    }

    // Функция извлечения данных из хранилища
    function getData() external view override returns (uint256) {
        return storedData;
    }

    // Функция, использующая память и calldata
    function processArray(uint256[] calldata _arr) external pure override returns (uint256) {
        uint256 sum = 0; // Переменная стека
        uint256[] memory squaredArr = new uint256[](_arr.length); // Массив памяти

        for (uint256 i = 0; i < _arr.length; i++) {
            uint256 val = _arr[i]; // Доступ к данным вызовов
            squaredArr[i] = val * val;
            sum += squaredArr[i];
        }

        return sum;
    }
}
