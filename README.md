# Censorship MPV player
Quick censorship of the film without changing it.

# Installation
Put the script `censorship.lua` in your scripts folder, usually in:
| OS | Location |
| --- | --- |
| GNU/Linux or macOS | `~/.config/mpv/scripts/` |
| Windows | `C:/Users/Username/AppData/Roaming/mpv/scripts/` |

# How to use
Create a file with the `.censor` extension of the same name as the film file in the same path. Fill it with this template:
``` 
[Start point(HH:MM:SS)] [End point(HH:MM:SS)]
``` 
Now the film jumps from the starting point to the ending point.

# Example
``` 
├── Film_Example_Name.mkv
└── Film_Example_Name.censor
``` 

Film_Example_Name.censor:
``` 
00:10:55 00:10:59
0:13:30 00:15:3
0:25:1 00:26:01
1:30:58 01:32:00
``` 
