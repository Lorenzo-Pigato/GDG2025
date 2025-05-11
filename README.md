# GDG2025  
## MemFlow
![output](https://github.com/user-attachments/assets/7f89b465-ceb9-4e6b-ab1d-b0e7f98eeee4)


MemFlow is a productivity tool that automatically detects your habitual workflows — especially the ones you might not even realize — and helps you quickly get back into them.  
It works by locally tracking your activity using [ActivityWatch](https://github.com/ActivityWatch/activitywatch?tab=readme-ov-file), identifying behavioral patterns, and replaying them with the help of an AI agent tailored for macOS users.

> ⚠️ Currently, MemFlow is only available on **macOS**.  
> It can be easily ported to other platforms, but we opted not to use `computer-use-OOTB` due to its current lack of support for the Gemini API.

---

### 🚀 Installation
First, install [ActivityWatcher](https://github.com/ActivityWatch/activitywatch?tab=readme-ov-file). For browser support, also install [aw-watcher-web]().

Then, clone the repository
```
git clone https://github.com/Lorenzo-Pigato/GDG2025.git && cd GDG2025
```

setup venv, install mlx-use and dependencies
```
python3 -m venv .venv
source .venv/bin/activate
pip install mlx-use && pip install backend/macOS-use/
```

run the program
```
swift run
```

A tray icon will appear, allowing you to play the detected workflows.
