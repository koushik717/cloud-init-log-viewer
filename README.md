# cloud-init Log Viewer

A Flutter Web tool for visualizing cloud-init boot logs.

Paste a cloud-init log and see each boot stage and module as an 
interactive timeline. Identify slow modules, failed runs, and 
warnings at a glance.

**Live demo:** [add URL after deployment]

## Screenshot
[add screenshot]

## Why this exists

`cloud-init status --wait` blocks indefinitely when initialization 
stalls. PR #6796 on canonical/cloud-init adds a --timeout flag to 
fix that. This tool is the next step: when something goes wrong 
during boot, this visualizer shows you exactly which module failed 
and why, directly from the log file.

## Features

- Paste any cloud-init log from /var/log/cloud-init.log
- Interactive stage timeline (init-local, init, modules:config, modules:final)
- Module list grouped by stage with success/warning/error status
- Per-module log line viewer with level highlighting  
- Duration bar chart showing slowest modules
- Search/filter across all modules
- Sample log included for immediate exploration
- Works entirely in the browser, no server needed

## Where to get a cloud-init log

On any Ubuntu cloud instance:
cat /var/log/cloud-init.log

Or collect all logs:
cloud-init collect-logs

## Tech stack

| | |
|---|---|
| Framework | Flutter Web |
| Language | Dart (null safety) |
| State | Provider |
| Charts | fl_chart |
| Target | Browser (no server needed) |

## Getting started

git clone https://github.com/koushik717/cloud-init-log-viewer
cd cloud-init-log-viewer
flutter pub get
flutter run -d chrome

## Running tests

flutter test

## Related

- [PR #6796 -- add --timeout to cloud-init status --wait](https://github.com/canonical/cloud-init/pull/6796)
- [cloud-init Builder -- visual YAML config builder](https://github.com/koushik717/cloud-init-builder)
- [cloud-init documentation](https://cloudinit.readthedocs.io/)
