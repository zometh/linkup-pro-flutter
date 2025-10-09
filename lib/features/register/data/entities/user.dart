/*
import { IsEmail, IsNotEmpty, IsOptional, IsString, MinLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RegisterDto {
  @ApiProperty({ example: 'user@email.com' })
  email: string;

  @ApiProperty({ example: 'password123' })
  password: string;

  @ApiProperty({ example: 'username' })

  username: string;

  @ApiPropertyOptional({ example: 'John' })

  firstName?: string;

  @ApiPropertyOptional({ example: 'Doe' })
 
  lastName?: string;

  @ApiPropertyOptional({ example: '123 rue de Paris' })

  address?: string;

  @ApiPropertyOptional({ example: 'FREE' })

  plan?: string;

  @ApiPropertyOptional({ example: 'MEMBER' })

  role?: string;
}

*/
class User {
  final String email;
  final String password;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? plan;
  final String? role;
  final String subscriptionPlan;

  final String? id;

  User({
    required this.email,
    required this.password,
    required this.username,
    this.firstName,
    this.lastName,
    this.address,
    this.plan,
    this.role,
    required this.subscriptionPlan,

    this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      address: json['address'],
      role: json['role'],
      subscriptionPlan: json['subscriptionPlan'],
    
      password: json['password'] ?? '', // Password might not be returned from API
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'username': username,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (address != null) 'address': address,
      if (plan != null) 'plan': plan,
      if (role != null) 'role': role,
    };
  }
}
