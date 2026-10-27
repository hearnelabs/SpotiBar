# SpotiBar 🎵

A sleek, lightweight Spotify widget for **CachyOS** and **KDE Plasma 6**, created by **HearneLabs**.

SpotiBar sits directly inside your top panel, displaying the currently playing song and artist along with instant playback controls (Previous, Play/Pause, Next) and live animated visualizers.

---

## 🎨 Styles Included

SpotiBar includes **two distinct visual designs** built right in:

### 1. **Cachy Cyber Wave** (Default)
![Cachy Cyber Wave](assets/cachy_wave.png)
* Tailored specifically for CachyOS with signature **neon emerald (`#00e5a3`)** accents.
* Live **4-bar audio equalizer** that animates smoothly during playback and rests when paused.
* Glowing tactile Play/Pause button.
* Rounded dark glass card container with subtle emerald perimeter glow.

### 2. **Native Plasma Breeze**
![Native Plasma Breeze](assets/native_breeze.png)
* 100% native KDE Plasma 6 Breeze design language.
* **Zero container / border overhead**: inherits the raw panel background to match your clock and system tray icons.
* Breeze monochrome playback buttons on the left with subtle hover highlights.
* Subtle vertical divider, Spotify green mark, and clean `Song Title — Artist` typography.

---

## ⚡ Quick Controls & Shortcuts

* **Play / Pause**: Click the center play/pause button.
* **Previous / Next Track**: Click the `⏮` or `⏭` buttons.
* **Open / Focus Spotify**: Click on the song title or artist name.
* **Toggle Styles (Cachy Wave ⟷ Native Breeze)**:
  * **Middle-click** anywhere on the widget in your panel (on the song title, artist, or pill background).
  * Or right-click the widget $\rightarrow$ **"Configure SpotiBar..."** $\rightarrow$ change the **Widget Style** dropdown.

---

## 🚀 Quick Install

### Prerequisites
Make sure `playerctl` is installed:
```bash
sudo pacman -S playerctl
```

### Installation
Clone this repository and run the install script:
```bash
git clone https://github.com/hearnelabs/spotibar.git
cd spotibar
./install.sh
```

### Adding SpotiBar to Your Panel
1. Right-click on an empty area of your KDE top panel.
2. Select **"Add Widgets..."** (or press <kbd>Meta</kbd> + <kbd>W</kbd>).
3. Search for **"SpotiBar"**.
4. Drag and drop **SpotiBar** onto your panel.

---

## ⚙️ Configuration Options

Right-click SpotiBar $\rightarrow$ **"Configure SpotiBar..."**:
* **Widget Style**: Switch between *Cachy Cyber Wave* and *Native Plasma Breeze*.
* **Max Title Width (px)**: Control how much panel width the track title can occupy before eliding (default: 160px).
* **Show Artist Info**: Toggle whether the artist name appears alongside the track title.
* **Visualizer**: Toggle the animated equalizer bars in Cachy Wave mode.

---

## 📁 Project Structure

```
SpotiBar/
├── metadata.json                 # Plasma 6 applet metadata
├── install.sh                    # One-command installer
├── contents/
│   ├── config/
│   │   ├── main.xml              # KConfig schema
│   │   └── config.qml            # Configuration model
│   ├── ui/
│   │   ├── main.qml              # Root PlasmoidItem & MPRIS state manager
│   │   ├── CompactRepresentation.qml # In-panel representation
│   │   ├── CachyWaveView.qml     # Mockup 4 (Cachy Wave UI)
│   │   ├── NativeBreezeView.qml  # Mockup 3 (Native Breeze UI)
│   │   └── configGeneral.qml     # Plasma settings page UI
│   ├── scripts/
│   │   └── mpris.sh              # MPRIS2 D-Bus backend runner
│   └── icons/
│       ├── spotify.svg           # Spotify brand icon
│       └── spotibar.svg          # SpotiBar applet icon
└── assets/                       # Screenshot previews
```

---

## 📜 License
GPL-3.0+ · Developed by **HearneLabs**
