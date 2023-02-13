// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract Inbox { // gelen kutusu kontratı tanımladık
    string public message;

    function Inbox(string initialMessage) public { // depolayacak fonksiyon
        message = initialMessage;
    }

    function setMessage(string newMessage) public{  // mesajları güncellemek için kullanabiliriz
        message = newMessage;
    }

    function getMessage() public view returns(string){  // gösterimi sağlayacak fonksiyon, returns sadece view veya constant olarak işaretlenen fonksiyonlarda kullanılacaktır.
        return message;                                 // Yukarıda string public message olarak bir değişken tanımladığımız için getMessage fonks. gereksizdir.
    }
}

// Fonksiyon Tipleri Not:
// Public: Hesabı olan herkes buna erişebilir ve görüntüleyebilir
// Private:  Özel ve güvenlik için bir şey kullanacaksam Private tipini kullanırım
// view : veriyi değiştirecek misin yoksa sadece görüntüleyecek misin bunun için kullanılır, aynı zamanda constant kelimesi de kullanılabilir.
// pure: verilerin değiştirilemeyeceği aynı zamanda erişim de sağlanayamayacağını belirtir.
// payable: bu değişkeni kullanarak sözleşmeye para göndermeye çalışabileceğimizi gösterir


//example
// immutable örneği
contract Immutable {
    // coding convention to uppercase constant variables
    address public immutable MY_ADDRESS;
    uint public immutable MY_UINT;

    constructor(uint _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }
}
