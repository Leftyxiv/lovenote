# Love Note

A special World of Warcraft addon that sends love notes to your special someone.

## Description

Love Note is a simple addon that:
- Displays a welcome message when your loved one logs in
- Shows a cute pop-up window with love messages
- Sends random loving messages to their chat every 20-30 minutes
- Includes a pool of 50 cute, pre-written messages
- Can be toggled on/off with simple slash commands

## Installation

1. Download the addon files
2. Extract the "LoveNote" folder to your World of Warcraft "Interface/AddOns" directory:
   - Typically: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
   - Or: `C:\Program Files\World of Warcraft\_retail_\Interface\AddOns\`
3. Make sure the folder structure looks like this:
   ```
   Interface/AddOns/LoveNote/
   ├── LoveNote.toc
   └── LoveNote.lua
   ```
4. Launch World of Warcraft
5. Make sure the addon is enabled in the character selection screen (AddOns button)

## Usage

The addon works automatically once installed and enabled. It will:
- Show a welcome message when logging in (both in chat and as a pop-up)
- Send random love notes every 20-30 minutes (both in chat and as a pop-up)
- Pop-up windows will automatically close after 15 seconds, or can be closed manually

### Slash Commands

- `/lovenote` or `/ln` - Toggle the addon on/off
- `/ln now` - Send a love message immediately (with pop-up)
- `/ln help` - Show help information

## Customization

You can customize the messages by editing the `loveMessages` table in the `LoveNote.lua` file.

## License

This addon is free to use and modify for personal use.

## Author

Created with love for the most special person in my life. ❤️ 