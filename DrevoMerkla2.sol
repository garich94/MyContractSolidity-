// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// Merkle three

//        Sherlock+John+mary+Lestrade
//                      6

// Sherlock+John        Mary+Lestrade
//      4                    5

// Sherlock     John    Mary    Lestrade
//    0           1       2         3

contract Tree {
    bytes32[] public hashes; //это массив всех хэшей нашего древа
    string[4] heroes = ["Sherlock", "John", "Mery", "Lestrade"]; //массив наших героев

    constructor() {
        for(uint i = 0; i < heroes.length; i++) { //цикл для подсчёта хэша для каждого элемента нашего массива героев
            hashes.push(keccak256(abi.encodePacked(heroes[i])));
        }

        uint n = heroes.length;
        uint offset = 0;
        while (n > 0) {
            for(uint i = 0; i < n - 1; i += 2) {
                bytes32  newHash = keccak256(abi.encodePacked(
                    hashes[i + offset], hashes[i + offset + 1]
                ));
                hashes.push(newHash); //новый получившийся хэш засовываем в наш массив с хэшами
            }
            offset += n;
            n = n / 2;
        }
    }

    function getRoot() public view returns(bytes32) { //узнать корень нашего дерева
        return hashes[hashes.length - 1];
    }
    //root 0xba4cafcfd0bf86398b787af651a6c92dc3f4c78ef9616cb0d1ba013bef8465e5
    //Mary hash 0x2c725b70dd7ed21fcaaa519f59e7b63656ca4ea26a8ae5a5945e4b13b0eb3721
    //index 2
    //0x692a919868d934115403f55a7180c31c69596c5edd8ac2cbc02d20416f6dad24
    //0xde7f414c72243bd2825d19efcd975293549b6bdba5bf28a2bd2b8a4bcdd52cf3


    function verify(bytes32 root, bytes32 leaf, uint index, bytes32[] memory proof) public pure returns(bool) {  //функция которая проверяет в нашем блоке содержится какой-то из элементов
        bytes32 hash = leaf;
        for(uint i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if(index % 2 == 0) {
                hash = keccak256(abi.encodePacked(
                    hash, proofElement
                ));
            } else {
                hash = keccak256(abi.encodePacked(
                    proofElement, hash
                ));
            }
            index = index / 2;
        }

        return hash == root;
    }
}