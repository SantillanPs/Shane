import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class UserRepository {
  static const String _fileName = 'users.json';
  final Uuid _uuid = const Uuid();

  // Get the path to the JSON file
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // Create the file if it doesn't exist
  Future<File> _createFile() async {
    final file = await _localFile;
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode([]));
    }
    return file;
  }

  // Read all users from the JSON file
  Future<List<User>> getUsers() async {
    try {
      final file = await _createFile();
      final contents = await file.readAsString();
      
      if (contents.isEmpty) {
        return [];
      }
      
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error reading users: $e');
      return [];
    }
  }

  // Add a new user to the JSON file
  Future<User> addUser({
    required String name,
    required String email,
    required String phone,
    required String company,
    required String role,
  }) async {
    try {
      final users = await getUsers();
      
      // Check if email already exists
      if (users.any((user) => user.email == email)) {
        throw Exception('A user with this email already exists');
      }
      
      final newUser = User(
        id: _uuid.v4(),
        name: name,
        email: email,
        phone: phone,
        company: company,
        role: role,
        createdAt: DateTime.now(),
      );
      
      users.add(newUser);
      
      final file = await _localFile;
      await file.writeAsString(jsonEncode(users.map((u) => u.toJson()).toList()));
      
      return newUser;
    } catch (e) {
      debugPrint('Error adding user: $e');
      rethrow;
    }
  }

  // Delete a user from the JSON file
  Future<void> deleteUser(String id) async {
    try {
      final users = await getUsers();
      users.removeWhere((user) => user.id == id);
      
      final file = await _localFile;
      await file.writeAsString(jsonEncode(users.map((u) => u.toJson()).toList()));
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }
}

