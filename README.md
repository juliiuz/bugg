Bug-G Tools 2.1 - Competitive preset

- This set of scripts were made to help you with that kind stuff Krafton never does: fixing bugs. 

Competitive mode now:
- Protects PUBG, BattlEye, Zakynthos, Steam core (including steamwebhelper to avoid respawn loops), Discord, NVIDIA display/container, Windows core, network, audio/input and Defender/firewall.
- Terminates non-protected third-party applications.
- Terminates selected nonessential Windows UI/background processes observed in the supplied inventory.
- Stops selected nonessential services observed in All_Processes_And_Services.csv.
- Does NOT disable services or change their startup type. Reboot returns normal Windows startup behavior.
- Runs a second process trim after PUBG is detected, catching helpers/overlays that respawn during launch.
- Preserves Bluetooth services because Bluetooth audio/controller can be relevant to PUBG/Discord.

IMPORTANT: run the tool as Administrator to use Preset competitivo.

Checked fixes (2.1.1):
- Removed Reset-Winsock from the competitive preset. Winsock reset is a repair action, not a pre-game optimization.
- Final trim now waits for TslGame.exe specifically; zksvc/BattlEye helpers no longer trigger early detection.
- Service restore state is cumulative across repeated preset runs and is persisted after every successful stop.
- Failed service restores remain recorded so Restore can be retried.
- Competitive no longer clears PUBG/NVIDIA/D3D shader caches on every launch; manual cleanup remains available.
- Ultimate Performance now uses a stable Bug-G GUID, avoids duplicate plans on repeated runs, and verifies the active scheme.
