// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

// land registration.
// buyer buys the land.

contract landRegi{

  uint counter = 1; // for landId

  struct land{
    string location;
    uint latitude;
    uint longitude;
    uint size;
    string landType;
    address payable owner;
    uint landId;
    uint price; // in wel and getting price only for size one
    uint dailyPrice; // in wel and getting daily price
    uint totalPrice; // calculating the total price of the land using the single price
    uint currentTotalPrice; // current total price for the land
    address buyer;
  }

  land[] public lands;

  // events.
  event registered(string location, string landType, uint landId, uint totalPrice, address owner);
  event bought(uint landId, address buyer);

  // creating function registerland - to land registration.
  function registerLand(string memory _location, uint _latitute, uint _longitude, uint _size, string memory _landType, uint _price) public{

    require(_price > 0, "Price should be greater than 0.");
    // enter land details inculding who is owner
    land memory newland;
    newland.location = _location;
    newland.latitude = _latitute;
    newland.longitude = _longitude;
    newland.landType = _landType;
    newland.size = _size;
    newland.price = _price * 10**18; // converting wels to ether
    newland.totalPrice = newland.size * newland.price;
    newland.owner = msg.sender;
    newland.landId = counter;
    lands.push(newland);
    counter++;

    emit registered(_location, _landType, newland.landId, newland.totalPrice, msg.sender);
  }

  // creating function getBalance -  to display the current balance in the contract 
  function getDetails(uint _landId) public view returns (string memory, string memory, uint, uint, uint, address, address){
    return  (lands[_landId - 1].location, lands[_landId - 1].landType, lands[_landId - 1].size, lands[_landId - 1].totalPrice, lands[_landId - 1].currentTotalPrice, lands[_landId - 1].owner, lands[_landId - 1].buyer);
  }

  // creating function buy - for buyer buys the land.
  function buy(uint _landId) payable public{

    // owner cannot buy his/her own land
    require(lands[_landId - 1].owner != msg.sender,"owner cannot buy his/her own land.");

    // players must invest astleast 1 ether
    require(lands[_landId - 1].currentTotalPrice == msg.value,"Buyer buy price must be same as the price of owner");


    lands[_landId - 1].buyer = msg.sender;
    lands[_landId - 1].owner.transfer(lands[_landId - 1].currentTotalPrice);

    emit bought(_landId, msg.sender);
  }

    function updatePrice(uint _landId, uint _price) public{
        lands[_landId - 1].dailyPrice = _price * 10**18;
        lands[_landId - 1].currentTotalPrice = lands[_landId - 1].size * lands[_landId - 1].dailyPrice;
        require(keccak256(abi.encodePacked((lands[_landId -1].landType))) == keccak256(abi.encodePacked(("farming"))));
        lands[_landId -1].currentTotalPrice = 3 * lands[_landId - 1].currentTotalPrice; 
       
    }
}
