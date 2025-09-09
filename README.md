# Azure Databricks Data Engineering Project

A comprehensive, production-ready data engineering solution built on Azure and Databricks for modern data processing and analytics.

## 🏗️ Architecture Overview

This project implements a modern data engineering pipeline with the following components:

- **Azure Data Lake Storage Gen2**: Raw and processed data storage
- **Azure Databricks**: Data processing and transformation engine
- **Azure Data Factory**: Pipeline orchestration and scheduling
- **Azure Key Vault**: Secrets and configuration management
- **Azure SQL Database**: Data warehouse for analytics
- **Azure Monitor**: Logging and monitoring

## 📁 Project Structure

```
├── infrastructure/           # Infrastructure as Code (Terraform)
├── databricks/              # Databricks notebooks and jobs
├── data-factory/            # Azure Data Factory pipelines
├── src/                     # Python source code
├── tests/                   # Unit and integration tests
├── config/                  # Configuration files
├── docs/                    # Documentation
└── scripts/                 # Deployment and utility scripts
```

## 🚀 Quick Start

### Prerequisites
- Azure CLI installed and configured
- Terraform >= 1.0
- Python 3.8+
- Databricks CLI

### 1. Deploy Infrastructure
```bash
cd infrastructure
terraform init
terraform plan
terraform apply
```

### 2. Deploy Databricks Assets
```bash
cd databricks
databricks workspace import_dir . /Shared/data-engineering-project
```

### 3. Run Data Pipeline
```bash
python scripts/run_pipeline.py
```

## 📊 Data Flow

1. **Ingestion**: Raw data from various sources (CSV, JSON, APIs)
2. **Bronze Layer**: Raw data storage with minimal processing
3. **Silver Layer**: Cleaned and validated data
4. **Gold Layer**: Aggregated and business-ready datasets
5. **Analytics**: Data served to downstream applications

## 🛠️ Technologies Used

- **Azure Services**: Data Lake Storage, Databricks, Data Factory, Key Vault
- **Languages**: Python, SQL, Scala
- **Frameworks**: PySpark, Delta Lake, Great Expectations
- **Infrastructure**: Terraform, ARM templates
- **Monitoring**: Azure Monitor, Application Insights

## 📈 Features

- ✅ Automated data ingestion from multiple sources
- ✅ Data quality validation and monitoring
- ✅ Incremental data processing
- ✅ Error handling and retry mechanisms
- ✅ Cost optimization with auto-scaling clusters
- ✅ Security with Azure AD integration
- ✅ Comprehensive logging and monitoring

## 🔧 Configuration

Update the configuration files in the `config/` directory with your Azure subscription details and environment-specific settings.

## 📚 Documentation

Detailed documentation is available in the `docs/` directory:
- [Architecture Guide](docs/architecture.md)
- [Deployment Guide](docs/deployment.md)
- [Git Setup Guide](GIT_SETUP_GUIDE.md)

## 🚀 Push to Repository

To push this project to a Git repository:

### Option 1: Use the automated script
```bash
# Windows Batch
push_to_repo.bat

# PowerShell
.\push_to_repo.ps1
```

### Option 2: Manual Git commands
```bash
git init
git add .
git commit -m "Initial commit: Azure Databricks Data Engineering Project"
git branch -M main
git remote add origin YOUR_REPOSITORY_URL
git push -u origin main
```

See [GIT_SETUP_GUIDE.md](GIT_SETUP_GUIDE.md) for detailed instructions.

## 🧪 Testing

```bash
# Run unit tests
make test

# Run integration tests
make test-integration

# Run all tests with coverage
make test-all
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Project Summary

This project provides a complete, enterprise-grade data engineering solution with:

- **2000+ lines of production code**
- **Complete Azure infrastructure setup**
- **Scalable data processing pipelines**
- **Data quality monitoring**
- **Automated deployment**
- **Comprehensive testing**
- **Full documentation**

See [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for a complete overview of what's included.

## 📞 Support

For questions or issues:
- Check the documentation in the `docs/` directory
- Review the troubleshooting section in `docs/deployment.md`
- Examine the test cases for usage examples