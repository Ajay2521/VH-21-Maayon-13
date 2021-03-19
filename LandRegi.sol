// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

// land registration.
// buyer buys the land.

contract landRegi{

  uint counter = 1; // for landId

  struct land{
    string location;
    uint size;
    address payable owner;
    uint landId;
    uint price; // in wel
    uint totalPrice;
    address buyer;
  }

  land[] public lands;

  // events.
  event registered(string location, uint landId, uint totalPrice, address owner);
  event bought(uint landId, address buyer);

  // creating function registerland - to land registration.
  function registerLand(string memory _location, uint _size, uint _price) public{

    require(_price > 0, "Price should be greater than 0.");
    // enter land details inculding who is owner
    land memory newland;
    newland.location = _location;
    newland.size = _size;
    newland.price = _price * 10**18; // converting wels to ether
    newland.totalPrice = newland.size * newland.price;
    newland.owner = msg.sender;
    newland.landId = counter;
    lands.push(newland);
    counter++;

    emit registered(_location, newland.landId, newland.totalPrice, msg.sender);
  }

  // creating function getBalance -  to display the current balance in the contract 
  function getDetails(uint _landId) public view returns (string memory, uint, uint, address, address){
    return  (lands[_landId - 1].location, lands[_landId - 1].size, lands[_landId - 1].totalPrice, lands[_landId - 1].owner, lands[_landId - 1].buyer);
  }

  // creating function buy - for buyer buys the land.
  function buy(uint _landId) payable public{

    // owner cannot buy his/her own land
    require(lands[_landId - 1].owner != msg.sender,"owner cannot buy his/her own land.");

    // players must invest astleast 1 ether
    require(lands[_landId - 1].totalPrice == msg.value,"Buyer buy price must be same as the price of owner");

    lands[_landId - 1].buyer = msg.sender;

    emit bought(_landId, msg.sender);
  }

}
