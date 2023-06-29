// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Merkle tree- древо Меркла или древо хэшей было придумано в 70-ых годах 

//для каждой транзакции считается хэш, каждый хэш нашей траназкции из блока есть листик 
//листом на этом древе могут быть любые данные, которые вместе хранятся
//root 0x12ca113df0903ec2672fd84431bf286c48b225490328eb1874ddf72e1db95853
//"TX3: John -> Mary"
//index 2
//0xdca11aec2d04146b1bbc933b1447aee4927d081c9274fcc6d02809b4ee2e56d8
//0xf49fac8d01d36d5b177c5c485982a90c764e589569706b375f80c1675426fd1c
contract Tree {

    bytes32[] public hashes; //[] наших хэшей
    string[4] transactions = [
        "TX1: Sherlock -> Jojn",
        "TX2: John -> Sherlock",
        "TX3: John -> Mary",
        "TX3: Mary -> Sherlock"
    ];

    constructor() {
        for(uint i = 0; i < transactions.length; i++) {
            hashes.push(makeHash(transactions[i])); //полученный хэш засовываем в наш массив хэшей
        }

        uint count =transactions.length;
        uint offset = 0; //концепция смещения 

        while(count > 0) {
            for(uint i = 0; i < count - 1; i += 2){
                hashes.push(keccak256(
                    abi.encodePacked(
                        hashes[offset + i], hashes[offset + i + 1]
                    )
                ));
            }
            offset += count;
            count = count / 2;
        }
    }

    function verify(string memory transaction, uint index, bytes32 root, bytes32[] memory proof) public pure returns(bool) { //верифицируем наш хэш и узнаем был ли он в нашем древе
//      ROOT

//  H1-2    H3-4

//  [4]     [5]

//H1   H2  H3  H4

//[0]  [1] [2] [3]
//TX1 TX2 TX3 TX4

        bytes32 hash = makeHash(transaction);
        for(uint i = 0; i < proof.length; i++) {
            bytes32 element = proof[i];
            if(index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, element)); //если элемент чётный, берётся элемент по правую сторону
            } else {
                hash = keccak256(abi.encodePacked(element, hash)); //если нечётный берётся элемент по левую сторону
            }
            index = index / 2;
        }
        return hash == root;
    }

    function encode(string memory input) public pure returns(bytes memory) {
        return abi.encodePacked(input);
    }

    function makeHash(string memory input) public pure returns(bytes32) {
        return keccak256(
            encode(input)
        );
    } 
}
