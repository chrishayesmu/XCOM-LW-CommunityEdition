# Contents

This file documents the executable file modifications that are required to make LWCE's mod loading system work properly.

Each patch has two parts: a **target bytestring**, and a **replacement bytestring**. The target bytestring is a series of bytes that only occur once in the entire executable, and uniquely identify a place where we need to make a change. The replacement bytestring is a string of the same length, which should be patched in to overwrite the target.

# Patches 1 and 2: mod loading

## Explanation

XCOM's version of Unreal Engine 3 has built-in capabilities for installing DLCs. Those capabilities do not appear to be used by XCOM, which never even instantiates the classes responsible for them, but are still in place. Unfortunately they have some validation in place to ensure that you're loading real DLCs and not arbitrary files. We simply replace a couple of jump instructions to send ourselves down the right code path.

## Bytestrings (patch 1)

```
Target:      39 7E FC 75 43 8B 0D EC 7D
Replacement: 39 7E FC EB 43 8B 0D EC 7D
```

`0x75` is a `jump-if-not-zero` instruction. We convert it to `0xEB`, a `jump` (unconditional) instruction.

## Bytestrings (patch 2)

```
Target:      7C AD 84 DB 0F 85 86 00 00 00
Replacement: 7C AD 84 DB 0F 89 86 00 00 00
```

`0x0F 0x85` is a `jump-if-not-zero (near)` instruction. We convert it to `0x0F 0x89`, a `jump-if-not-sign (near)` instruction.

# Patches 3 and 4: custom materials

## Explanation

The game engine, like nearly every game engine, has the capability to compile shaders on the fly. This can be seen by deleting the game's shader caches; they will be regenerated on the next startup. For some reason, the engine believes that custom materials from mods cannot be compiled in this way, and will log errors when trying. Turns out it's wrong and the compilation works just fine. Much like the first two patches, we simply change a couple of jumps to make the engine try compiling anyway.

## Bytestrings (patch 3)

```
Target:      A9 CE 07 00 00 0F 84 CC 01 00 00
Replacement: A9 CE 07 00 00 0F 89 CC 01 00 00
```

`0x0F 0x84` is a `jump-if-zero (near)` instruction. We convert it to `0x0F 0x89`, a `jump-if-not-sign (near)` instruction.

## Bytestrings (patch 4)

```
Target:      8D 44 24 38 8B CF 50 74 7A
Replacement: 8D 44 24 38 8B CF 50 EB 7A
```

`0x74` is a `jump-if-zero` instruction. We convert it to `0xEB`, a `jump` (unconditional) instruction.