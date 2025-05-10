# rpa_tasks.py
import subprocess
import shlex
import platform
from RPA.Desktop import Desktop

desktop = Desktop()

def open_application(params):
    """
    Opens an application or a file on the target operating system.

    @Parameters:
    - "command": string, complete command to launch ('code .', 'firefox', 'gedit file.txt')
    - "wait_element" @optional: name of the element to wait for (title of the window)
    - "timeout" @optional: timeout in seconds to wait before timing out

    Examples:
    - Linux:   'gedit /home/user/file.txt'
    - macOS:   'open -a Safari'
    - Windows: 'notepad', 'C:\\Program Files\\App\\app.exe'
    """
    command = params["command"]

    # shlex.split -> separate args (os-based)
    is_windows = platform.system().lower() == "windows"
    parts = shlex.split(command, posix=not is_windows)

    # Execute command in background
    subprocess.Popen(parts, shell=False)

    # Wait for the wait_element
    wait_element = params.get("wait_element")
    timeout = params.get("timeout", 10)

    if wait_element:
        try:
            desktop.wait_for_element(wait_element, timeout=timeout)
        except Exception as e:
            raise RuntimeError(f"The element '{wait_element}' couldn't be found, timed out after {timeout}s: {e}")
