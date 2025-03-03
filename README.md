# Prop Creator - Standalone FiveM Script

## Table of Contents 

-   [Description](#description-)
-   [Features](#features-️)
-   [Installation](#installation-)
-   [Usage](#usage-)
-   [Available Events](#available-events-)
-   [Controls](#controls-)
-   [Optimization](#optimization-)
-   [Dependencies](#dependencies-)
-   [License](#license-)

## Description 📜
**Prop Creator** is a fully standalone script that allows the creation and management of props within the game world. With this script, administrators can dynamically generate, place, and remove objects through an intuitive interface with seamless database integration.

## Features 🛠️
✅ **Real-time prop creation** with customizable position, rotation, and collision settings.  
✅ **Database-backed prop management** for full persistence.  
✅ **Prop removal menu**, with options to delete a specific prop or all at once.  
✅ **Smooth spawning and despawning effects** to optimize performance and improve immersion.  
✅ **Support for multiple notification systems**, including `ox_lib`.  
✅ **Configurable permission system** to restrict command access.  
✅ **Highly optimized** for efficient server performance.  

---

## Installation 📥
### 1️⃣ **Download and add the script**
Place the script folder in your server's `resources/` directory and rename it to **M-PropV2**

### 2️⃣ **Configure `server.cfg`**
Add the following line to your `server.cfg`:
```
ensure M-PropV2
```

### 3️⃣ **Set up the database**
Run the following SQL query in your database to store props:
```sql
CREATE TABLE IF NOT EXISTS `mprops` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `propid` VARCHAR(50) NOT NULL,
    `propname` VARCHAR(100) NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `heading` FLOAT NOT NULL,
    `freeze` BOOLEAN NOT NULL,
    `colision` BOOLEAN NOT NULL
);
```

---

## Usage 📌
### 🏗️ **Creating a Prop**
- Use the `/propcreator` command to open the admin menu.
- Select the **"Create a Prop"** option and enter the required details.
- Place the prop in the world using movement controls.

### 🗑️ **Deleting Props**
- Access the deletion menu via `/propcreator`.
- Choose to remove a specific prop or delete all props from the server.

### 🎛️ **Configuring Permissions**
Modify permissions in `config.lua`:
```lua
Configuration = {
    Command = "propcreator",
    CommandAccess = "group.admin",
}
```

---

## Available Events 📡
### 🔹 **Client → Server**
| Event                          | Description |
|--------------------------------|-------------|
| `m:propcreator:RequestProps`   | Requests the list of stored props from the database. |
| `m:propcreator:RemoveProp`     | Deletes a specific prop by ID. |
| `m:propcreator:RemoveAllProps` | Deletes all stored props. |

### 🔹 **Server → Client**
| Event                              | Description |
|----------------------------------|-------------|
| `m:propcreator:SpawnProps`      | Spawns props stored in the database. |
| `m:propcreator:DeleteAllProps`  | Removes all props from the game world. |
| `m:propcreator:createremovemenu` | Displays the prop deletion menu. |

---

## Controls 🎮
These are the controls for moving and adjusting props in the game world:
```
[Q]    - Move Up
[E]    - Move Down
[ARROWS] - Move
[Scroll Wheel] - Rotate
[LALT] - Adjust Height
[ESC]  - Finish Editing
```

---

## Optimization 🚀
This script is designed to be **lightweight and efficient**, using:
- **Dynamic loading and unloading of props based on distance** to reduce server load.
- **Well-structured event handling** to avoid unnecessary executions.
- **Integration with `ox_lib`** for managing interfaces and notifications.

---

## Credits 👨‍💻
**Developer:** *M-DEVELOPMENT*  
For support or suggestions, feel free to reach out! 🎉

---

## License 📜
This script is open-source. You may modify and adapt it to your needs, but **reselling it is not allowed**.

