// SPDX-License-Identifier:MIT // lisans tanımlama
pragma solidity ^0.8.7; // versiyon

contract Constructor{

address public immutable owner; // sonradan değiştirilebilir fakat tek bir kere değer girilebilir

    constructor(){ // sözleşme aktif olduktan sonra 1 kere çalışır
        owner = msg.sender; // mesajı yollayan adresi alır
    }
}
