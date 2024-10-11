@echo off
set /p userInput=Enter project-name and TypeScript option (e.g., my-project t or my-project j): 

for /f "tokens=1,2" %%a in ("%userInput%") do (
    set projectName=%%a
    set useTypescript=%%b
)

:: Determine the template 
if /i "%useTypescript%"=="t" (
    set tsOption="react-ts"
) else (
    set tsOption="react"
)

::CreateProject
echo Creating project: %projectName%

:::: calls separate bat file and return to original; avoid exit. 
call npx create-vite@latest %projectName% --template %tsOption% --yes >nul 

:: Navigate into the project directory
cd "%projectName%" || (
    echo Failed to change directory to %projectName%. Exiting...
    pause
    exit /b 1
)

::echo Succsesfully changed directory to %projectName%.

echo Installing dependencies...
npm install >nul

:: Check if npm install succeeded
if errorlevel 1 (
    echo Failed to install dependencies. Please check the above error messages.
    pause
    exit /b 1
)
echo Dependencies installed successfully.
pause


:: Open project in IDE.
:: npm run dev and open in browser. 
:: Install tailwind and config.