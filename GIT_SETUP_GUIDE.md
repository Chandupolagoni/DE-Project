# Git Setup and Repository Push Guide

## Prerequisites

Before pushing to a remote repository, you need to have Git installed and configured.

### 1. Install Git (if not already installed)

**Windows:**
- Download Git from: https://git-scm.com/download/win
- Or install via Chocolatey: `choco install git`
- Or install via winget: `winget install Git.Git`

**macOS:**
- Install via Homebrew: `brew install git`
- Or download from: https://git-scm.com/download/mac

**Linux:**
- Ubuntu/Debian: `sudo apt install git`
- CentOS/RHEL: `sudo yum install git`

### 2. Configure Git (if not already configured)

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Repository Setup Options

### Option 1: GitHub Repository

1. **Create a new repository on GitHub:**
   - Go to https://github.com
   - Click "New repository"
   - Name: `azure-databricks-data-engineering`
   - Description: `Azure Databricks Data Engineering Project`
   - Make it Public or Private as needed
   - Don't initialize with README (we already have files)

2. **Connect local repository to GitHub:**
   ```bash
   cd azure-databricks-data-engineering
   git init
   git add .
   git commit -m "Initial commit: Azure Databricks Data Engineering Project"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/azure-databricks-data-engineering.git
   git push -u origin main
   ```

### Option 2: Azure DevOps Repository

1. **Create a new repository in Azure DevOps:**
   - Go to your Azure DevOps organization
   - Create a new project or use existing
   - Go to Repos → New repository
   - Name: `azure-databricks-data-engineering`

2. **Connect local repository to Azure DevOps:**
   ```bash
   cd azure-databricks-data-engineering
   git init
   git add .
   git commit -m "Initial commit: Azure Databricks Data Engineering Project"
   git branch -M main
   git remote add origin https://dev.azure.com/YOUR_ORG/YOUR_PROJECT/_git/azure-databricks-data-engineering
   git push -u origin main
   ```

### Option 3: GitLab Repository

1. **Create a new repository on GitLab:**
   - Go to your GitLab instance
   - Click "New project" → "Create blank project"
   - Name: `azure-databricks-data-engineering`

2. **Connect local repository to GitLab:**
   ```bash
   cd azure-databricks-data-engineering
   git init
   git add .
   git commit -m "Initial commit: Azure Databricks Data Engineering Project"
   git branch -M main
   git remote add origin https://gitlab.com/YOUR_USERNAME/azure-databricks-data-engineering.git
   git push -u origin main
   ```

## Step-by-Step Commands

Once you have Git installed and a remote repository created, run these commands:

```bash
# Navigate to project directory
cd azure-databricks-data-engineering

# Initialize Git repository
git init

# Add all files to staging
git add .

# Create initial commit
git commit -m "Initial commit: Azure Databricks Data Engineering Project

- Complete Azure Databricks data engineering solution
- Medallion architecture (Bronze-Silver-Gold)
- Infrastructure as Code with Terraform
- Data ingestion, transformation, and quality pipelines
- Comprehensive testing and documentation
- Production-ready with monitoring and security"

# Set main branch
git branch -M main

# Add remote origin (replace with your repository URL)
git remote add origin https://github.com/YOUR_USERNAME/azure-databricks-data-engineering.git

# Push to remote repository
git push -u origin main
```

## Authentication

### GitHub
- Use Personal Access Token (recommended)
- Or use GitHub CLI: `gh auth login`

### Azure DevOps
- Use Personal Access Token
- Or use Azure CLI: `az login`

### GitLab
- Use Personal Access Token
- Or use GitLab CLI: `glab auth login`

## Verification

After pushing, verify the repository:

1. **Check remote repository** - Visit your repository URL
2. **Verify all files are present** - Check that all project files are uploaded
3. **Test cloning** - Try cloning the repository to a different location

```bash
# Test clone (in a different directory)
git clone https://github.com/YOUR_USERNAME/azure-databricks-data-engineering.git test-clone
```

## Repository Structure Verification

Your repository should contain:

```
azure-databricks-data-engineering/
├── README.md
├── LICENSE
├── Makefile
├── .gitignore
├── PROJECT_SUMMARY.md
├── GIT_SETUP_GUIDE.md
├── infrastructure/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   └── README.md
├── databricks/
│   ├── 01_data_ingestion.py
│   ├── 02_data_transformation.py
│   └── 03_data_quality.py
├── data-factory/
│   ├── pipeline_ingestion.json
│   ├── pipeline_transformation.json
│   └── linked_service_databricks.json
├── src/
│   ├── __init__.py
│   ├── data_ingestion.py
│   ├── data_transformation.py
│   └── data_quality.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_data_ingestion.py
│   ├── test_data_transformation.py
│   └── test_data_quality.py
├── config/
│   ├── config.yaml
│   └── requirements.txt
├── scripts/
│   ├── deploy_infrastructure.py
│   ├── deploy_databricks.py
│   └── run_pipeline.py
└── docs/
    ├── architecture.md
    └── deployment.md
```

## Troubleshooting

### Common Issues:

1. **Git not found**: Install Git and restart terminal
2. **Authentication failed**: Check credentials or use Personal Access Token
3. **Repository not found**: Verify repository URL and permissions
4. **Large files**: Check .gitignore for large files that shouldn't be committed

### Useful Commands:

```bash
# Check Git status
git status

# Check remote configuration
git remote -v

# View commit history
git log --oneline

# Check file sizes
git ls-files | xargs ls -lh

# Remove large files if needed
git rm --cached large-file.txt
```

## Next Steps

After successfully pushing to the repository:

1. **Set up CI/CD** - Configure GitHub Actions, Azure DevOps Pipelines, or GitLab CI
2. **Add collaborators** - Invite team members to the repository
3. **Create issues** - Set up project management and issue tracking
4. **Set up branch protection** - Protect main branch and require reviews
5. **Configure webhooks** - Set up notifications for deployments

## Repository URLs

Replace `YOUR_USERNAME` and `YOUR_ORG` with your actual values:

- **GitHub**: `https://github.com/YOUR_USERNAME/azure-databricks-data-engineering.git`
- **Azure DevOps**: `https://dev.azure.com/YOUR_ORG/YOUR_PROJECT/_git/azure-databricks-data-engineering`
- **GitLab**: `https://gitlab.com/YOUR_USERNAME/azure-databricks-data-engineering.git`
