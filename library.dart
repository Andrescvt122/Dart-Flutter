import 'dart:io';

class Book {
  int index = 0;
  String title;
  String author;
  String year;
  Book(this.title, this.author, this.year);
  set setIndex(int PreviousIndex) {
    index = PreviousIndex + 1;
  }
}

void main() {
  List<Book> books = [];
  String choice;
  do {
    print("Bienvenido a la biblioteca");
    print("1. Agregar libro");
    print("2. Listar libros");
    print("3. Eliminar libro");
    print("4. Actualizar libro");
    print("5. Salir");
    choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        addBook(books);
        break;
      case '2':
        listBooks(books);
        break;
      case '3':
        deleteBook(books);
        break;
      case '4':
        updateBook(books);
        break;
      case '5':
        print("Saliendo de la biblioteca.");
        return;
      default:
        print("Opción no válida, por favor intente de nuevo.");
    }
  } while (choice != '5');
}

void addBook(List<Book> books) {
  do {
    String title;
    String author;
    String year;
    print("Agregar un nuevo libro:");
    do {
      print("Ingrese el título del libro:");
      title = stdin.readLineSync()!;
      if (title.isEmpty) {
        print("El título no puede estar vacío");
      }
    } while (title.isEmpty);
    do {
      print("Ingrese el autor del libro:");
      author = stdin.readLineSync()!;
      if (author.isEmpty) {
        print("El autor no puede estar vacío");
      }
    } while (author.isEmpty);
    do {
      print("Ingrese el año de publicación del libro:");
      year = stdin.readLineSync()!;
      if (year.isEmpty) {
        print("El año no puede estar vacío");
      }
    } while (year.isEmpty);
    Book newBook = Book(title, author, year);
    if (books.isNotEmpty) {
      newBook.setIndex = books.last.index;
    } else {
      newBook.setIndex = 0;
    }
    books.add(newBook);
    print("¿Desea agregar otro libro? (s/n)");
    String response = stdin.readLineSync()!.toLowerCase();
    if (response != 's') {
      break;
    }
  } while (true);
}

void listBooks(List<Book> books) {
  if (books.isEmpty) {
    print("No hay libros en la lista.");
  } else {
    print("Lista de libros:");
    for (var book in books) {
      print(
        "Indice: ${book.index}, Título: ${book.title}, Autor: ${book.author}, Año: ${book.year}",
      );
    }
  }
}

void deleteBook(List<Book> books) {
  if (books.isEmpty) {
    print("No hay libros en la lista para eliminar.");
  } else {
    print("Ingrese el índice del libro a eliminar (1 a ${books.length}):");
    int index = int.parse(stdin.readLineSync()!);
    if (index < 0 || index >= books.length) {
      print("Índice inválido.");
    } else {
      books.removeAt(index - 1);
      print("Libro eliminado exitosamente.");
    }
  }
}

void updateBook(List<Book> books) {
  if (books.isEmpty) {
    print("No hay libros en la lista para actualizar.");
  } else {
    print("Ingrese el índice del libro a actualizar (1 a ${books.length}):");
    int index = int.parse(stdin.readLineSync()!);
    if (index <= 0 || index > books.length) {
      print("Índice inválido.");
    } else {
      Book bookToUpdate = books[index - 1];
      String newTitle;
      String newAuthor;
      String newYear;

      do {
        print("Actualizar título (actual: ${bookToUpdate.title}):");
        newTitle = stdin.readLineSync()!;
        if (newTitle.isEmpty) {
          print("El título no puede estar vacío");
        }
      } while (newTitle.isEmpty);
      bookToUpdate.title = newTitle;

      do {
        print("Actualizar autor (actual: ${bookToUpdate.author}):");
        newAuthor = stdin.readLineSync()!;
        if (newAuthor.isEmpty) {
          print("El autor no puede estar vacío");
        }
      } while (newAuthor.isEmpty);
      bookToUpdate.author = newAuthor;

      do {
        print("Actualizar año (actual: ${bookToUpdate.year}):");
        newYear = stdin.readLineSync()!;
        if (newYear.isEmpty) {
          print("El año no puede estar vacío");
        }
      } while (newYear.isEmpty);
      bookToUpdate.year = newYear;

      print("Libro actualizado exitosamente.");
    }
  }
}
