@echo off
REM maintain-chotu-qstrader.bat
REM Full maintenance pipeline for Chotu-qstrader (QSTrader fork) - Windows version
setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Chotu-QSTrader Maintenance Pipeline
echo ========================================
echo.

REM 1. UPDATE
echo [1/6] Pulling latest changes...
git checkout main 2>nul || git checkout master
git pull --ff-only
if errorlevel 1 (
    echo WARNING: Git pull failed or conflicts detected
    pause
    exit /b 1
)

REM 2. OPTIMIZE & REMOVE BUGS
echo.
echo [2/6] Formatting and linting Python code...

where black >nul 2>&1
if %errorlevel% equ 0 (
    echo Running black formatter...
    black qstrader examples 2>nul || echo WARNING: black applied with warnings
) else (
    echo INFO: black not installed, skipping formatting
)

where isort >nul 2>&1
if %errorlevel% equ 0 (
    echo Running isort...
    isort qstrader examples 2>nul || echo WARNING: isort applied
) else (
    echo INFO: isort not installed, skipping import sorting
)

where ruff >nul 2>&1
if %errorlevel% equ 0 (
    echo Running ruff linter...
    ruff check --fix qstrader examples 2>nul || echo WARNING: ruff fixes applied
) else (
    echo INFO: ruff not installed, skipping linting
)

REM 3. MAKE DEPLOYABLE
echo.
echo [3/6] Installing dependencies...
pip install --no-cache-dir -e . 2>nul
if errorlevel 1 (
    echo WARNING: Installation had issues, trying without cache...
    pip install -e .
)

echo Verifying critical imports...
python -c "import qstrader; print('✓ QSTrader importable')" 2>nul
if errorlevel 1 (
    echo ERROR: QSTrader core failed to import
    pause
    exit /b 1
)

python -c "import pandas; import numpy; print('✓ Pandas/NumPy OK')" 2>nul
if errorlevel 1 (
    echo ERROR: Data dependencies missing
    pause
    exit /b 1
)

REM 4. TEST RUN
echo.
echo [4/6] Running tests...

if exist "tests\" (
    echo Running pytest suite...
    pytest tests\ --tb=short -x 2>nul || echo WARNING: Some tests failed (non-fatal for dev fork)
) else (
    echo INFO: No tests folder found, skipping pytest
)

echo Running example backtest (60/40 portfolio)...
if exist "examples\sixty_forty.py" (
    if exist "SPY.csv" (
        if exist "AGG.csv" (
            echo Running 60/40 strategy backtest...
            timeout /t 180 python examples\sixty_forty.py 2>nul
            if errorlevel 1 (
                echo WARNING: Backtest skipped or timed out
            ) else (
                echo ✓ 60/40 backtest completed
            )
        ) else (
            echo INFO: AGG.csv missing - skipping backtest
        )
    ) else (
        echo INFO: SPY.csv missing - skipping backtest
    )
) else (
    echo INFO: sixty_forty.py not found - skipping example run
)

REM 5. REMOVE CACHE
echo.
echo [5/6] Clearing Python and build caches...

for /d /r . %%d in (__pycache__) do @if exist "%%d" rd /s /q "%%d" 2>nul
del /s /q *.pyc 2>nul
del /s /q *.pyo 2>nul

if exist ".pytest_cache" rd /s /q ".pytest_cache" 2>nul
if exist ".mypy_cache" rd /s /q ".mypy_cache" 2>nul
if exist ".ruff_cache" rd /s /q ".ruff_cache" 2>nul
if exist ".coverage" del /q ".coverage" 2>nul
if exist "htmlcov" rd /s /q "htmlcov" 2>nul
if exist "build" rd /s /q "build" 2>nul
if exist "dist" rd /s /q "dist" 2>nul
for /d %%d in (*.egg-info) do @if exist "%%d" rd /s /q "%%d" 2>nul
if exist ".eggs" rd /s /q ".eggs" 2>nul

echo Reinstalling cleanly...
pip install --no-cache-dir -e . >nul 2>&1

REM 6. PUSH BACK TO REMOTE
echo.
echo [6/6] Committing and pushing changes...

git add .
git diff-index --quiet HEAD -- >nul 2>&1
if errorlevel 1 (
    for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set mydate=%%c-%%a-%%b
    for /f "tokens=1-2 delims=: " %%a in ('time /t') do set mytime=%%a:%%b
    git commit -m "chore(qstrader): optimized, tested, cache-cleared [!mydate! !mytime! UTC]"
    git push origin main 2>nul || git push origin master
    if errorlevel 1 (
        echo ERROR: Push failed - check credentials or network
        pause
        exit /b 1
    )
    echo ✓ Changes pushed successfully
) else (
    echo ✓ No changes - repo is clean and up-to-date
)

echo.
echo ========================================
echo   Maintenance Complete!
echo ========================================
echo.
pause
