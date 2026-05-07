# Product Catalog Manager v2.0 📦

A professional, feature-rich command-line interface (CLI) application for inventory management built with **Dart**. This project demonstrates clean code practices, object-oriented programming, and local data persistence.

## 🚀 Features

- **Full CRUD Operations**: Create, Read, Update, and Delete products with ease.
- **Local Persistence**: Automatically saves and loads data from a `productos.json` file.
- **Premium CLI Experience**: 
  - ANSI color-coded feedback (Green for success, Red for errors).
  - Formatted tables for clear inventory visualization.
  - Automatic screen clearing for a modern app feel.
- **Search Engine**: Quickly find products by name using a dynamic filtering system.
- **Stock Reporting**: Dedicated tool to identify products with low stock (<= 5 units).
- **Data Validation**: Robust handling of user input to prevent invalid data or crashes.

## 🛠️ Technologies Used

- **Language**: [Dart](https://dart.dev/)
- **Data Format**: JSON (via `dart:convert`)
- **System IO**: `dart:io`

## 📥 Installation & Usage

### Prerequisites
- [Dart SDK](https://dart.dev/get-dart) installed on your machine.

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/sebastianvasquezechavarria1234/Examen-dart.git
   ```
2. Navigate to the project folder:
   ```bash
   cd Examen-dart
   ```

### Running the App
Execute the main script:
```bash
dart main.dart
```

## 📂 Project Structure

- `main.dart`: Core logic, including the `Producto` class and CLI menu system.
- `productos.json`: Local database file (auto-generated).

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

---
*Developed for academic purposes as part of the Dart Development Examination.*
