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
const String CLEAR_SCREEN = '\x1B[2J\x1B[0;0H';

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
    print('\n${CYAN}${BOLD}===== CATALOGO DE PRODUCTOS v2.0 =====${RESET}');
    print('${BLUE}1)${RESET} Crear producto');
    print('${BLUE}2)${RESET} Visualizar todos');
    print('${BLUE}3)${RESET} Editar producto');
    print('${BLUE}4)${RESET} Eliminar producto');
    print('${BLUE}5)${RESET} Buscar por nombre');
    print('${BLUE}6)${RESET} Reporte de stock bajo');
    print('${BLUE}7)${RESET} Salir');
    stdout.write('\nSelecciona una opción: ');

    int? opcion = int.tryParse(stdin.readLineSync() ?? '');
    if (opcion == null) {
      print('${RED}Error: Ingresa un número válido (1-7).${RESET}');
      continue;
    }

    switch (opcion) {
      case 1:
        limpiarPantalla();
        agregar(productos);
        guardarDatos(productos);
        break;
      case 2:
        limpiarPantalla();
        visualizar(productos);
        break;
      case 3:
        limpiarPantalla();
        actualizar(productos);
        guardarDatos(productos);
        break;
      case 4:
        limpiarPantalla();
        eliminar(productos);
        guardarDatos(productos);
        break;
      case 5:
        limpiarPantalla();
        buscar(productos);
        break;
      case 6:
        limpiarPantalla();
        generarReporte(productos);
        break;
      case 7:
        continuar = false;
        print('${YELLOW}Saliendo del sistema...${RESET}');
        break;
      default:
        print('${RED}Opción no válida. Intenta de nuevo.${RESET}');
    }
  }
}

void limpiarPantalla() {
  stdout.write(CLEAR_SCREEN);
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
  print('\n${GREEN}${BOLD}--- Registrar nuevo producto ---${RESET}');
  String nombre = leerCadenaNoVacia('Nombre: ');
  int precio = leerEnteroNoNegativo('Precio: ');
  int stock = leerEnteroNoNegativo('Stock inicial: ');

  productos.add(Producto(nombre: nombre, precio: precio, stock: stock));
  print('\n${GREEN}✔ Producto registrado con éxito.${RESET}');
}

void visualizar(List<Producto> productos) {
  print('\n${CYAN}${BOLD}--- Inventario Actual ---${RESET}');
  if (productos.isEmpty) {
    print('${YELLOW}El catálogo está vacío.${RESET}');
    return;
  }
  
  _imprimirTabla(productos);
}

void _imprimirTabla(List<Producto> lista) {
  print('${BOLD}ID  | ${"Nombre".padRight(20)} | ${"Precio".padRight(8)} | Stock${RESET}');
  print('-' * 45);
  for (int i = 0; i < lista.length; i++) {
    String id = i.toString().padRight(3);
    print('$id | ${lista[i]}');
  }
}

void actualizar(List<Producto> productos) {
  if (productos.isEmpty) {
    print('${YELLOW}No hay productos para editar.${RESET}');
    return;
  }
  _imprimirTabla(productos);
  int indice = leerIndiceValido(productos, '\nID del producto a editar: ');

  var producto = productos[indice];

  print('\n${YELLOW}Editando: ${producto.nombre} (Deja en blanco para no cambiar)${RESET}');

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

  print('\n${GREEN}✔ Producto actualizado correctamente.${RESET}');
}

void eliminar(List<Producto> productos) {
  if (productos.isEmpty) {
    print('${YELLOW}No hay productos para eliminar.${RESET}');
    return;
  }
  _imprimirTabla(productos);
  int indice = leerIndiceValido(productos, '\nID del producto a eliminar: ');

  stdout.write('\n${RED}¿Eliminar "${productos[indice].nombre}"? (s/n): ${RESET}');
  String respuesta = (stdin.readLineSync() ?? '').toLowerCase();
  if (respuesta == 's' || respuesta == 'si') {
    productos.removeAt(indice);
    print('\n${GREEN}✔ Producto eliminado.${RESET}');
  } else {
    print('\n${YELLOW}Operación cancelada.${RESET}');
  }
}

void buscar(List<Producto> productos) {
  if (productos.isEmpty) {
    print('${YELLOW}El catálogo está vacío.${RESET}');
    return;
  }
  stdout.write('Ingresa el nombre a buscar: ');
  String query = (stdin.readLineSync() ?? '').toLowerCase();
  
  List<Producto> resultados = productos.where((p) => p.nombre.toLowerCase().contains(query)).toList();
  
  if (resultados.isEmpty) {
    print('\n${RED}No se encontraron productos que coincidan con "$query".${RESET}');
  } else {
    print('\n${GREEN}Resultados de búsqueda:${RESET}');
    _imprimirTabla(resultados);
  }
}

void generarReporte(List<Producto> productos) {
  if (productos.isEmpty) {
    print('${YELLOW}No hay productos registrados.${RESET}');
    return;
  }
  
  int limite = 5; // Consideramos stock bajo si es <= 5
  List<Producto> bajoStock = productos.where((p) => p.stock <= limite).toList();
  
  print('\n${YELLOW}${BOLD}--- Reporte de Stock Bajo (<= $limite unidades) ---${RESET}');
  if (bajoStock.isEmpty) {
    print('${GREEN}Todos los productos tienen stock suficiente.${RESET}');
  } else {
    _imprimirTabla(bajoStock);
  }
}
