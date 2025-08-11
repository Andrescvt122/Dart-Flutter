import 'dart:math';
import 'dart:io';

class Games {
  String stateGame = '';
  int pointGameState;
  Games(this.stateGame, this.pointGameState);
  int CalculatePointsGame(amountGames) {
    return amountGames * pointGameState;
  }
}

class Employee {
  String name = '';
  int WorkHours = 0;
  Employee(this.name, this.WorkHours);
  int calculateWorkHours(int valueWorkHours) {
    return WorkHours * valueWorkHours;
  }
}

void main() {
  do {
    print(
        "ingresa la opcion a realizar (si no deseas ver mas, ingresa el numero 0) del 1 al 6 \n 1. Distancia \n 2. Promedio de notas \n 3. Informe de partidos \n 4. Empleados \n 5. Triangulo rectangulo \n 6. Celsius a Fahrenheit");
    int? option = int.parse(stdin.readLineSync()!);
    switch (option) {
      case 1:
        firthExercise();
        break;
      case 2:
        secondExercise();
        break;
      case 3:
        thirdExercise();
        break;
      case 4:
        fourthExercise();
        break;
      case 5:
        fifthExercise();
        break;
      case 6:
        sixthExercise();
        break;
      case 0:
        break;
    }
    if (option == 0) {
      break;
    }
  } while (true);
}

void firthExercise() {
  print('velocidad');
  int? speed = int.parse(stdin.readLineSync()!);
  print('tiempo');
  int? time = int.parse(stdin.readLineSync()!);
  print('La distancia es ' + (speed * time).toString());
}

void secondExercise() {
  List<double> partialNotes = [];
  print('Cuantas notas vas a ingresar?');
  int? n = int.parse(stdin.readLineSync()!);
  for (int i = 0; i < n; i++) {
    print('Ingrese la nota ' + (i + 1).toString());
    double? note = double.parse(stdin.readLineSync()!);
    partialNotes.add(note);
  }
  double avarageNotes = avarage(partialNotes);
  print('El promedio de las notas es ' + avarageNotes.toString());
}

double avarage(List<double> notes) {
  if (notes.isEmpty) {
    return 0;
  }
  double sum = notes.fold(0, (sum, num) => sum + num);
  return sum / notes.length;
}

void thirdExercise() {
  Games gameWin = Games('win', 3);
  Games gameDraw = Games('draw', 1);
  Games gameLose = Games('lose', 0);
  print('Ingresa los partidos ganados');
  int? accumulatorGameWin = int.parse(stdin.readLineSync()!);
  print('Ingresa los partidos empatados');
  int? accumulatorGameDraw = int.parse(stdin.readLineSync()!);
  print('Ingresa los partidos perdidos');
  int? accumulatorGameLose = int.parse(stdin.readLineSync()!);
  int accumulatorPointsGames =
      gameWin.CalculatePointsGame(accumulatorGameWin) +
          gameDraw.CalculatePointsGame(accumulatorGameDraw) +
          gameLose.CalculatePointsGame(accumulatorGameLose);
  print(
      "INFORME DE LOS PARTIDOS \n ---------------------\n partidos totales: ${accumulatorGameWin + accumulatorGameDraw + accumulatorGameLose} \n partidos ganados: $accumulatorGameWin \n partidos empatados: $accumulatorGameDraw \n partidos perdidos: $accumulatorGameLose \n puntos totales: $accumulatorPointsGames");
}


void fourthExercise() {
  int valueWorkHours = 2;
  List<Employee> employees = [];
  while (true) {
    print('Ingrese el nombre del empleado ');
    String? name = stdin.readLineSync();
    print('Ingrese las horas trabajadas');
    int? workHours = int.parse(stdin.readLineSync()!);
    employees.add(Employee(name!, workHours!));
    print('Deseas agregar un empleado mas?');
    String verification = stdin.readLineSync()!;
    if (verification == 'no') {
      break;
    }
  }
  employees.forEach((e) {
    print(
        'El nombre del empelado es ${e.name} y las horas trabajadas son ${e.WorkHours} y el total devengado es ${e.calculateWorkHours(valueWorkHours)} \n');
  });
}

void fifthExercise() {
  print('Ingresa la longitud del cateto A');
  int? sideA = int.parse(stdin.readLineSync()!);
  print('Ingresa la longitud del cateto B');
  int? sideB = int.parse(stdin.readLineSync()!);
  print(
      "El triangulo rectangulo con el cateto a de longitud $sideA y el cateto b de longitud $sideB tiene como hipotenusa ${sqrt(pow(sideA, 2) + pow(sideB, 2))}");
}

void sixthExercise() {
  print('Ingresa la temperatura en celsius');
  double? temperature = double.parse(stdin.readLineSync()!);
  print(
      'La temperatura de celsius a fahrenheit es de ${(temperature * 1.8) + 32}');
}
