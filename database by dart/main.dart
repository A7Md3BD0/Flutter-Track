import 'dart:io';
import 'dart:convert';
import './classes.dart';

void main() {
  final databaseFile = File('Database.csv');

  while (true) {
    print(
        'Enter a command (create, show, all, update, delete) or "exit" to quit:');
    final input = stdin.readLineSync()?.toLowerCase();

    if (input == 'exit') {
      break;
    }

    switch (input) {
      case 'create':
        handleCreateCommand();
        break;
      case 'show':
        handleShowCommand();
        break;
      case 'all':
        handleAllCommand();
        break;
      case 'update':
        handleUpdateCommand();
        break;
      case 'delete':
        handleDeleteCommand();
        break;
      default:
        print('Invalid command. Please try again.');
    }
  }
}

void handleCreateCommand() {
  print('Enter the class name (Username, Products, Reviews):');
  final className = stdin.readLineSync();

  switch (className) {
    case 'Username':
      createUsername();
      break;
    case 'Products':
      createProduct();
      break;
    case 'Reviews':
      createReview();
      break;
    default:
      print('Invalid class name. Please try again.');
  }
}

void createUsername() {
  print('Enter the ID:');
  final id = stdin.readLineSync();

  print('Enter the name:');
  final name = stdin.readLineSync();

  final username = Username(id, name);
  saveData('Username', username.toJson());
}

void createProduct() {
  print('Enter the ID:');
  final id = stdin.readLineSync();

  print('Enter the name:');
  final name = stdin.readLineSync();

  print('Enter the description:');
  final description = stdin.readLineSync();

  final product = Product(id, name, description);
  saveData('Products', product.toJson());
}

void createReview() {
  print('Enter the ID:');
  final id = stdin.readLineSync();

  print('Enter the product ID:');
  final productId = stdin.readLineSync();

  print('Enter the review content:');
  final content = stdin.readLineSync();

  final review = Review(id, productId, content);
  saveData('Reviews', review.toJson());
}

void saveData(String className, Map<String, dynamic> data) {
  final databaseFile = File('Database.csv');
  final csvData = '${className},${jsonEncode(data)}\n';
  databaseFile.writeAsStringSync(csvData, mode: FileMode.append);
  print('Data saved successfully.');
}

void handleShowCommand() {
  print('Enter the class name (Username, Products, Reviews):');
  final className = stdin.readLineSync();

  print('Enter the ID:');
  final id = stdin.readLineSync();

  final data = readData(className!, id!);
  if (data != null) {
    print(data);
  } else {
    print('Data not found.');
  }
}

dynamic readData(String className, String id) {
  final databaseFile = File('Database.csv');
  final lines = databaseFile.readAsLinesSync();

  for (final line in lines) {
    final parts = line.split(',');
    if (parts.length >= 2 && parts[0] == className) {
      final jsonData = parts.sublist(1).join(',');
      final data = jsonDecode(jsonData);
      if (data['id'] == id) {
        return data;
      }
    }
  }

  return null;
}

void handleAllCommand() {
  print('Enter the class name (Username, Products, Reviews):');
  final className = stdin.readLineSync();

  final data = readAllData(className!);
  if (data.isNotEmpty) {
    for (final item in data) {
      print(item);
    }
  } else {
    print('No data found.');
  }
}

List<dynamic> readAllData(String className) {
  final databaseFile = File('Database.csv');
  final lines = databaseFile.readAsLinesSync();
  final dataList = <dynamic>[];

  for (final line in lines) {
    final parts = line.split(',');
    if (parts.length >= 2 && parts[0] == className) {
      final jsonData = parts.sublist(1).join(',');
      final data = jsonDecode(jsonData);
      dataList.add(data);
    }
  }

  return dataList;
}

void handleUpdateCommand() {
  print('Enter the class name (Username, Products, Reviews):');
  final className = stdin.readLineSync();

  print('Enter the ID:');
  final id = stdin.readLineSync();

  final existingData = readData(className!, id!);
  if (existingData != null) {
    print('Existing data: $existingData');

    print(
        'Enter the property to update (id, name, description, productId, content):');
    final property = stdin.readLineSync();

    print('Enter the new value:');
    final newValue = stdin.readLineSync();

    existingData[property] = newValue;
    updateData(className, id, existingData);
  } else {
    print('Data not found.');
  }
}

void updateData(String className, String id, Map<String, dynamic> newData) {
  final databaseFile = File('Database.csv');
  final lines = databaseFile.readAsLinesSync();
  final updatedLines = <String>[];

  for (final line in lines) {
    final parts = line.split(',');
    if (parts.length >= 2 && parts[0] == className) {
      final jsonData = parts.sublist(1).join(',');
      final data = jsonDecode(jsonData);
      if (data['id'] == id) {
        final updatedData = {...data, ...newData};
        final updatedJsonData = jsonEncode(updatedData);
        final updatedLine = '$className,$updatedJsonData';
        updatedLines.add(updatedLine);
      } else {
        updatedLines.add(line);
      }
    } else {
      updatedLines.add(line);
    }
  }

  databaseFile.writeAsStringSync(updatedLines.join('\n'));
  print('Data updated successfully.');
}

void handleDeleteCommand() {
  print('Enter the class name (Username, Products, Reviews):');
  final className = stdin.readLineSync();

  print('Enter the ID:');
  final id = stdin.readLineSync();

  deleteData(className!, id!);
}

void deleteData(String className, String id) {
  final databaseFile = File('Database.csv');
  final lines = databaseFile.readAsLinesSync();
  final updatedLines = <String>[];

  for (final line in lines) {
    final parts = line.split(',');
    if (parts.length >= 2 && parts[0] == className) {
      final jsonData = parts.sublist(1).join(',');
      final data = jsonDecode(jsonData);
      if (data['id'] != id) {
        updatedLines.add(line);
      }
    } else {
      updatedLines.add(line);
    }
  }

  databaseFile.writeAsStringSync(updatedLines.join('\n'));
  print('Data deleted successfully.');
}
