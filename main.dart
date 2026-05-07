import 'dart:io';
import 'dart:convert';

// Colores ANSI
const String RESET = '\x1B[0m';
const String RED = '\x1B[31m';
const String GREEN = '\x1B[32m';
const String YELLOW = '\x1B[33m';
const String BLUE = '\x1B[34m';
const String CYAN = '\x1B[36m';
const String BOLD = '\x1B[1m';

class Producto {
  String nombre;
  int precio;
  int stock;

  Producto({required this.nombre, required this.precio, required this.stock});

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'precio': precio,
        'stock': stock,
      };

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      nombre: json['nombre'],
      precio: json['precio'],
      stock: json['stock'],
    );
  }

  @override
  String toString() {
    return '${nombre.padRight(20)} | \$${precio.toString().padRight(8)} | ${stock.toString().padRight(5)}';
  }
}

const String ARCHIVO_DATOS = 'productos.json';

void main() {
  List<Producto> productos = cargarDatos();

  bool continuar = true;
  while (continuar) {
    print('\n${CYAN}${BOLD}===== CATALOGO DE PRODUCTOS =====${RESET}');
    print('${BLUE}1)${RESET} Crear');
    print('${BLUE}2)${RESET} Visualizar');
    print('${BLUE}3)${RESET} Editar');
    print('${BLUE}4)${RESET} Eliminar');
    print('${BLUE}5)${RESET} Salir');
    stdout.write('\nSelecciona una opción: ');

    int? opcion = int.tryParse(stdin.readLineSync() ?? '');
    if (opcion == null) {
      print('${RED}Error: Ingresa un número válido (1-5).${RESET}');
      continue;
    }

    switch (opcion) {
      case 1:
        agregar(productos);
        guardarDatos(productos);
        break;
      case 2:
        visualizar(productos);
        break;
      case 3:
        actualizar(productos);
        guardarDatos(productos);
        break;
      case 4:
        eliminar(productos);
        guardarDatos(productos);
        break;
      case 5:
        continuar = false;
        print('${YELLOW}Saliendo del sistema...${RESET}');
        break;
      default:
        print('${RED}Opción no válida. Intenta de nuevo.${RESET}');
    }
  }
}

void guardarDatos(List<Producto> productos) {
  try {
    final file = File(ARCHIVO_DATOS);
    final jsonString = jsonEncode(productos.map((p) => p.toJson()).toList());
    file.writeAsStringSync(jsonString);
  } catch (e) {
    print('${RED}Error al guardar datos: $e${RESET}');
  }
}

List<Producto> cargarDatos() {
  try {
    final file = File(ARCHIVO_DATOS);
    if (!file.existsSync()) return [];
    final jsonString = file.readAsStringSync();
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => Producto.fromJson(item)).toList();
  } catch (e) {
    print('${RED}Error al cargar datos: $e${RESET}');
    return [];
  }
}

String leerCadenaNoVacia(String prompt) {
  while (true) {
    stdout.write(prompt);
    String input = stdin.readLineSync() ?? '';
    if (input.trim().isEmpty) {
      print('${RED}Este campo es obligatorio.${RESET}');
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
      print('${RED}Ingresa un número entero válido.${RESET}');
      continue;
    }
    if (numero < 0) {
      print('${RED}El valor no puede ser negativo.${RESET}');
      continue;
    }
    return numero;
  }
}

int leerIndiceValido(List productos, String prompt) {
  while (true) {
    int indice = leerEnteroNoNegativo(prompt);
    if (indice < 0 || indice >= productos.length) {
      print('${RED}Índice fuera de rango (0 - ${productos.length - 1}).${RESET}');
      continue;
    }
    return indice;
  }
}

void agregar(List<Producto> productos) {
  print('\n${GREEN}--- Registrar nuevo producto ---${RESET}');
  String nombre = leerCadenaNoVacia('Nombre: ');
  int precio = leerEnteroNoNegativo('Precio: ');
  int stock = leerEnteroNoNegativo('Stock inicial: ');

  productos.add(Producto(nombre: nombre, precio: precio, stock: stock));
  print('${GREEN}✔ Producto registrado con éxito.${RESET}');
}

void visualizar(List<Producto> productos) {
  print('\n${CYAN}--- Inventario Actual ---${RESET}');
  if (productos.isEmpty) {
    print('${YELLOW}El catálogo está vacío.${RESET}');
    return;
  }
  
  print('${BOLD}ID  | ${"Nombre".padRight(20)} | ${"Precio".padRight(8)} | Stock${RESET}');
  print('-' * 45);
  for (int i = 0; i < productos.length; i++) {
    String id = i.toString().padRight(3);
    print('$id | ${productos[i]}');
  }
}

void actualizar(List<Producto> productos) {
  if (productos.isEmpty) {
    print('${YELLOW}No hay productos para editar.${RESET}');
    return;
  }
  visualizar(productos);
  int indice = leerIndiceValido(productos, '\nID del producto a editar: ');

  var producto = productos[indice];

  print('${YELLOW}Editando: ${producto.nombre} (Deja en blanco para no cambiar)${RESET}');

  stdout.write('Nuevo nombre: ');
  String inputNombre = stdin.readLineSync() ?? '';
  if (inputNombre.trim().isNotEmpty) {
    producto.nombre = inputNombre.trim();
  }

  stdout.write('Nuevo precio: ');
  String inputPrecio = stdin.readLineSync() ?? '';
  if (inputPrecio.trim().isNotEmpty) {
    int? parsed = int.tryParse(inputPrecio);
    if (parsed != null) producto.precio = parsed;
  }

  stdout.write('Nuevo stock: ');
  String inputStock = stdin.readLineSync() ?? '';
  if (inputStock.trim().isNotEmpty) {
    int? parsed = int.tryParse(inputStock);
    if (parsed != null) producto.stock = parsed;
  }

  print('${GREEN}✔ Producto actualizado correctamente.${RESET}');
}

void eliminar(List<Producto> productos) {
  if (productos.isEmpty) {
    print('${YELLOW}No hay productos para eliminar.${RESET}');
    return;
  }
  visualizar(productos);
  int indice = leerIndiceValido(productos, '\nID del producto a eliminar: ');

  stdout.write('${RED}¿Eliminar "${productos[indice].nombre}"? (s/n): ${RESET}');
  String respuesta = (stdin.readLineSync() ?? '').toLowerCase();
  if (respuesta == 's' || respuesta == 'si') {
    productos.removeAt(indice);
    print('${GREEN}✔ Producto eliminado.${RESET}');
  } else {
    print('${YELLOW}Operación cancelada.${RESET}');
  }
}
