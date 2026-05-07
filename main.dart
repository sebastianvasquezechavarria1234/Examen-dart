import 'dart:io';

class Producto {
  String nombre;
  int precio;
  int stock;

  Producto({required this.nombre, required this.precio, required this.stock});

  @override
  String toString() {
    return 'Nombre: $nombre, Precio: $precio, Stock: $stock';
  }
}

void main() {
  List<Producto> productos = [];

  print('===== BIENVENIDO AL CRUD DE CATALOGO DE PRODUCTOS =====');

  bool continuar = true;
  while (continuar) {
    print('Selecciona una opción:');
    print('1) Crear');
    print('2) Visualizar');
    print('3) Editar');
    print('4) Eliminar');
    print('5) Salir');

    int? opcion = int.tryParse(stdin.readLineSync() ?? '');
    if (opcion == null) {
      print('Por favor ingresa un número válido (1-5).');
      continue;
    }

    switch (opcion) {
      case 1:
        agregar(productos);
        break;
      case 2:
        visualizar(productos);
        break;
      case 3:
        actualizar(productos);
        break;
      case 4:
        eliminar(productos);
        break;
      case 5:
        continuar = false;
        print('Saliendo...');
        break;
      default:
        print('Opción no válida. Elige entre 1 y 5.');
    }
  }
}

// validaciones
String leerCadenaNoVacia(String prompt) {
  while (true) {
    stdout.write(prompt);
    String input = stdin.readLineSync() ?? '';
    if (input.trim().isEmpty) {
      print('No puede estar vacío este campo. Intenta de nuevo.');
      print('');
      continue;
    }
    return input.trim();
  }
}

int leerEnteroNoNegativo(String prompt) {
  while (true) {
    stdout.write(prompt);
    String input = stdin.readLineSync() ?? '';
    int? numero = int.tryParse(input);
    if (numero == null) {
      print('Debes ingresar un número entero válido.');
      continue;
    }
    if (numero < 0) {
      print('El número no puede ser negativo.');
      continue;
    }
    return numero;
  }
}

int leerIndiceValido(List productos, String prompt) {
  while (true) {
    int indice = leerEnteroNoNegativo(prompt);
    if (indice < 0 || indice >= productos.length) {
      print('Índice inválido. Intenta con uno dentro del rango (0 - ${productos.length - 1}).');
      continue;
    }
    return indice;
  }
}

void agregar(List<Producto> productos) {
  print('');
  print('--- Crear producto ---');
  String nombre = leerCadenaNoVacia('Nombre del producto: ');
  int precio = leerEnteroNoNegativo('Precio del producto (entero): ');
  int stock = leerEnteroNoNegativo('Cantidad disponible (entero): ');

  productos.add(Producto(nombre: nombre, precio: precio, stock: stock));
  print('Producto registrado correctamente.');
  print('');
}

void visualizar(List<Producto> productos) {
  print('--- Lista de productos ---');
  if (productos.isEmpty) {
    print('No hay productos registrados.');
    return;
  }
  for (int i = 0; i < productos.length; i++) {
    print('$i: ${productos[i]}');
  }
  print('');
}

void actualizar(List<Producto> productos) {
  if (productos.isEmpty) {
    print('No hay productos para editar.');
    return;
  }
  print('--- Editar producto ---');
  visualizar(productos);
  int indice = leerIndiceValido(productos, 'Ingresa el índice del producto a actualizar: ');

  var producto = productos[indice];

  // Nombre
  stdout.write('Nuevo nombre del producto (enter para mantener "${producto.nombre}"): ');
  String inputNombre = stdin.readLineSync() ?? '';
  if (inputNombre.trim().isNotEmpty) {
    producto.nombre = inputNombre.trim();
  }

  // Precio
  stdout.write('Nuevo precio del producto (entero) (enter para mantener ${producto.precio}): ');
  String inputPrecio = stdin.readLineSync() ?? '';
  if (inputPrecio.trim().isNotEmpty) {
    int? parsed = int.tryParse(inputPrecio);
    if (parsed != null) producto.precio = parsed;
  }

  // Stock
  stdout.write('Nueva cantidad disponible (entero) (enter para mantener ${producto.stock}): ');
  String inputStock = stdin.readLineSync() ?? '';
  if (inputStock.trim().isNotEmpty) {
    int? parsed = int.tryParse(inputStock);
    if (parsed != null) producto.stock = parsed;
  }

  print('El producto se actualizó correctamente.');
  print('');
}

void eliminar(List<Producto> productos) {
  if (productos.isEmpty) {
    print('No hay productos para eliminar.');
    return;
  }
  print('--- Eliminar producto ---');
  visualizar(productos);
  int indice = leerIndiceValido(productos, 'Ingresa el índice del producto a eliminar: ');

  stdout.write('¿Seguro que deseas eliminar el producto ${productos[indice].nombre}? (s/n): ');
  String respuesta = (stdin.readLineSync() ?? '').toLowerCase();
  if (respuesta == 's' || respuesta == 'si') {
    productos.removeAt(indice);
    print('Producto eliminado correctamente.');
  } else {
    print('Eliminación cancelada.');
  }
}
