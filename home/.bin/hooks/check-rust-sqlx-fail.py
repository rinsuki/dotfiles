#!/usr/bin/env python3

import json
import sys

SQLX_DATABASE_ERROR = "error communicating with database: Operation not permitted (os error 1)"
ADDITIONAL_MESSAGE = "The sandbox may be blocking access to the database. Please try running `cargo sqlx prepare` (with `--workspace` if you're using a Cargo workspace) to update the current query cache. This command should be exempt from the sandbox."

def main() -> None:
    try:
        event = json.load(sys.stdin)
    except (json.JSONDecodeError, OSError):
        return

    command = event.get("tool_input", {}).get("command", "")
    if not isinstance(command, str) or not ("cargo" in command or "rustc" in command):
        return

    result = json.dumps(event.get("tool_response", ""), ensure_ascii=False)
    if SQLX_DATABASE_ERROR not in result:
        return

    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PostToolUse",
                "additionalContext": ADDITIONAL_MESSAGE,
            }
        },
        sys.stdout,
        ensure_ascii=False,
    )
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
