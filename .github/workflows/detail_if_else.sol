// SPDX-License-Identifier:MIT // lisans tanımlama
pragma solidity ^0.8.7; // versiyon

contract IfElse {
    bytes32 private hashedPassword; // solidityde string karşılaştırma olmadığı için stringleri hash içine alarak hashleri karşılaştırırız
    uint256 private loginCount;
                                    // not solidityde böyle şifre tutmamız gerçek değildir çünkü bu şifreye herkes erişebilir sadece örnek
    constructor(string memory _password) { // memory sayesinde değişkeni sadece fonksiyon içinde tutar blockchaine kaydedilmez
        hashedPassword = keccak256(abi.encode(_password)); // keccak256 kriptografik hash fonksiyonudur
    }

    function login(string memory _password) public  returns (bool) {  // public herkesin erişip çalıştırabileceğini gösterir
        if (hashedPassword == keccak256(abi.encode(_password))) {    // karşılaştırırken tekrar keccak ve abi.encode kullanıyoruz
            loginCount++; // şifreler eşleşirse loginCount 1 artacak
            return true;
        } else {
            return false;
        }
        // return (hashedPassword == keccak256(abi.encode(_password) Yukarıdaki if else fazladan gas ve kod satırına eşit aslında böyle bir karşılaştırmayı tek satırda yapabiliriz
    }

    function loginlogin(string memory _password) public view returns (uint256){
        if (hashedPassword == keccak256(abi.encode(_password))){
            return 1;
        }else {
            return 0;
        }
        // return (hashedPassword == keccak256(abi.encode(_password)) ? 1 : 0 ; // tek satırda yukarıdaki iş lemi yaptık
    }

    function loginStatus() public view returns(uint256){
        if(loginCount == 0){
            return 0;
        } else if(loginCount > 0 && loginCount != 1) { // Ve operatörünün true olması için &&'lerin iki tarafındaki ifadelerin de doğru olması gerekmetkedir. || = veya op.
            return 1;
        } else if(loginCount == 1) {
            return 2;
        } else {
            return 3;
        }
    }
} 
