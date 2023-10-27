# needed to allow openapi generator to run on xcode cloud
# https://developer.apple.com/forums/thread/732893
#!/usr/bin/env bash
set -euo pipefail

defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

