
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
 
/// @title Decenterlized Vehicle Rental System
/// @author Gaurav Sanjay Jadkar
/// @notice Enables users to register,list vehicles,book rentals,
/// cancel bookings,process refund and return rented vehicles.
/// @dev This contracts manages vehicle listings, booking lifecycle,
/// escrow payments, and refund operations using Ether. 

contract vehicleRental{

/// @notice stores the total number of bookings 
   uint id=1;
 
/// @notice Represent the Booking Status
    enum Bookingstatus{
      Pending,
      Booked,
      Completed,
      Cancelled
     }
  
  // Structure Section 
  /// @notice Represents Registered Vehicle 
    struct  Vehicle{
        string  veh_no;
        string veh_name;
        uint price;
        bool availability;
        uint seating_cap;
        address  owner;
    }
  /// @notice Represents Booking 
   struct Booking{
     uint book_id;
     uint  rent_time;
     uint return_time;
     uint total_amt;
     string veh_no;
     address renter;
     Bookingstatus status;  
   }
   /// @notice Represents Registered User
   struct User{
    address renter;
    string name;
    uint age;
    uint phone_no;
   }
  
  
  // Mapping Section

  /// @notice Stores all the registered vehicles using the vehicle no as key
  mapping(string=>Vehicle) public vehicles;
  /// @notice Stores all the bookings using the booking id as key
  mapping(uint=>Booking) public bookings;
  /// @notice Stores all the users using the address as key
  mapping(address=>User) public users;
  
  // Modifiers Section

  /// @notice Ensures the User is Registered 
  modifier onlyRegisteredUser(){
     require(users[msg.sender].renter!=address(0),"Register First");
     _;
  }
  /// @notice Ensures the Only Owner is accessing
  modifier onlyOwner(string memory _vehicleNo ){
    require(vehicles[_vehicleNo].owner==msg.sender,"You are Not Owner of Vehicle");
  _;
  } 
  /// @notice Ensures the Vehicle is not registered already
  modifier vehicleExistenceCheck(string memory _vehicleNo ){
    require(vehicles[_vehicleNo].owner==address(0),"Vehicle already exists");
    _;
  }
  /// @notice Ensures the User is not registered already
 modifier userExist() {
   require(users[msg.sender].renter == address(0), "user already exists");
   _;
  }
  /// @notice Ensures the Vehicle is available for booking
  modifier vehicleAvailable(string  memory _vehicleNo){
    require(vehicles[_vehicleNo].availability, "vehicle already booked");
    _;
  }
  /// @notice Ensures the booking is active
  modifier activeBooking(uint _bookingId){
    require(bookings[_bookingId].status==Bookingstatus.Booked,"Booking is not active");
    _;
  }
  /// @notice Ensures the Vehicle is registered already
  modifier vehicleCheck(string memory _vehicleNo){
    require(vehicles[_vehicleNo].owner!=address(0),"Vehicle doesn't Exists");
    _;
  }

// Function Section

/// @notice Registers New User
/// @param _name is name of User
/// @param _age is age of User
/// @param _phone_no is phone number of User
  function addUser(string memory _name, uint _age, uint _phone_no) userExist external{
    require(bytes(_name).length>0,"Invalid Name");
    require(_age>0,"Invalid age");
    require(_phone_no>0,"Invalid Number");
     users[msg.sender] = User(msg.sender, _name, _age, _phone_no);
     emit userRegistered(msg.sender,_name);
  }

/// @notice Registers New Vehicle
/// @param _vehicleName is name of vehicle
/// @param _price is Price per hour of vehicle 
/// @param _capacity is Seating capacity of vehicle
/// @param _vehicleNo is Vehicle Number  
  function addVehicle(string memory _vehicleName, uint _price, uint _capacity, string memory _vehicleNo) vehicleExistenceCheck(_vehicleNo) external{ 
    require(bytes(_vehicleName).length > 0, "Invalid vehicle name");
    require(bytes(_vehicleNo).length > 0, "Invalid vehicle number");
    require(_price > 0, "Invalid price");
    require(_capacity > 0, "Invalid capacity");
    vehicles[_vehicleNo]=Vehicle(_vehicleNo,_vehicleName,_price,true, _capacity, msg.sender);
    emit vehicleRegistered(msg.sender, _vehicleNo);
  }

/// @notice Books the Vehicle 
/// @param _vehicleNo to book vehicle 
/// @param _rent_time is rent timing for booking Vehicle
/// @param _return_time is returning timing for booking Vehicle
  function bookVehicle(string memory _vehicleNo,uint _rent_time,uint _return_time) onlyRegisteredUser vehicleAvailable(_vehicleNo) vehicleCheck(_vehicleNo) external payable{
    Vehicle storage vehicle=vehicles[_vehicleNo];
    require(msg.sender!=vehicle.owner,"cannot book your own vehicle");
    require(_return_time>_rent_time, "minimum duration required");
    require(_rent_time>0,"Should be Greater than 0");
    require(_return_time>0,"Should be Greater than 0");
         uint duration=(_return_time-_rent_time)/3600;
    require(duration>=1,"Minimun 1 hour required ");
    require(msg.value == vehicle.price*duration, "send exact amount");
    vehicle.availability = false;
    bookings[id] = Booking(id,_rent_time,_return_time,msg.value,_vehicleNo,msg.sender,Bookingstatus.Booked);
    emit vehicleBooked(msg.sender,_vehicleNo,id);
    id++;
    
  }

/// @notice Booking Completed  of Vehicle
/// @notice Accessed by the Owner of Vehicle
/// @param _bookingId for the Completion of booking
  function bookingCompleted(uint _bookingId) onlyOwner(bookings[_bookingId].veh_no) activeBooking(_bookingId) public {
    Vehicle storage vehicle = vehicles[bookings[_bookingId].veh_no];
    Booking storage booking = bookings[_bookingId];
    vehicle.availability=true;
    (bool success,)=payable(vehicle.owner).call{value:booking.total_amt}("");
    require(success,"Unsuccessfull payment");
    booking.status=Bookingstatus.Completed;
    emit bookCompleted(booking.renter, booking.veh_no, _bookingId);
    
  }

/// @notice Booking Cancellation Of Vehicle
/// @param _bookingId for the  Cancellation of booking 
  function cancelBooking(uint _bookingId) onlyRegisteredUser activeBooking(_bookingId) public {
    Booking storage booking = bookings[_bookingId];
    require(booking.renter==msg.sender,"You have no bookings");
    uint refund = booking.total_amt;
    require(booking.rent_time > block.timestamp,"Booking already started");
      vehicles[booking.veh_no].availability=true;
      (bool success,)=payable(bookings[_bookingId].renter).call{value:refund}("");
      require(success,"Return Failed");
      booking.status=Bookingstatus.Cancelled;
      emit bookingCancelled(_bookingId, booking.veh_no, booking.renter);
   
   
  }

/// @notice Updating the Vehicle Price
/// @param _veh_no is Vehicle Number for changing the Price
/// @param _price is New price to change  
  function updateVehiclePrice(string  memory _veh_no,uint _price) onlyOwner(_veh_no) vehicleCheck(_veh_no) public {
     vehicles[_veh_no].price=_price;
     emit priceUpdated(_veh_no, _price);
  }

/// @notice Removing the Vehicle 
/// @param _veh_no is Vehicle Number want to Remove Vehicle 
  function removeVehicle(string memory _veh_no) onlyOwner(_veh_no) vehicleCheck(_veh_no) public {
    require(vehicles[_veh_no].availability,"Vehicle Currently Booked");
    delete(vehicles[_veh_no]);
    emit vehicleRemoved(_veh_no);
  }


// Event Section

/// @notice Emitted when user is registered
/// @param renter is user address of registered user
/// @param name is user name of registered user
  event userRegistered(
    address indexed renter,
    string name
  );

/// @notice Emitted when vehicle is registered
/// @param owner is Vehicle owner address of Registered Vehicle
/// @param vehicleNo is Vehicle Number of Registered Vehicle
  event vehicleRegistered(
    address indexed owner,
    string indexed vehicleNo
  );

/// @notice Emitted when vehicle is Booked
/// @param renter is address of user booked vehicle
/// @param vehicleNo is vehicle number of booked vehicle
/// @param book_id is booking id of Booking record
  event vehicleBooked(
    address indexed renter,
    string vehicleNo,
    uint indexed book_id
  );

/// @notice  Emitted when Booking is Completed
/// @param renter is address of user
/// @param vehicleNo is vehicle number of vehicle
/// @param book_id is booking Id
  event bookCompleted(
    address renter,
    string vehicleNo,
    uint indexed book_id
  );

/// @notice Emitted when Booking is Cancelled
/// @param book_id is Booking Id
/// @param vehicleNo is vehicle number of vehicle
/// @param renter is address of user
  event bookingCancelled(
    uint indexed book_id,
    string vehicleNo,
    address renter
  );

/// @notice Emitted when Vehicle is Removed
/// @param vehicleNo is vehicle number of vehicle
  event vehicleRemoved(
    string indexed vehicleNo
  );

/// @notice Emitted when Vehicle Price is Updated
/// @param vehicleNo is vehicle number of vehicle
/// @param price is Updated Price of Vehicle
  event priceUpdated(
    string indexed vehicleNo,
    uint price
  );
  
  

  
}