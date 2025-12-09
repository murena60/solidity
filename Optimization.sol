//ОСНОВНОЙ КОНТРАКТ
// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

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

    function processArray(uint256[] calldata _arr) external pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < _arr.length; i++) {
            sum += _arr[i];
        }
        return sum;
    }
}
// ОПТИМИЗИРОВАННЫЙ КОНТРАКТ
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMyContract {
    function setData(uint256 _data) external;
    function getData() external view returns (uint256);
    function processArray(uint256[] calldata _arr) external pure returns (uint256);
}

contract MyContract is IMyContract {
    uint256 public storedData; 

    event DataUpdated(uint256 newData); // Событие  изменения данных

    
    function setData(uint256 _data) external override {
        storedData = _data;
        emit DataUpdated(_data); 
    }

   
    function getData() external view override returns (uint256) {
        return storedData;
    }

    function processArray(uint256[] calldata _arr) external pure returns (uint256) {
        uint256 sum = 0;
        uint256 length = _arr.length;//создание локальной переменной чтобы повторно не читать длину массива
        for (uint256 i = 0; i < length; i++) {
            sum += _arr[i];
        }
        return sum;
    }
}

//основной контракт 75 000 газа
//оптимизироанный контракт 74 000 газа
