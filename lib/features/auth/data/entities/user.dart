/*
    "data": {
        "id": "68cee50bf07df91f23b3698e",
        "email": "zometh@yopmail.com",
        "firstName": "mouhamed",
        "lastName": "diop",
        "username": "zometh",
        "address": "Sénégal",
        "role": "MEMBER",
        "status": "ACTIVE",
        "subscriptionPlan": "FREE"
    },
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OGNlZTUwYmYwN2RmOTFmMjNiMzY5OGUiLCJyb2xlSWQiOiI2OGM4MTY4MGQ3MmNiZmE0ZDdhOTEwNDAiLCJpYXQiOjE3NTk1MDM2MjMsImV4cCI6MTc2NzI3OTYyM30.PW1TzPwKJZNw_dhZgRkFgMt8_70I3mE7Wq7QOH9pBWA"
}*/
class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String username;
  final String address;
  final String role;
  final String status;
  final String subscriptionPlan;
  final String accessToken;

  User({
    required this.id,
    required this.email,
     this.firstName,
    required this.lastName,
     required this.username,
    required this.address,
    required this.role,
    required this.status,
    required this.subscriptionPlan,
    required this.accessToken,
  });
  }