$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$Build = Join-Path $Root "build\nova-cpp"
cmake -S (Join-Path $Root "interfaces\cpp") -B $Build
cmake --build $Build --config Release
ctest --test-dir $Build --output-on-failure
