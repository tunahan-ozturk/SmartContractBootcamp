// SPDX-License-Identifier:MIT // lisans tanımlama
pragma solidity ^0.8.7; // versiyon

contract Loops{
    uint256[15] public numbers0; // array oluşturduk
    uint256[15] public numbers1; // array oluşturduk

    function listByFor() public{ // for için bir fonksiyon başlangıcı
        uint256[15] memory nums = numbers0; // local değişkeni global değişkene eşitledik ve bunu memoryde tuttuk

        for(uint256 i = 0; i < nums.length; i++){ // for döngüsünün şartlarını yazdık
            // if(i==9) continue;  // 9. elemana geldiğimizde continue yapar. Bir sonraki indexe geçer
            // if(i==10) break;   // Break sayesinde şart sağlandığında loop'u kırmayı sağlar.
            nums[i] = i; 
        }

        numbers0 = nums;
    }

    function getArr0() public view returns(uint256[15] memory){  // arrayi görüntüleyebilmek için fonksiyon
        return numbers0;
    }

    function listByWhile() public{
        uint256 i = 0;
        while(i < numbers1.length){  // akıllı kontratlarda while kullanmak çokta efektif değildir
            numbers1[i] = i; 
            i++;
        }
    }
     function getArr1() public view returns(uint256[15] memory){  // arrayi görüntüleyebilmek için fonksiyon
        return numbers1;

    }
}
