@echo off
echo ========================================
echo Azure Databricks Data Engineering Project
echo Git Repository Push Script
echo ========================================
echo.

REM Check if Git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git is not installed or not in PATH
    echo Please install Git from https://git-scm.com/download/win
    echo Then restart this script
    pause
    exit /b 1
)

echo Git is installed. Proceeding with repository setup...
echo.

REM Initialize Git repository
echo Initializing Git repository...
git init
if %errorlevel% neq 0 (
    echo ERROR: Failed to initialize Git repository
    pause
    exit /b 1
)

REM Add all files
echo Adding files to Git...
git add .
if %errorlevel% neq 0 (
    echo ERROR: Failed to add files to Git
    pause
    exit /b 1
)

REM Create initial commit
echo Creating initial commit...
git commit -m "Initial commit: Azure Databricks Data Engineering Project

- Complete Azure Databricks data engineering solution
- Medallion architecture (Bronze-Silver-Gold)
- Infrastructure as Code with Terraform
- Data ingestion, transformation, and quality pipelines
- Comprehensive testing and documentation
- Production-ready with monitoring and security"
if %errorlevel% neq 0 (
    echo ERROR: Failed to create initial commit
    pause
    exit /b 1
)

REM Set main branch
echo Setting main branch...
git branch -M main
if %errorlevel% neq 0 (
    echo ERROR: Failed to set main branch
    pause
    exit /b 1
)

echo.
echo ========================================
echo Repository setup complete!
echo ========================================
echo.
echo Next steps:
echo 1. Create a repository on GitHub, Azure DevOps, or GitLab
echo 2. Copy the repository URL
echo 3. Run the following commands:
echo.
echo    git remote add origin YOUR_REPOSITORY_URL
echo    git push -u origin main
echo.
echo Example:
echo    git remote add origin https://github.com/username/azure-databricks-data-engineering.git
echo    git push -u origin main
echo.
echo For detailed instructions, see GIT_SETUP_GUIDE.md
echo.

REM Ask user if they want to add remote
set /p add_remote="Do you want to add a remote repository now? (y/n): "
if /i "%add_remote%"=="y" (
    set /p repo_url="Enter your repository URL: "
    if not "%repo_url%"=="" (
        echo Adding remote repository...
        git remote add origin %repo_url%
        if %errorlevel% neq 0 (
            echo ERROR: Failed to add remote repository
            echo Please check the URL and try again
            pause
            exit /b 1
        )
        
        echo Pushing to remote repository...
        git push -u origin main
        if %errorlevel% neq 0 (
            echo ERROR: Failed to push to remote repository
            echo Please check your credentials and repository permissions
            pause
            exit /b 1
        )
        
        echo.
        echo ========================================
        echo SUCCESS! Repository pushed successfully!
        echo ========================================
        echo.
        echo Your project is now available at: %repo_url%
    ) else (
        echo No repository URL provided. You can add it later using:
        echo git remote add origin YOUR_REPOSITORY_URL
        echo git push -u origin main
    )
) else (
    echo Remote repository not added. You can add it later using:
    echo git remote add origin YOUR_REPOSITORY_URL
    echo git push -u origin main
)

echo.
echo Repository setup complete!
pause
