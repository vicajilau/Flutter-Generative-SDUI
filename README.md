# Flutter Generative SDUI 🚀

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Serverpod](https://img.shields.io/badge/Backend-Serverpod-blue)](https://serverpod.dev)
[![Flutter](https://img.shields.io/badge/Frontend-Flutter-02569B)](https://flutter.dev)

A powerful template for building **Server-Driven UI (SDUI)** systems powered by **Generative AI**, built entirely with **Dart** using **Flutter** and **Serverpod**.

## 🌟 Overview

Traditional SDUI relies on static JSON definitions. **Flutter Generative SDUI** takes it a step further by integrating LLMs (like Google Gemini) directly into the backend workflow. The server generates UI schemas dynamically based on user context or prompts, which the Flutter app renders instantly.

### Why this template?
- **Unified Language**: 100% Dart from server to client.
- **Live Updates**: Modify your UI without waiting for App Store/Google Play approvals.
- **AI-Powered**: Let AI decide the best layout or content for your users in real-time.
- **Type Safety**: Serverpod handles all the serialization and client code generation.

---

## 🏗️ Project Structure

This is a multi-package workspace managed by Serverpod:

- 📂 `gsdui_server`: The Dart backend. Handles AI logic, database interactions, and SDUI schema generation.
- 📂 `gsdui_client`: The auto-generated client-side library for communication between server and app.
- 📂 `gsdui_flutter`: The Flutter frontend application that renders the generated components.

---

## 🛠️ Getting Started

### Prerequisites

1.  **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
2.  **Serverpod CLI**:
    ```bash
    dart pub global activate serverpod_cli
    ```
3.  **Docker Desktop**: Required to run the Serverpod database (PostgreSQL) and Redis.

### Setup & Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/Flutter-Generative-SDUI.git
    cd Flutter-Generative-SDUI
    ```

2.  **Start the Database**:
    Navigate to the server directory and start Docker:
    ```bash
    cd gsdui_server
    docker-compose up -d
    ```

3.  **Initialize the Backend**:
    Apply migrations and start the Serverpod server:
    ```bash
    dart bin/main.dart
    ```

4.  **Launch the Flutter App**:
    In a new terminal:
    ```bash
    cd gsdui_flutter
    flutter run
    ```

---

## 🧠 How it Works: Generative SDUI

1.  **Request**: The Flutter app sends a request to a Serverpod endpoint (e.g., `getDynamicPage`).
2.  **AI Processing**: The server queries an LLM with a specific prompt (e.g., "Create a dashboard for a fitness app showing steps and weekly progress").
3.  **Schema Mapping**: The server transforms the AI's response into a structured SDUI JSON schema (defined in `gsdui_server/lib/src/models`).
4.  **Rendering**: The Flutter app receives the schema and uses a `WidgetFactory` to map JSON types to native Flutter widgets.

---

## 🎨 Customizing Components

To add new UI components:
1.  Define the model in `gsdui_server/lib/src/models/`.
2.  Run `serverpod generate`.
3.  Implement the corresponding widget in `gsdui_flutter/lib/ui/widgets/`.

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve the Generative SDUI patterns.

Customized with ❤️ for the Flutter community.
