@echo off
setlocal

cargo --version
if errorlevel 1 exit /b 1
rustc --version
if errorlevel 1 exit /b 1
cargo build --release
if errorlevel 1 exit /b 1
cargo test --release
if errorlevel 1 exit /b 1
if not exist "build\release\hello.exe" exit /b 1
if errorlevel 1 exit /b 1
"build\release\hello.exe"
if errorlevel 1 exit /b 1
if not exist "dist" mkdir "dist"
if errorlevel 1 exit /b 1
copy /Y "build\release\hello.exe" "dist\hello.exe" >nul
if errorlevel 1 exit /b 1

exit /b 0
