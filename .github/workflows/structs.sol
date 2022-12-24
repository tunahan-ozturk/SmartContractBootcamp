// SPDX-License-Identifier:MIT // lisans tanımlama
pragma solidity ^0.8.7; // versiyon

contract StructEnum {


    enum Status{  // Durumları göstermek için enum kullanırız
        Taken, // 0
        Preparing, // 1
        Boxed, // 2
        Shipped // 3
    }

    struct Order {  // struct ile siparis
        address customer;
        string zipCode;
        uint256[] products;
        Status status;
    }

    Order[] public orders;
    address public owner;

    constructor(){
        owner = msg.sender; // kontratı oluşturan kişiyi yönetici olarak göstermek için
    }

    function createOrder(string memory _zipCode, uint256[] memory _products) external returns(uint256) { // array olarak aldığım için memory olarak kaydettik. Adresi belirtmememizin sebebi zaten sender kısmından erişebildiğimiz için
        require(_products.length > 0, "No Products."); // products da siparişin kontrolü
        // string,struct,byte fonksiyona paramtere olarak gönderilirken lokasyon belirtilmesi lazım / memory gibi

        Order memory order; 
        order.customer = msg.sender; 
        order.zipCode = _zipCode;
        order.products = _products;
        order.status = Status.Taken;
        orders.push(order); // lokal olarak oluşturduğumuz order arrayini değişkene ekledik, blockchaine kaydettik

        // orders.push(
        //     Order({    // structs oluşturmak için bir diğer seçenek
        //         customer: msg.sender,
        //         zipCode: _zipCode,
        //         products: _products,
        //         status: Status.Taken
        //     })
        // );

        // orders.push(Order(msg.sender, _zipCode, _products, Status.Taken));  // en kısayol struct
        
        
        return orders.length - 1; // 

    }

    function advanceOrder(uint256 _orderId) external{
        require(owner == msg.sender, "You are not authorized,");
        require(_orderId < orders.length, "Not a valid order id.");

        Order storage order = orders[_orderId];  // storage olarak işaretlediğimiz için fonksiyon bitse bile devam edecek
        require(order.status != Status.Shipped, "Order is already shippoed");

        if (order.status == Status.Taken) {
            order.status = Status.Preparing;
        } else if (order.status == Status.Preparing) {
            order.status = Status.Boxed;
        } else if (order.status == Status.Boxed) {
            order.status = Status.Shipped;
        }

    }
    function updateZip(uint256 _orderId, string memory _zip) external {  // siparişi güncelleme
        require(_orderId < orders.length, "Not a valid order id");
        Order storage order = orders[_orderId];
        require(order.customer == msg.sender, "You are not the owner of the order.");
        order.zipCode = _zip;
    }

}
