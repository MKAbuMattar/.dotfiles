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
#       This Module provides a set of functions to display a matrix rain animation
#       in the console, simulating the falling green characters from the movie "The Matrix".
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/{REPO_NAME}
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

"""
Matrix Rain Animation

Displays a matrix rain animation in the console, simulating the falling
green characters from the movie "The Matrix". The animation can be stopped
by pressing the "Q" key.

Usage:
    python3 main.py [--sleep SLEEP_TIME]
"""

from __future__ import annotations

import argparse
import logging
import platform
import random
import sys
import time
from os import system as os_system
from pathlib import Path

logger = logging.getLogger(__name__)
SCRIPT_DIR = Path(__file__).resolve().parent


# Check if running on Windows
IS_WINDOWS = platform.system() == "Windows"

if IS_WINDOWS:
    import msvcrt
else:
    import select
    import tty
    from termios import TCSADRAIN, tcgetattr, tcsetattr


class MatrixRain:
    """Matrix rain animation class."""

    def __init__(self, sleep_time: float = 50) -> None:
        """
        Initialize the Matrix Rain animation.

        Args:
            sleep_time (float): Time in milliseconds to wait between updates (default: 50)
        """
        self.sleep_time = sleep_time / 1000.0  # Convert to seconds
        self.characters = (
            "ァアィイゥウェエォオカガキギクグケゲコゴサコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノ"
            "ハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺ・ーヽヾ"
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
        )
        self.running = True
        self.cols_map = {}

        # Get terminal size
        self.update_terminal_size()

    def update_terminal_size(self) -> None:
        """Update terminal dimensions."""
        import shutil
        size = shutil.get_terminal_size()
        self.cols = size.columns
        self.lines = size.lines

    def clear_screen(self) -> None:
        """Clear the terminal screen."""
        if IS_WINDOWS:
            os_system('cls')
        else:
            os_system('clear')

    def move_cursor(self, line: int, col: int) -> None:
        """
        Move cursor to specific position.

        Args:
            line (int): Line number
            col (int): Column number
        """
        sys.stdout.write(f"\033[{line};{col}H")

    def set_color(self, intensity: int) -> None:
        """
        Set text color with different intensities.

        Args:
            intensity (int): 0=dim, 1=bright, 2=very dim
        """
        if intensity == 1:
            sys.stdout.write("\033[1;32m")  # Bright green
        elif intensity == 2:
            sys.stdout.write("\033[2;32m")  # Dim green
        else:
            sys.stdout.write("\033[0;32m")  # Normal green

    def check_key_press(self) -> bool:
        """Check if a key has been pressed (non-blocking)."""
        if IS_WINDOWS:
            if msvcrt.kbhit():
                key = msvcrt.getch().decode('utf-8', errors='ignore').upper()
                return key == 'Q'
        else:
            # Unix-like systems
            if select.select([sys.stdin], [], [], 0)[0]:
                key = sys.stdin.read(1).upper()
                return key == 'Q'
        return False

    def run(self) -> None:
        """Start the matrix rain animation."""
        # Set terminal to non-canonical mode on Unix
        if not IS_WINDOWS:
            old_settings = tcgetattr(sys.stdin)
            try:
                tty.setcbreak(sys.stdin.fileno())
                self._run_animation()
            finally:
                tcsetattr(sys.stdin, TCSADRAIN, old_settings)
        else:
            self._run_animation()

    def _run_animation(self) -> None:
        """Internal method to run the animation loop."""
        # Set colors for Windows
        if IS_WINDOWS:
            os_system('color 0A')  # Black background, green text

        self.clear_screen()

        # Hide cursor
        sys.stdout.write("\033[?25l")
        sys.stdout.flush()

        try:
            # Initialize multiple drops per update for better visual effect
            drops_per_update = max(1, self.cols // 10)

            while self.running:
                # Update multiple columns per iteration
                for _ in range(drops_per_update):
                    # Get random column and character
                    random_col = random.randint(1, self.cols)
                    random_char = random.choice(self.characters)

                    # Initialize column if not exists
                    if random_col not in self.cols_map:
                        self.cols_map[random_col] = 0

                    line = self.cols_map[random_col]

                    # Reset column if it reaches the bottom
                    if line >= self.lines:
                        for clear_line in range(1, self.lines + 1):
                            self.move_cursor(clear_line, random_col)
                            sys.stdout.write(" ")
                        self.cols_map[random_col] = 0
                        line = 0

                    # Increment line for this column
                    self.cols_map[random_col] += 1
                    line = self.cols_map[random_col]

                    # Draw bright character at current position
                    self.move_cursor(line, random_col)
                    self.set_color(1)
                    sys.stdout.write(random_char)

                    # Draw normal character one line above
                    if line > 1:
                        self.move_cursor(line - 1, random_col)
                        self.set_color(0)
                        sys.stdout.write(random_char)

                    # Draw dim character two lines above
                    if line > 2:
                        self.move_cursor(line - 2, random_col)
                        self.set_color(2)
                        sys.stdout.write(random_char)

                    # Erase character several lines above to create trail effect
                    if line > 15:
                        self.move_cursor(line - 15, random_col)
                        sys.stdout.write(" ")

                # Reset cursor position
                self.move_cursor(1, 1)

                sys.stdout.flush()

                # Sleep
                time.sleep(self.sleep_time)

                # Check for quit key
                if self.check_key_press():
                    self.running = False
                    break

        except KeyboardInterrupt:
            self.running = False
        finally:
            # Show cursor
            sys.stdout.write("\033[?25h")
            # Reset colors
            sys.stdout.write("\033[0m")
            sys.stdout.flush()
            self.clear_screen()
            print("\n\033[1;31mMatrix Animation Stopped!\033[0m")


def main() -> int:
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Display a Matrix rain animation in the terminal.",
        prog="matrix.py",
        epilog="Press 'Q' to stop the animation."
    )

    parser.add_argument(
        "--sleep", "-s",
        type=float,
        default=50,
        help="Time in milliseconds to wait between updates (default: 50)"
    )

    args = parser.parse_args()

    # Validate sleep time
    if args.sleep < 0:
        print("\033[1;31mError: Sleep time must be positive.\033[0m")
        sys.exit(1)

    # Create and run matrix animation
    matrix = MatrixRain(sleep_time=args.sleep)
    matrix.run()
    return 0


if __name__ == "__main__":
    sys.exit(main())
