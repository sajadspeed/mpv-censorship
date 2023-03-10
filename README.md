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
[Censorship point(HH:MM:SS)] [Jump second]
``` 

# Example
``` 
├── Film_Example_Name.mkv
└── Film_Example_Name.censor
``` 

Film_Example_Name.censor:
``` 
00:10:55 5
0:13:30 7
0:25:1 3
1:30:58 15
``` 