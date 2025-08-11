import 'dart:io';

class Book{
  int index =0;
  String title;
  String author;
  String year;
  Book(this.title, this.author, this.year);
  set setIndex(int PreviousIndex){
    if(PreviousIndex == 1)
    index = 1;
    else
    index = PreviousIndex + 1;
  }
}

void main(){
  List<Book> Books=[];
  do{
    var BookRegister = Book('yo','yo' ,"yo" );
    if(Books.length == 0 || Books[Books.length-1].index == 0){
      BookRegister.setIndex = 1;
    }else{
      BookRegister.setIndex = Books[Books.length-1].index;
    }
    Books.add(BookRegister);
    String stop = stdin.readLineSync()!;
    if(stop == 'no'){
      break;
    }
  }while(true);
  Books.forEach((b)=>print('${b.index}, ${b.author}, ${b.title}, ${b.year}')
  );
}