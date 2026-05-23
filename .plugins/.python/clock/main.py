#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's Profile - Clock Manifest
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This Module provides a set of clock-related utility functions for various
#       common tasks in PowerShell.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/{REPO_NAME}
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

"""
Clock Manifest CLI

A terminal utility for countdowns, stopwatch, and wall clocks.

Usage:
    python3 main.py countdown --duration 25s --title "Break Time"
    python3 main.py stopwatch --title "Workout Timer"
    python3 main.py wallclock --title "Local Time" --24hour --timezone "Asia/Amman"
"""

from __future__ import annotations

import argparse
import datetime
import logging
import shutil
import sys
import time
from datetime import datetime as dt
from os import environ, name as os_name, system as os_system
from pathlib import Path

logger = logging.getLogger(__name__)

try:
    from pyfiglet import Figlet
except ImportError:
    print("\033[91m[!] Error: 'pyfiglet' package is not installed.\033[0m")
    print("\033[93m[*] Please install it using one of the following commands:\033[0m")
    print("    pip install pyfiglet")
    print("    pip3 install pyfiglet")
    print("    python -m pip install pyfiglet")
    sys.exit(1)

try:
    import msvcrt
    WINDOWS = True
except ImportError:
    import select
    import tty
    from termios import TCSADRAIN, tcgetattr, tcsetattr
    WINDOWS = False


# -------------------------------------------------------------------------------------
# ANSI Colors
# -------------------------------------------------------------------------------------

class Colors:
    """ANSI color codes for terminal output"""
    RESET = "\033[0m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    CYAN = "\033[96m"
    MAGENTA = "\033[95m"
    BLUE = "\033[94m"
    WHITE = "\033[97m"
    BOLD = "\033[1m"

    @staticmethod
    def success(text: str) -> str:
        """Wrap ``text`` in green ANSI codes."""
        return f"{Colors.GREEN}{text}{Colors.RESET}"

    @staticmethod
    def warning(text: str) -> str:
        """Wrap ``text`` in yellow ANSI codes."""
        return f"{Colors.YELLOW}{text}{Colors.RESET}"

    @staticmethod
    def error(text: str) -> str:
        """Wrap ``text`` in red ANSI codes."""
        return f"{Colors.RED}{text}{Colors.RESET}"

    @staticmethod
    def info(text: str) -> str:
        """Wrap ``text`` in cyan ANSI codes."""
        return f"{Colors.CYAN}{text}{Colors.RESET}"

    @staticmethod
    def highlight(text: str) -> str:
        """Wrap ``text`` in magenta ANSI codes."""
        return f"{Colors.MAGENTA}{text}{Colors.RESET}"


# -------------------------------------------------------------------------------------
# Utility Functions
# -------------------------------------------------------------------------------------

def kbhit() -> bool:
    """Check if a key has been pressed (cross-platform)."""
    if WINDOWS:
        return msvcrt.kbhit()
    else:
        dr, dw, de = select.select([sys.stdin], [], [], 0)
        return dr != []


def getch() -> str:
    """Get a character from keyboard (cross-platform)."""
    if WINDOWS:
        return msvcrt.getch().decode('utf-8').upper()
    else:
        fd = sys.stdin.fileno()
        old_settings = tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1).upper()
        finally:
            tcsetattr(fd, TCSADRAIN, old_settings)
        return ch


def read_figlet_font(font_name: str = "ANSI_Shadow") -> Figlet:
    """Load Figlet font, preferring the dotfiles-bundled font directory if present."""
    # Locate dotfiles .config/.figlet relative to this script (works through symlinks)
    bundled_font_dir = Path(__file__).resolve().parents[3] / ".config" / ".figlet"
    candidate_dirs = [
        Path.home() / ".config" / ".figlet",
        bundled_font_dir,
    ]

    for font_dir in candidate_dirs:
        if font_dir.exists():
            environ['PYFIGLET_PATH'] = str(font_dir)
            break

    try:
        return Figlet(font=font_name, width=200)
    except Exception:
        try:
            return Figlet(font='standard', width=200)
        except Exception:
            return Figlet(width=200)


def convert_text_to_ascii(text: str, font: Figlet) -> str:
    """Render text through pyfiglet, returning the input verbatim on failure."""
    try:
        return font.renderText(text)
    except Exception as e:
        print(f"Error rendering text: {e}")
        return text


def parse_time_string(time_str: str) -> float:
    """Parse a duration like ``25s``/``5m``/``1h`` or a clock time like ``02:15PM`` into seconds-from-now."""
    try:
        # Check for time format first (with :)
        if ":" in time_str:
            now = dt.now()
            try:
                target = dt.strptime(time_str, "%I:%M%p")
            except ValueError:
                try:
                    target = dt.strptime(time_str, "%H:%M")
                except ValueError:
                    target = dt.strptime(time_str, "%I:%M %p")
            target = target.replace(year=now.year, month=now.month, day=now.day)
            if target < now:
                target += datetime.timedelta(days=1)
            return (target - now).total_seconds()
        # Then check for duration suffixes
        elif time_str.lower().endswith("s"):
            return float(time_str[:-1])
        elif time_str.lower().endswith("m"):
            return float(time_str[:-1]) * 60
        elif time_str.lower().endswith("h"):
            return float(time_str[:-1]) * 3600
        else:
            return float(time_str)
    except Exception as e:
        print(f"Invalid duration or time format: {time_str}. Error: {e}")
        sys.exit(1)


def clear_screen() -> None:
    """Clear the terminal screen using the platform-appropriate command."""
    os_system("cls" if os_name == "nt" else "clear")


def get_terminal_size() -> tuple[int, int]:
    """Return ``(columns, lines)`` of the current terminal, falling back to 80x24."""
    size = shutil.get_terminal_size((80, 24))
    return size.columns, size.lines


# -------------------------------------------------------------------------------------
# Main Clock Features
# -------------------------------------------------------------------------------------

def start_countdown(duration: str, count_up: bool = False, title: str = "") -> None:
    """Run a centered ASCII-art countdown (or count-up) of ``duration`` until 'Q' or Ctrl+C."""
    font = read_figlet_font()
    total_seconds = parse_time_string(duration)
    elapsed = 0

    print(Colors.info(f"[*] Starting Countdown: {title if title else duration}"))
    time.sleep(1)

    try:
        while total_seconds > 0:
            display_time = elapsed if count_up else total_seconds
            t_str = str(datetime.timedelta(seconds=int(display_time)))
            fig_text = convert_text_to_ascii(t_str, font)
            clear_screen()
            width, height = get_terminal_size()
            print("\n" * max(0, (height // 2) - 5))
            for line in fig_text.splitlines():
                print(Colors.GREEN + " " * max(0, (width - len(line)) // 2) + line + Colors.RESET)
            if title:
                title_fig = convert_text_to_ascii(title, font)
                print()
                for line in title_fig.splitlines():
                    print(Colors.YELLOW + " " * max(0, (width - len(line)) // 2) + line + Colors.RESET)

            time.sleep(1)
            if count_up:
                elapsed += 1
                if elapsed >= total_seconds:
                    break
            else:
                total_seconds -= 1

            # Check for 'Q' key
            if kbhit():
                key = getch()
                if key == 'Q':
                    clear_screen()
                    print(Colors.error("\n[!] Countdown Aborted!"))
                    return

        clear_screen()
        print(Colors.success("\n[+] Countdown Complete!"))
    except KeyboardInterrupt:
        clear_screen()
        print(Colors.error("\n[!] Countdown Aborted!"))
        return


def start_stopwatch(title: str = "") -> None:
    """Run an ASCII-art stopwatch counting up from 00:00:00; 'P' toggles pause, 'Q' quits."""
    font = read_figlet_font()
    elapsed = 0
    is_paused = False

    print(Colors.info(f"[*] Starting Stopwatch: {title if title else 'Timer'}"))
    time.sleep(1)

    try:
        while True:
            if not is_paused:
                t_str = str(datetime.timedelta(seconds=int(elapsed)))
                fig_text = convert_text_to_ascii(t_str, font)
                clear_screen()
                width, height = get_terminal_size()
                print("\n" * max(0, (height // 2) - 5))
                for line in fig_text.splitlines():
                    print(Colors.GREEN + " " * max(0, (width - len(line)) // 2) + line + Colors.RESET)
                if title:
                    title_fig = convert_text_to_ascii(title, font)
                    print()
                    for line in title_fig.splitlines():
                        print(Colors.YELLOW + " " * max(0, (width - len(line)) // 2) + line + Colors.RESET)
                time.sleep(1)
                elapsed += 1
            else:
                time.sleep(0.1)  # Poll faster when paused

            # Check for keys
            if kbhit():
                key = getch()
                if key == 'Q':
                    clear_screen()
                    print(Colors.error("\n[!] Stopwatch Aborted!"))
                    return
                elif key == 'P':
                    is_paused = not is_paused
    except KeyboardInterrupt:
        clear_screen()
        print(Colors.error("\n[!] Stopwatch Aborted!"))
        return


def get_wall_clock(title: str = "", timezone: str = "Local", use_24: bool = False) -> None:
    """Display a live ASCII-art wall clock in the given timezone until 'Q' or Ctrl+C."""
    font = read_figlet_font()

    print(Colors.info(f"[*] Starting Wall Clock: {title if title else 'Current Time'}"))
    time.sleep(1)

    try:
        while True:
            now = dt.now(datetime.timezone.utc)
            if timezone != "Local":
                try:
                    from zoneinfo import ZoneInfo
                    now = now.astimezone(ZoneInfo(timezone))
                except Exception:
                    print(Colors.warning(f"[!] Invalid timezone: {timezone}, defaulting to local."))
            else:
                now = dt.now()
            time_str = now.strftime("%H:%M:%S" if use_24 else "%I:%M:%S %p")
            fig_text = convert_text_to_ascii(time_str, font)
            clear_screen()
            width, height = get_terminal_size()
            print("\n" * max(0, (height // 2) - 5))
            for line in fig_text.splitlines():
                print(Colors.CYAN + " " * max(0, (width - len(line)) // 2) + line + Colors.RESET)
            if title:
                title_fig = convert_text_to_ascii(title, font)
                print()
                for line in title_fig.splitlines():
                    print(Colors.YELLOW + " " * max(0, (width - len(line)) // 2) + line + Colors.RESET)
            time.sleep(1)

            # Check for 'Q' key
            if kbhit():
                key = getch()
                if key == 'Q':
                    clear_screen()
                    print(Colors.error("\n[!] Clock Display Aborted!"))
                    return
    except KeyboardInterrupt:
        clear_screen()
        print(Colors.error("\n[!] Clock Display Aborted!"))
        return


# -------------------------------------------------------------------------------------
# CLI Interface
# -------------------------------------------------------------------------------------

def main() -> int:
    """Parse CLI args and dispatch to countdown/stopwatch/wall-clock subcommands."""
    parser = argparse.ArgumentParser(
        prog='clock',
        description="MKAbuMattar's Clock Manifest CLI — A terminal utility for countdowns, stopwatch, and wall clocks."
    )
    subparsers = parser.add_subparsers(dest='command', help='Available commands')

    # Countdown
    countdown_parser = subparsers.add_parser('countdown', aliases=['cd'], help='Start a countdown timer')
    countdown_parser.add_argument('-d', '--duration', type=str, required=True,
                                  help='Duration (e.g., "25s", "5m", "1h", or "02:15PM")')
    countdown_parser.add_argument('-t', '--title', type=str, default='', help='Title to display above the timer')
    countdown_parser.add_argument('-u', '--countup', action='store_true', help='Count up instead of down')

    # Stopwatch
    stopwatch_parser = subparsers.add_parser('stopwatch', aliases=['sw'], help='Start a stopwatch')
    stopwatch_parser.add_argument('-t', '--title', type=str, default='', help='Title to display above the stopwatch')

    # Wall Clock
    wallclock_parser = subparsers.add_parser('wallclock', aliases=['wc', 'clock'], help='Display a live wall clock')
    wallclock_parser.add_argument('-t', '--title', type=str, default='', help='Title to display above the clock')
    wallclock_parser.add_argument('--24hour', action='store_true', help='Use 24-hour format')
    wallclock_parser.add_argument('-z', '--timezone', type=str, default='Local',
                                  help='Timezone (e.g., "UTC", "Asia/Amman", "Local")')

    args = parser.parse_args()

    if args.command in ['countdown', 'cd']:
        start_countdown(args.duration, args.countup, args.title)
    elif args.command in ['stopwatch', 'sw']:
        start_stopwatch(args.title)
    elif args.command in ['wallclock', 'wc', 'clock']:
        get_wall_clock(args.title, args.timezone, args.__dict__.get('24hour', False))
    else:
        parser.print_help()
    return 0


# -------------------------------------------------------------------------------------
# Entry Point
# -------------------------------------------------------------------------------------

if __name__ == "__main__":
    sys.exit(main())
