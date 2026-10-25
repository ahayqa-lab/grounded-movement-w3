# Grounded Movement - Walk Jog Sprint

A movement mod for **The Witcher 3: Wild Hunt** (next-gen / 4.x).

Geralt walks by default. Hold **Shift** (or **A/X** on a controller) to jog, **double-tap** to sprint.
Speed builds up and eases off gradually instead of snapping from one gait to the next, for a heavier, more grounded feel.

Also available on Nexus Mods as *Grounded Movement - Walk Jog Sprint*.

## Controls

| | Keyboard | Controller |
|---|---|---|
| Walk | move without Shift | left stick only |
| Jog | hold Shift | hold A/X |
| Sprint | double-tap Shift and keep holding | double-tap A/X and keep holding |

Clicking the left stick still toggles the normal sprint. In combat the game's normal controls apply.

## Installation

Install with your mod manager, or manually:

1. Copy the `modSprint` folder into `The Witcher 3\mods\` (create the `mods` folder if it doesn't exist).
2. Start the game. The scripts compile automatically.

**No Script Merger needed.** The mod doesn't replace any vanilla script files; it hooks into them with script annotations (`@wrapMethod`).

To uninstall, delete `The Witcher 3\mods\modSprint`.

## Compatibility

- Don't combine with other walk-by-default or sprint mods (for example Walk by Default). Pick one.
- Mods that change player movement speed may conflict.

## How it works

All code is in `modSprint/content/scripts/local/`:

- **sprint.ws** - double-tap detection (`CPlayerInput.OnCommSprint`), walk-by-default (`CPlayer.GetIsWalkToggled`) and sprint gating (`CR4Player.CanSprint`). `SprintModDoubleTapWindow` sets the maximum time between the two taps (default 0.35 s).
- **sprint_smooth.ws** - smooth speed ramp (`CR4LocomotionPlayerControllerScript.CalculateMoveSpeed`). `SprintModAccelRate` / `SprintModDecelRate` set how fast speed builds up and eases off.

## Contributing

Contributions are welcome!

1. Fork this repository.
2. Make your changes in your fork. Please test them in the game (keyboard and, if you can, controller).
3. Open a pull request describing what you changed and how you tested it.

Notes for script edits:
- Keep `.ws` files saved as **UTF-8 with BOM**.
- Only one `wrappedMethod(...)` call is allowed per `@wrapMethod` wrapper, or the script compiler fails.
- Don't commit vanilla game scripts or other CD PROJEKT RED game files.

Bug reports and ideas go in [Issues](../../issues).

## License

[MIT](LICENSE). The Witcher 3 is © CD PROJEKT RED; this project contains no game files.
