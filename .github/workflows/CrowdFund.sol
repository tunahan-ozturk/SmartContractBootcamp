// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IERC20.sol";

contract CrowdFund{
    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint indexed id, address indexed caller, uint amount);

    struct Campaign{
        address creator;  // kampanyayı oluşturan
        uint goal;        // kampanyada ulaşılan miktar
        uint pledged;     // taahhüt
        uint32 startAt;   // Başlangıç zamanı
        uint32 endAt;     // Bitiş zamanı
        bool claimed;     // Eğer kampanya başarılı olursa jetonların talep edilmesi için bool oluşturduk
    }

    IERC20 public immutable token; // Değiştirilemez olarak token adında IERC20 tanımladık
    uint public count;
    mapping(uint => Campaign) public campaigns;  // Campaign için bir mapping oluşturdum ve public yaparak değerlerine erişebileceğim
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token) {  // sözleşmenin başlangıcında tokeni tanımladık
        token = IERC20(_token);
    }


    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external{
    
        require(_startAt >= block.timestamp, "start at < now"); // başlangıç zaamanı şimdiden geç olmalı
        require(_endAt >= _startAt, "End at < start at");        // bitiş zamanı başlangıç zamanından geç olmalı
        require(_endAt <= block.timestamp + 90 days, "end at > max duration"); // bitiş zaamanı 90 günden az olmalı

        count += 1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }


    function cancel(uint _id) external{ // kampanya başlamadıysa yaratıcı iptal edebilecektir
        Campaign memory campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "not creator"); // mesajı yollayan kampanyanın yaratıcısı olmalıdır aksi takdirde iptal olmaz
        require(block.timestamp < campaign.startAt, "started");  // başlangıç zamanından önce olmalı iptalin gerçekleşmesi için
        delete campaigns[_id];
        emit Cancel(_id);

     }

    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, " not started");
        require(block.timestamp <= campaign.endAt, "ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this),_amount); // token.transferFrom sayesinde mesajı yollayan adresten, kampanya adresine , amount kadar miktar aktarılır.

        emit Pledge(_id, msg.sender, _amount);
       
    } 
    function unpledge(uint _id, uint _amount) external {    // üstteki pledge ve unpledge sayesinde kullanıcı kampanya sırasında değişiklik yapabilecektir
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "ended"); 

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender,_amount);

        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim(uint _id) external{
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator"); // bu isteği yollayanın kampanyanın yaratıcısı olması gerekmektedir
        require(block.timestamp > campaign.endAt, "not ended"); // kampanya bitmeden bağış toplanamaz
        require(campaign.pledged >= campaign.goal,"pledged < goal"); // taahhüt edilen miktarın toplanandan büyük ya da eşit olması lazım
        require(!campaign.claimed, "claimed"); // zaten claim edilmemiş olması lazım

        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged); // zaten yukarıdaki şartlar doğrultusunda mesajı yollayanın yaratıcı olduğunu biliyoruz

        emit Claim(_id);

    }

    function refund(uint _id) external{  // eğer kampanya başarısız olursa bu fonksiyon çalışıp toplanan bağışlar geri iade edilecek
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, ":(("); // ulaşılan miktar taahhüt edilenden az ise gerçekleşir

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);

    }

}
