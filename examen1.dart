import 'dart:io';

class Product {
  int index = 0;
  String name;
  double price;
  int quantity;

  Product(this.name, this.price, this.quantity);

  set setIndex(int PreviousIndex) {
    index = PreviousIndex + 1;
  }
}

void main() {
  List<Product> products = [];
  String choice;
  do {
    print("\nBienvenido al gestor de productos");
    print("1. Agregar producto");
    print("2. Listar productos");
    print("3. Eliminar producto");
    print("4. Actualizar producto");
    print("5. Salir");
    stdout.write("Ingrese su opción: ");
    choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        addProduct(products);
        break;
      case '2':
        listProducts(products);
        break;
      case '3':
        deleteProduct(products);
        break;
      case '4':
        updateProduct(products);
        break;
      case '5':
        print("Saliendo del gestor de productos.");
        return;
      default:
        print("Opción no válida, por favor intente de nuevo.");
    }
  } while (choice != '5');
}

void addProduct(List<Product> products) {
  String name;
  double price;
  int quantity;

  print("\nAgregar un nuevo producto:");
  do {
    stdout.write("Ingrese el nombre del producto: ");
    name = stdin.readLineSync()!;
    if (name.isEmpty) {
      print("El nombre no puede estar vacío.");
    }
  } while (name.isEmpty);

  do {
    stdout.write("Ingrese el precio del producto: ");
    String? priceInput = stdin.readLineSync();
    try {
      price = double.parse(priceInput!);
      if (price <= 0) {
        print("El precio debe ser un número positivo.");
        price = -1; // Usamos un valor inválido para continuar el bucle
      }
    } catch (e) {
      print("Entrada no válida. Por favor, ingrese un número.");
      price = -1;
    }
  } while (price <= 0);

  do {
    stdout.write("Ingrese la cantidad disponible: ");
    String? quantityInput = stdin.readLineSync();
    try {
      quantity = int.parse(quantityInput!);
      if (quantity < 0) {
        print("La cantidad no puede ser negativa.");
        quantity = -1;
      }
    } catch (e) {
      print("Entrada no válida. Por favor, ingrese un número entero.");
      quantity = -1;
    }
  } while (quantity < 0);

  Product newProduct = Product(name, price, quantity);
  if (products.isNotEmpty) {
    newProduct.setIndex = products.last.index;
  } else {
    newProduct.setIndex = 0;
  }
  products.add(newProduct);
  print("Producto agregado exitosamente.");
}

void listProducts(List<Product> products) {
  if (products.isEmpty) {
    print("No hay productos en la lista.");
  } else {
    print("\nLista de productos:");
    for (var product in products) {
      print(
          "Indice: ${product.index}, Nombre: ${product.name}, Precio: \$${product.price.toStringAsFixed(2)}, Cantidad: ${product.quantity}");
    }
  }
}

void deleteProduct(List<Product> products) {
  if (products.isEmpty) {
    print("No hay productos en la lista para eliminar.");
    return;
  }
  listProducts(products);
  stdout.write("Ingrese el índice del producto a eliminar: ");
  String? indexInput = stdin.readLineSync();
  try {
    int index = int.parse(indexInput!);
    if (index < 0 || index >= products.length+1) {
      print("Índice inválido.");
    } else {
      products.removeAt(index);
      print("Producto eliminado exitosamente.");
    }
  } catch (e) {
    print("Entrada no válida. Por favor, ingrese un número entero.");
  }
}

void updateProduct(List<Product> products) {
  if (products.isEmpty) {
    print("No hay productos en la lista para actualizar.");
    return;
  }
  listProducts(products);
  stdout.write("Ingrese el índice del producto a actualizar: ");
  String? indexInput = stdin.readLineSync();
  try {
    int index = int.parse(indexInput!);
    if (index < 0 || index >= products.length+1) {
      print("Índice inválido.");
    } else {
      Product productToUpdate = products[index-1];

      // Actualizar nombre
      stdout.write("Actualizar nombre (actual: ${productToUpdate.name}). Deje en blanco para mantener el valor: ");
      String newName = stdin.readLineSync()!;
      if (newName.isNotEmpty) {
        productToUpdate.name = newName;
      }

      // Actualizar precio
      stdout.write("Actualizar precio (actual: \$${productToUpdate.price.toStringAsFixed(2)}). Deje en blanco para mantener el valor: ");
      String? newPriceInput = stdin.readLineSync();
      if (newPriceInput!.isNotEmpty) {
        try {
          double newPrice = double.parse(newPriceInput);
          if (newPrice > 0) {
            productToUpdate.price = newPrice;
          } else {
            print("El precio debe ser un número positivo. No se realizó la actualización.");
          }
        } catch (e) {
          print("Entrada no válida. No se realizó la actualización.");
        }
      }

      // Actualizar cantidad
      stdout.write("Actualizar cantidad (actual: ${productToUpdate.quantity}). Deje en blanco para mantener el valor: ");
      String? newQuantityInput = stdin.readLineSync();
      if (newQuantityInput!.isNotEmpty) {
        try {
          int newQuantity = int.parse(newQuantityInput);
          if (newQuantity >= 0) {
            productToUpdate.quantity = newQuantity;
          } else {
            print("La cantidad no puede ser negativa. No se realizó la actualización.");
          }
        } catch (e) {
          print("Entrada no válida. No se realizó la actualización.");
        }
      }

      print("Producto actualizado exitosamente.");
    }
  } catch (e) {
    print("Entrada no válida. Por favor, ingrese un número entero.");
  }
}