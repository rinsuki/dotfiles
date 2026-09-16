#!/usr/bin/env python3

import json
import sys

def main() -> None:
    try:
        event = json.load(sys.stdin)
    except (json.JSONDecodeError, UnicodeDecodeError):
        return

    command = event.get("tool_input", {}).get("command", "")
    if not isinstance(command, str):
        return

    if "CARGO_BUILD_BUILD_DIR=" in command or "CARGO_TARGET_DIR=" in command:
        print(
            json.dumps(
                {
                    "decision": "block",
                    "reason": "Do not set CARGO_BUILD_BUILD_DIR or CARGO_TARGET_DIR; use the configured Cargo build directory.",
                }
            )
        )


if __name__ == "__main__":
    main()
