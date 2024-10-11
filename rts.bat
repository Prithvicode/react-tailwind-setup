@echo off
@REM setlocal enabledelayedexpansion

:: Prompt for project name and TypeScript option
set /p userInput=Enter project-name and TypeScript option (e.g., my-project t or my-project j): 

for /f "tokens=1,2" %%a in ("%userInput%") do (
    set projectName=%%a
    set useTypescript=%%b
)

:: Determine the template and app extension 
if /i "%useTypescript%"=="t" (
    set tsOption="react-ts"
    set appExt=src/App.tsx
) else (
    set tsOption="react"
    set appExt=src/App.jsx
)

:: Create Project
echo Creating project: %projectName%

:: Call npx to create the Vite project
call npx create-vite@latest %projectName% --template %tsOption% --yes >nul 

:: Navigate into the project directory
cd "%projectName%" || (
    echo Failed to change directory to %projectName%. Exiting...
    pause
    exit /b 1
)

echo Installing dependencies...
call npm install >nul

:: Check if npm install succeeded
if errorlevel 1 (
    echo Failed to install dependencies. Please check the above error messages.
    pause
    exit /b 1
)
echo Dependencies installed successfully.

:: Open project in IDE

:: Install Tailwind CSS and PostCSS
echo Installing Tailwind CSS...
call npm install -D tailwindcss postcss autoprefixer

:: Initialize Tailwind CSS
call npx tailwindcss init -p

:: Create the tailwind.config.js file
echo /** @type ^{import('tailwindcss').Config} */ > tailwind.config.js
echo export default { >> tailwind.config.js
echo   content: [ >> tailwind.config.js
echo     "./index.html", >> tailwind.config.js
echo     "./src/**/*.{js,jsx,ts,tsx}", >> tailwind.config.js
echo   ], >> tailwind.config.js
echo   theme: { >> tailwind.config.js
echo     extend: {}, >> tailwind.config.js
echo   }, >> tailwind.config.js
echo   plugins: [], >> tailwind.config.js
echo }; >> tailwind.config.js

echo Configured tailwind.config.js

:: Add Tailwind directives to your CSS file

echo @tailwind base; > src/index.css
echo @tailwind components; >> src/index.css
echo @tailwind utilities; >> src/index.css

echo Configured index.css



@REM set appExt=src/App.jsx

:: Initialize the App component; escape sequence from hell
(
    echo import React from "react"; > %appExt%
    echo const App = ^(^) =^> ^{ >> %appExt%
    echo   return ^(^<div className="bg-blue-400"^>Hello Prithvi!^</div^>^); >> %appExt%
    echo ^}; >> %appExt%
    echo export default App; >> %appExt%
)



echo Boilerplate app created
:: Open project in IDE
call code .
:: Run npm dev to start the development server
echo Running npm run dev
call npm run dev


pause
