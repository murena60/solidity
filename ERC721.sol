// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./IERC721Metadata.sol";
import "./IERC721Receiver.sol";
import "./Strings.sol";

contract ERC721 is IERC721Metadata {
    using Strings for uint;
    string public name;
    string public symbol;
    mapping(address => uint) _balances; //сколько нфт на балансе
    mapping(uint => address) _owners; //владелец нфт
    mapping(uint => address) _tokenApprovals; //разрешение на управление нфт
    mapping(address => mapping(address => bool)) _operatorApprovals; //конкретный адрес может управлять нфт с адреса владельца

    modifier _requireMinted(uint tokenId) {
        require(_exists(tokenId), "not minted");
        _; //нужно проверить введен ли токен в оборот
    }

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function balanceOf(address owner) public view returns (uint) {
        require(owner != address(0), "zero address"); //проверяем что адрес не пустой
        return _balances[owner]; //возвращаем баланс адреса
    }

    function _exists(uint tokenId) internal view returns (bool) { //проверка что токен существует
        return _owners[tokenId] != address(0);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not an owner or approved"); //проверяем что адрес может переводить токен
        _safeTransfer(from, to, tokenId); //переводим токен
    }

    function _baseURI() internal pure virtual returns (string memory) {
        return "";
    }

    function tokenURI(uint tokenId) public view _requireMinted(tokenId) returns (string memory) {
        string memory baseURI = _baseURI(); //получаем базовую часть URI
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : ""; //возвращаем полный URI))
    }

    function approve(address approved, uint256 tokenId) public {
        address owner = ownerOf(tokenId); //получаем адрес владельца
        require(owner == msg.sender || isApprovedForAll(owner, msg.sender), "not an owner "); //проверяем что адрес может переводить токен

        require(approved != owner, "cannot approve to self");
        _tokenApprovals[tokenId] = approved; //добавляем адрес to в список разрешенных
        emit Approval(owner, approved, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not an owner or approved");
        _transfer(from, to, tokenId);
    }

    function ownerOf(uint256 tokenId) public view _requireMinted(tokenId) returns (address) {
        return _owners[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        //проверяем может ли оператор распоряжаться всеми токенами владельца или не может
        return _operatorApprovals[owner][operator];
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        return _tokenApprovals[tokenId];
    }

    function burn(uint256 tokenId) public virtual { //проверяем что тот кто пытается вывести токен из оборота имеет на это право
        require(_isApprovedOrOwner(msg.sender, tokenId), "not an owner ");
        address owner = ownerOf(tokenId); //получаем адрес владельца

        delete _tokenApprovals[tokenId]; //удаляем токен из списка разрешенных
        _balances[owner]--; //уменьшаем баланс владельца на 1
        delete _owners[tokenId]; //удаляем токен из списка владельцев

    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(msg.sender, to, tokenId), "non ERC721 receiver");
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "to cannot be zero");
        require(!_exists(tokenId), "already exists");
        _owners[tokenId] = to;
        _balances[to]++;

    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId) private returns (bool) {
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, "") returns (bytes4 ret) {
                return ret == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) { //получатель не может принять интерфейс 721 и у него нет нужной функции
                if (reason.length == 0) {
                    revert("non erc721 receiver");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "not an owner");
        require(to != address(0), "to cannot be zero"); //проверка на нулевой адрес

        _beforeTokenTransfer(from, to, tokenId);

        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to; //записываем нового владельца

        emit Transfer(from, to, tokenId);
        _afterTokenTransfer(from, to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}

    function _afterTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId); //устанавливаетм кто владет токеном (варианты владения)

        require(
            spender == owner || //перевод делает владелец токена
            isApprovedForAll(owner, spender) ||
            getApproved(tokenId) == spender, //перевод делает тот кому дали права на этот токен
            "not an owner or approved"
        );
    }

    function _safeTransfer(address from, address to, uint256 tokenId) internal {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId), "non erc721 receiver "); //проверка может ли адрес владеть нфт
    }

}
