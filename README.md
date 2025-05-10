# GDG2025
## MemFlow
MemFlow is a tool to detect your habitual workflows automatically - especially ones you may not be aware of - and lets you quickly get set up and on your way to productivity. It works by locally tracking your activity with ActivityWatcher and detecting patterns in your actions through pattern recognition and lets your replay your actions by employing an AI agent based on macOS-use.

As of this moment, MemFlow is only available on macOS as of today, but it may easily be ported to other platforms by employing for example computer-use-OOTB (which was not chosen by us since it doesn't as of now support the gemini API).

### Installing
First, install ActivityWatcher (link). For browser support, also install aw-watcher-web.

Then, clone the repository
'''
git clone https://github.com/Lorenzo-Pigato/GDG2025.git && cd GDG2025
'''

install mlx-use
'''
pip install mlx-use
'''

run the program
'''
python3 main.py
'''
