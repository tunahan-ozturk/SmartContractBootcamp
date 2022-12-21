// SPDX-License-Identifier:MIT // lisans tanımlama
pragma solidity ^0.8.7; // versiyon

contract Counter{
    uint public count;

    function inc() external { // sonradan kullanım için external kullandık
        count += 1; //ekleme yapar
    }

    function dec() external { // sonradan kullanım için external kullandık
        count -= 1; // çıkartma yapar
    }

}
