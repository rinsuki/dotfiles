cd /d %~dp0
powershell Start-Process powershell -Verb runas -ArgumentList "\"-NoProfile -ExecutionPolicy Unrestricted %~dp0\win-uninstall-apps-vm.ps1\""
