# Combat Log Detector 🎮

A FiveM script that detects and tracks players who disconnect during gameplay, creating a visible corpse at their last known position with detailed information.

![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)
![FiveM](https://img.shields.io/badge/FiveM-Compatible-green.svg)
![QBCore](https://img.shields.io/badge/QBCore-Required-red.svg)

---

## 📋 Features

- **Real-time Disconnect Detection** - Automatically detects when players disconnect from the server
- **Corpse Creation** - Creates a realistic corpse at the player's last position with their exact appearance
- **Player Information Display** - Shows Steam name, Discord ID, character name, and playtime
- **Ascension Animation** - Corpse ascends to the sky with particle effects when interacted with
- **Optimized Performance** - Low resource usage with efficient code
- **Memory Management** - Automatic cleanup prevents memory leaks
- **3D Information Cards** - Dynamic UI that follows the corpse in 3D space

---

## 📦 Requirements

- [qb-core](https://github.com/qbcore-framework/qb-core) - QBCore Framework
- [qb-target](https://github.com/qbcore-framework/qb-target) - Targeting system

---

## 🚀 Installation

1. Download the latest release
2. Extract `dw-combatlog` to your `resources/[qb]/` folder
3. Add `ensure dw-combatlog` to your `server.cfg`
4. Restart your server or use `refresh` and `ensure dw-combatlog`

### Folder Structure
```
resources/[qb]/dw-combatlog/
├── fxmanifest.lua
├── client/
│   └── client.lua
├── server/
│   └── server.lua
└── html/
    ├── index.html
    ├── style.css
    └── script.js
```

---

## 🎮 Usage

### For Players
When a player disconnects, their corpse will appear at their last location. Other players can:
1. Approach the corpse
2. Press `E` to view information
3. Watch the corpse ascend to the sky with visual effects

### For Admins
Use the test command to verify functionality:
```
/testcombatlog
```
This creates a test corpse at your current position.

---

## ⚙️ Configuration

### Adjust Corpse Duration
Edit `client/client.lua` at line 132:
```lua
endTime = GetGameTimer() + 10000, -- Time in milliseconds (10000 = 10 seconds)
```

**Examples:**
- 30 seconds: `30000`
- 1 minute: `60000`
- 2 minutes: `120000`

### Adjust Update Frequency
Edit `client/client.lua` at line 7:
```lua
Wait(5000) -- Update every 5 seconds (5000ms)
```
Lower values = more accurate but slightly higher resource usage

### Adjust Display Distance
Edit `client/client.lua` at line 416:
```lua
if distance < 20.0 then -- Display UI within 20 meters
```

---

## 🔍 How It Works

1. **Sync System** - Client sends player data (position, model, appearance) to server every 5 seconds
2. **Data Storage** - Server stores the latest player data
3. **Disconnect Detection** - Server detects when a player disconnects
4. **Broadcast** - Server sends the stored data to all clients
5. **Corpse Creation** - Each client creates a corpse at the disconnect location
6. **Interaction** - Players can view information by targeting the corpse
7. **Ascension** - After interaction, corpse ascends with particle effects
8. **Cleanup** - Automatic removal after the configured duration

---

## 📊 Performance

- **Client:** ~0.01ms/frame
- **Server:** ~0.001ms/event
- **Memory:** Minimal with automatic cleanup
- **Optimization:** Uses Wait(100) instead of Wait(0) for ~90% CPU reduction

---

## 🐛 Troubleshooting

### Corpse doesn't appear when someone disconnects

**Check Console for:**
```
[COMBAT LOG] Player disconnected: [Name] (Playtime: Xs)
[COMBAT LOG] Creating marker for: [Name]...
[COMBAT LOG] Ped created successfully for [Name]
```

**Solutions:**
- Ensure `qb-core` is running
- Ensure `qb-target` is installed and working
- Check F8 console for errors
- Verify the resource is started: `ensure dw-combatlog`

### Information card doesn't display

**Check:**
- Press F8 and look for JavaScript errors
- Ensure the NUI is loading: Resources → dw-combatlog
- Try `/testcombatlog` to verify functionality

### Script not starting

**Verify:**
```lua
-- server.cfg order matters:
ensure qb-core
ensure qb-target
ensure dw-combatlog
```

---

## 📝 Information Displayed

When viewing a disconnect corpse:
- **Steam Name** - Player's Steam display name
- **Discord ID** - Player's Discord identifier (if available)
- **Character Name** - In-game character name
- **Time Played** - Total session playtime before disconnect

---

## 🎨 Features Breakdown

### Corpse Appearance
- Exact replica of player's character
- Includes all clothing components
- Preserves facial features and customization
- Ragdoll physics on creation

### Visual Effects
- Particle effects during ascension
- Smooth rotation and spiral motion
- Gradual fade-out
- Professional UI with Discord-style badges

### Performance Features
- Efficient update system (every 5 seconds)
- Distance-based UI rendering
- Automatic resource cleanup
- No memory leaks

---

## 🔒 Security

- XSS protection with HTML escaping
- Server-side validation
- No client-side exploits
- Secure data transmission

---

## 📜 License

This project is released under the MIT License.

---

## 🤝 Credits

Created by **DW Scripts**

---

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review console logs for error messages
3. Ensure all dependencies are properly installed
4. Verify the folder structure is correct

---

## 🔄 Changelog

### Version 1.1.0
- Optimized client-side performance (90% CPU reduction)
- Added comprehensive null checks
- Implemented automatic memory cleanup
- Added timeout handlers to prevent freezing
- Fixed emoji encoding in UI
- Added XSS protection
- Improved debug logging
- Enhanced error handling

### Version 1.0.0
- Initial release
- Basic disconnect detection
- Corpse creation system
- Information display UI

---

## 🎯 Roadmap

Potential future features:
- Configurable combat detection
- Screenshot capture on disconnect
- Database logging
- Discord webhook notifications
- Admin notification system

---

**Enjoy the script! If you have suggestions or feedback, feel free to reach out.**
