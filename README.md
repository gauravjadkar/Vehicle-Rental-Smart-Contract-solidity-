<div align="center">

# 🚗 Vehicle Rental Smart Contract

### A Decentralized Vehicle Rental Protocol Built with Solidity

<p align="center">

![Solidity](https://img.shields.io/badge/Solidity-0.8.13-363636?style=for-the-badge&logo=solidity)

![Ethereum](https://img.shields.io/badge/Ethereum-EVM-blue?style=for-the-badge&logo=ethereum)

![MIT License](https://img.shields.io/badge/License-MIT-success?style=for-the-badge)

![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

</p>

---

### Secure • Transparent • Decentralized

A smart contract that enables vehicle owners to register vehicles and renters to securely rent them using Ethereum.

Built while learning Solidity and Smart Contract Engineering.

</div>

---

# 📸 Project Preview

## Structures In Systems

![](images/Screenshot%20From%202026-07-04%2014-24-03.png)

---

## Register User
 
![](images/Screenshot%20From%202026-07-04%2014-24-44.png)

---

## Booking Cancellation and Vehicle Updation

![](images/Screenshot%20From%202026-07-04%2014-25-11.png)

---

## Contract Deployment

![](images/Screenshot%20From%202026-07-04%2014-27-26.png)

---

# 📖 Overview

This decentralized Vehicle Rental Smart Contract demonstrates how a traditional rental platform can be transformed into an on-chain protocol.

Users register once using their wallet address.

Vehicle owners list their vehicles.

Renters pay directly into the smart contract.

Funds remain inside the contract until the booking is completed.

The owner receives payment only after completing the booking.

Every action is permanently recorded on-chain.

---

# ✨ Features

## 👤 User Module

- User Registration
- Duplicate User Prevention
- Wallet Based Authentication

---

## 🚗 Vehicle Module

- Register Vehicle
- Update Rental Price
- Remove Vehicle
- Ownership Validation

---

## 📅 Booking Module

- Book Vehicle
- Cancel Booking
- Complete Booking
- Booking Lifecycle
- Availability Management

---

## 💰 Payments

- Secure Ether Payments
- Owner Settlement
- Refund Support
- Exact Payment Validation

---

## 🔒 Security

- Modifiers
- Ownership Checks
- Vehicle Validation
- Input Validation
- Booking Status Validation
- Secure Ether Transfer using `call`

---

# 🏗 Smart Contract Architecture

```text
                 Vehicle Rental Contract
                          │
          ┌───────────────┼───────────────┐
          │               │               │
        Users         Vehicles        Bookings
          │               │               │
          └───────────────┼───────────────┘
                          │
                    Payment Logic
```

---

# 🔄 Booking State Machine

```text
            Available
                 │
                 ▼
             Booked
           /         \
          ▼           ▼
   Completed      Cancelled
          │           │
          └──────┬────┘
                 ▼
            Available
```

---

# ⚙ Contract Components

## Structs

✔ Vehicle

✔ Booking

✔ User

---

## Enum

```solidity
enum BookingStatus{
Pending,
Booked,
Completed,
Cancelled
}
```

---

## Mappings

```solidity
mapping(address=>User)

mapping(string=>Vehicle)

mapping(uint=>Booking)
```

---

## Events

- User Registered
- Vehicle Registered
- Vehicle Booked
- Booking Completed
- Booking Cancelled
- Vehicle Removed
- Price Updated

---

## Modifiers

- onlyRegisteredUser
- onlyOwner
- vehicleAvailable
- vehicleExist
- vehicleCheck
- activeBooking

---

# 🛡 Security Features

✔ Ownership Verification

✔ Vehicle Availability Check

✔ Duplicate Registration Prevention

✔ Booking Validation

✔ Exact Ether Validation

✔ Low-level call()

✔ Access Control

✔ Event Logging

✔ State Validation

---

# 📂 Folder Structure

```text
contracts/
images/
docs/
README.md
LICENSE
.gitignore
```

---

# 🚀 Future Improvements

- ERC20 Payments
- Security Deposits
- Fleet Management
- Vehicle Ratings
- Booking History
- Foundry Tests
- Slither Analysis
- Echidna Fuzzing
- Chainlink Automation
- Gas Optimizations
- Frontend Integration

---

# 📚 Learning Outcomes

This project helped me understand

- Solidity Fundamentals

- Smart Contract Design

- Structs

- Mappings

- Enums

- Modifiers

- Events

- Access Control

- Ether Transfers

- Storage vs Memory

- State Management

- NatSpec Documentation

- Git & GitHub Workflow

---

# 👨‍💻 Author

## Gaurav Jadkar

🎓 Diploma in Computer Technology

### Aspiring

- ⚡ Protocol Engineer

- 🛡 Smart Contract Auditor

- 🌐 Blockchain Developer

- 🔍 Security Researcher

### Connect

GitHub

https://github.com/gauravjadkar

LinkedIn

www.linkedin.com/in/gaurav-jadkar-55271331b

---

# ⭐ Star this repository

If you found this project useful, consider giving it a ⭐.

Feedback and suggestions are always welcome.

---

<div align="center">


