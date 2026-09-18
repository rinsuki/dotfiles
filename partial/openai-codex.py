import tomlkit
import os

with open(os.environ["HOME"] + "/.codex/config.toml", "r") as f:
    config = tomlkit.load(f)

config["personality"] = "pragmatic"
config["approvals_reviewer"] = "user"
config["approval_policy"] = "on-request"
config["service_tier"] = "default"
config["model_reasoning_summary"] = "detailed"
config["default_permissions"] = "editor_base"
config["include_permissions_instructions"] = False

config["permissions"] = {
    "editor_base": {
        "filesystem": {
            ":minimal": "read",
            ":tmpdir": "write",
            "/Library": "read",
            "/System/Cryptexes": "read",
            "/Applications": "read",
            "/System/Volumes/Preboot": "read",
            "/System/Library/OpenSSL": "read",
            "/opt/homebrew": "read",

            "~/dotfiles": "read",
            "~/.cargo": "read",
            "~/.codex/skills": "read",
            "~/.agents/skills": "read",
            "~/.gitconfig": "read",
            "~/.gitignore_global": "read",
            "~/.bin": "read",
            "~/.rustup": "read",
            "~/go/bin": "read",

            "~/Library/Caches/cargo-build-dir": "write",
            ":workspace_roots": {
                ".": "write",
                "Cargo.lock": "read",
                "Cargo.toml": "read",
                "package.json": "read",
                "node_modules": "read",
                ".sqlx/**": "read",
            }
        },
        "network": {
            "enabled": True,
        },
    }
}

config["features"] = {
    "js_repl": True,
    "apps": False,
    "network_proxy": True,

    "multi_agent_v2": {
        "hide_spawn_agent_metadata": False,
        "tool_namespace": "agents",
    }
}

config["tui"] = {
    "status_line": [
        "model-with-reasoning",
        "current-dir",
        "git-branch",
        "approval-mode",
        "context-used",
        "five-hour-limit",
        "weekly-limit",
        "fast-mode",
        "task-progress",
        "permissions",
        "context-window-size",
    ],
    "status_line_use_colors": True,
    "animations": False,
}

config["hooks"] = {
    "state": config.get("hooks", {}).get("state"),
    "PreToolUse": [
        {
            "matcher": "^Bash$",
            "hooks": [{
                "type": "command",
                "command": '~/dotfiles/home/.bin/hooks/deny-cargo-build-dir.py',
                "timeout": 30,
                "statusMessage": "deny-cargo-build-dir",
            }]
        }
    ],
    "PostToolUse": [
        {
            "matcher": "^Bash$",
            "hooks": [{
                "type": "command",
                "command": '~/dotfiles/home/.bin/hooks/check-rust-sqlx-fail.py',
                "timeout": 30,
                "statusMessage": "check-rust-sqlx-fail",
            }]
        }
    ]
}

with open(os.environ["HOME"] + "/.codex/config.toml.new", "w") as f:
    tomlkit.dump(config, f)
os.rename(os.environ["HOME"] + "/.codex/config.toml.new", os.environ["HOME"] + "/.codex/config.toml")
