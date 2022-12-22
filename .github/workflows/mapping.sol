// SPDX-License-Identifier:MIT // lisans tanımlama
pragma solidity ^0.8.7; // versiyon

contract Mapping{
    mapping(address => bool) public registered;
    mapping(address => int256) public favNums;

    function register(int256 _favNum) public{
        //require(!registered[msg.sender],"Kullanıcınız daha önce kayıt yaptı"); // default gelen boolean(false) durumunu giriş yapıldıktan sonra true cevabı alınınc tekrar çağırılmasın diye require kullanırım
        require(!isRegistered(), "Kullaniciniz daha once kayit yapti");
        registered[msg.sender] = true; // kayıt olan kullanıcının kayıt olduğuna dair göstergeyi true yapar
        favNums[msg.sender] = _favNum;
    }

    function isRegistered() public view returns(bool){ // kullanıcının kayıtlı olup olmadığını sorgulayan fonks.
        return registered[msg.sender];
    } 

    function deleteRegistered() public {
        require(isRegistered(), "Kullaniciniz kayitli degil");
        delete(registered[msg.sender]); // kayıtlı kullanıcıyı silmek için 
        delete(favNums[msg.sender]); // kayıtlı favori sayıyı siler
    }

}

contract NestedMapping{
    mapping(address => mapping(address => uint256)) public debts; // mappingde value kısmını da bir mapping şeklinde yapabiliriz. Örneğin bana borçlu kişilerin borç miktarlarını sorgularken

    function incDebt(address _borrower, uint256 _amount) public{
        debts[msg.sender][_borrower] += _amount; // borçlu kullanıcının borcunu arttırmış oldu
    }
     function decDebt(address _borrower, uint256 _amount) public{
        require(debts[msg.sender][_borrower] >= _amount, "Not enough debt."); // Kullanıcını borcu olmayıp düşürmek isterse hata dönmesin diye yazılan require komutu
        debts[msg.sender][_borrower] -= _amount; // borçlu kullanıcının borcunu azaltmış oldu
    }

    function getDebt(address _borrower) public view returns(uint256) { // Borçları görüntülemek için kullandığımız fonksiyon
        return debts[msg.sender][_borrower]; 
    }

}
