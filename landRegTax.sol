// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

// land registration.
// buyer buys the land.

contract landRegi{

  uint counter = 1; // for landId

  struct land{
    string location;
    uint lat_long;
    uint size;
    string landType;
    address payable owner;
    uint landId;
    uint price; // in wel and getting price only for size one
    uint dailyPrice; // in wel and getting daily price
    uint totalPrice; // calculating the total price of the land using the single price
    uint taxPrice;
    uint currentTotalPrice;
    address buyer;
  }

  land[] public lands;

  // events.
  event registered(string location, string landType, uint landId, uint totalPrice, address owner);
  event bought(uint landId, address buyer, uint currentTotalPrice);

  // creating function registerland - to land registration.
  function registerLand(string memory _location, uint _lat_long, uint _size, string memory _landType, uint _price) public{

    require(_price > 0, "Price should be greater than 0.");
    // enter land details inculding who is owner
    land memory newland;
    newland.location = _location;
    newland.lat_long = _lat_long;
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

  // creating function getLandDetails -  to display the land details in the contract 
  function getLandDetails(uint _landId) public view returns (string memory, string memory, uint, uint, address, address){
    return  (lands[_landId - 1].location, lands[_landId - 1].landType, lands[_landId - 1].size, lands[_landId - 1].totalPrice,  lands[_landId - 1].owner, lands[_landId - 1].buyer);
  }


  // creating function getLandDetails -  to display the land details in the contract 
  function getPayDetails(uint _landId) public view returns ( uint, uint, uint, uint){
    return  (lands[_landId - 1].totalPrice, lands[_landId - 1].dailyPrice, lands[_landId - 1].taxPrice, lands[_landId - 1].currentTotalPrice);
  }
 
  // creating function buy - for buyer buys the land.
  function buy(uint _landId) payable public{

    // owner cannot buy his/her own land
    require(lands[_landId - 1].owner != msg.sender,"owner cannot buy his/her own land.");

    // players must invest astleast 1 ether
    require(lands[_landId - 1].currentTotalPrice == msg.value,"Buyer buy price must be same as the price of owner");


    lands[_landId - 1].buyer = msg.sender;
    lands[_landId - 1].owner.transfer(lands[_landId - 1].currentTotalPrice);

    emit bought(_landId, msg.sender, lands[_landId-1].currentTotalPrice);

  }

    function updatePrice(uint _landId, uint _price) public{
        lands[_landId - 1].dailyPrice = _price; 
    }
    
    function calTax(uint _landId) public{
        if(lands[_landId - 1].dailyPrice <= 5){
        lands[_landId - 1].taxPrice = 2 * lands[_landId - 1].dailyPrice;
        lands[_landId - 1].currentTotalPrice = ((lands[_landId - 1].size * lands[_landId - 1].dailyPrice) + lands[_landId - 1].taxPrice);
        }else if((lands[_landId - 1].size > 5) && (lands[_landId - 1].size <= 10) && (lands[_landId - 1].dailyPrice > 5 ) && (lands[_landId - 1].dailyPrice <= 10 )){
            lands[_landId - 1].taxPrice = 2 * lands[_landId - 1].dailyPrice;
            lands[_landId - 1].currentTotalPrice = ((lands[_landId - 1].size * lands[_landId - 1].dailyPrice) + lands[_landId - 1].taxPrice);
        }
        else if((lands[_landId - 1].size > 10) && (lands[_landId - 1].dailyPrice <= 5 )){
            lands[_landId - 1].taxPrice = 3 * lands[_landId - 1].dailyPrice;
            lands[_landId - 1].currentTotalPrice = ((lands[_landId - 1].size * lands[_landId - 1].dailyPrice) + lands[_landId - 1].taxPrice);
        }
        else{
            lands[_landId - 1].taxPrice = 5 * lands[_landId - 1].dailyPrice;
            lands[_landId - 1].currentTotalPrice = ((lands[_landId - 1].size * lands[_landId - 1].dailyPrice) + lands[_landId - 1].taxPrice);
        }   
        require(keccak256(abi.encodePacked((lands[_landId -1].landType))) == keccak256(abi.encodePacked(("farming"))));
        lands[_landId -1].currentTotalPrice = (3 * lands[_landId - 1].currentTotalPrice) * 10 ** 18 ;
    }
}
