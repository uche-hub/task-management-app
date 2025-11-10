# 🗂️ Task Manager App

A clean, production-ready task management app built with **Flutter**.  
It features offline support, tag management, global search, and a responsive UI that adapts seamlessly across phones and tablets.

---

## Features

### Core Features
- **Lists Management**
  - Create, rename, and delete task lists  
- **Task Management**
  - Full CRUD operations for tasks, including:
    - Title and description  
    - Due dates with validation  
    - Priority levels (Low, Medium, High)  
    - Status tracking (To Do, In Progress, Done)  
    - Multi-tag support  

### Filtering & Sorting
- Filter by status  
- Filter by multiple tags  
- Sort by due date, priority, or creation date  

### Global Search
- Search tasks by title or tags across all lists  

### Offline Support
- All data persists locally using **SQLite**

---

## Nice-to-Have Features Implemented
- **Tag Management:** Create tags with custom colors and filter by multiple tags  
- **Due Soon Section:** Tasks due within 48 hours are automatically highlighted  
- **Responsive Design:** Optimized for all screen sizes (phones & tablets)

---

## Architecture
The app follows a **clean, feature-first architecture** with clear separation of concerns.

## 🧱 Layers Explanation

### 🗄️ DAO Layer (`task_dao.dart`)
Direct database access layer built with **sqflite**.  
Responsible for executing raw SQL queries, inserts, updates, deletions, and handling database transactions.

### 🧩 Repository Layer (`task_repository.dart`)
Acts as a bridge between the DAO and UI layers.  
Handles data validation, business logic, and transformation of raw database entities into usable models for the UI.

### ⚙️ State Management (`task_providers.dart`)
Uses **Riverpod** to manage and expose application state.  
Providers and Notifiers handle task lists, filters, and tags — ensuring that widgets never directly access the database.

### 🖼️ UI Layer
Composed of screens and widgets that consume state through Riverpod providers.  
This layer remains **clean, reactive, and fully testable**, keeping business logic separated from presentation.

---

## 🗃️ Database Schema

The app uses **SQLite** with proper **schema versioning** and **migration support** to ensure smooth updates between versions.

---

## 🧾 Database Tables

### 📋 **lists**
| Column | Type | Constraints |
|:--|:--|:--|
| `id` | TEXT | PRIMARY KEY |
| `name` | TEXT | NOT NULL |
| `created_at` | INTEGER | NOT NULL |

---

### ✅ **tasks**
| Column | Type | Constraints |
|:--|:--|:--|
| `id` | TEXT | PRIMARY KEY |
| `list_id` | TEXT | FOREIGN KEY → lists(id) |
| `title` | TEXT | NOT NULL |
| `description` | TEXT |  |
| `due_date` | INTEGER |  |
| `priority` | INTEGER | NOT NULL |
| `status` | TEXT | NOT NULL |
| `created_at` | INTEGER | NOT NULL |

---

### 🏷️ **tags**
| Column | Type | Constraints |
|:--|:--|:--|
| `id` | TEXT | PRIMARY KEY |
| `name` | TEXT | UNIQUE, NOT NULL |
| `color` | INTEGER | NOT NULL |

---

### **task_tags** (Many-to-Many Relationship)
| Column | Type | Constraints |
|:--|:--|:--|
| `task_id` | TEXT | FOREIGN KEY → tasks(id) |
| `tag_id` | TEXT | FOREIGN KEY → tags(id) |
| **PRIMARY KEY** | *(task_id, tag_id)* |  |

---

### ⚙️ **settings**
| Column | Type | Constraints |
|:--|:--|:--|
| `key` | TEXT | PRIMARY KEY |
| `value` | TEXT | NOT NULL |

---

## 🕰️ Migration History
| Version | Description |
|:--|:--|
| **1** | Initial schema with `lists`, `tasks`, `tags`, and `task_tags` tables |
| **2** | Added `settings` table for app preferences |

---

## 🛠️ Setup & Installation

### 📦 Prerequisites
Before running the project, ensure you have the following installed:

- **Flutter SDK** (v3.0.0 or higher)  
- **Dart SDK** (v3.0.0 or higher)  

### ▶️ Run the App

```bash
# Clone the repository
git clone https://github.com/uche-hub/task-management-app.git

# Navigate into the project directory
cd task_manager_app

# Get all dependencies
flutter pub get

# Run the app
flutter run