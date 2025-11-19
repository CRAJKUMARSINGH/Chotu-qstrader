@echo off
REM ============================================================================
REM ONE-CLICK LOCAL RUN SCRIPT FOR CHOTU-QSTRADER
REM ============================================================================
REM Last Updated: 2025-11-15
REM ============================================================================

cls
echo ============================================================================
echo           CHOTU-QSTRADER - QUANTITATIVE TRADING FRAMEWORK
echo ============================================================================
echo.
echo Starting Chotu-qstrader (Quantitative Trading Framework)...
echo.

REM Check if virtual environment exists
if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
    if errorlevel 1 (
        echo ERROR: Failed to create virtual environment
        echo Please ensure Python is installed and in PATH
        pause
        exit /b 1
    )
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate
if errorlevel 1 (
    echo ERROR: Failed to activate virtual environment
    pause
    exit /b 1
)

REM Install dependencies
echo.
echo Installing dependencies...
pip install qstrader

echo.
echo ============================================================================
echo Available example strategies:
echo ============================================================================
dir /b examples\*.py
echo.
echo ============================================================================
set /p strategy="Enter strategy filename (e.g., sixty_forty.py): "

if exist examples\%strategy% (
    echo.
    echo Running strategy: %strategy%
    echo.
    python examples\%strategy%
) else (
    echo.
    echo ERROR: Strategy file not found: examples\%strategy%
    echo.
)

pause
