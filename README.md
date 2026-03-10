# Projeto Censo & Eleições Brasil

Data engineering and analytics engineering project focused on modeling Brazilian census and election data using **dbt** and **BigQuery**, producing analytics-ready datasets for BI tools and data applications.

## Project Overview

This repository demonstrates a modern data stack workflow where public datasets available in BigQuery are transformed and modeled using dbt.

The goal is to structure raw data into well-organized analytical tables that can be easily consumed by business intelligence tools and data applications.

The project focuses on Brazilian demographic and electoral data, enabling analysis such as:

* Voting patterns across regions
* Demographic correlations with election results
* Regional political trends
* Population distribution and electoral behavior

## Architecture

The project follows a modern analytics engineering pipeline:

```
BigQuery Public Datasets
        ↓
dbt Transformations
        ↓
Analytics Data Models
        ↓
Power BI / Streamlit
```

## Tech Stack

* **BigQuery** – Data warehouse and data source
* **dbt (Data Build Tool)** – Data transformation and modeling
* **Python** – Supporting scripts and exploration
* **GitHub Codespaces** – Development environment
* **Power BI / Streamlit** – Data visualization and applications

## Project Structure

```
.
├── models
│   ├── staging
│   ├── intermediate
│   └── marts
│
├── seeds
├── dbt_project.yml
├── profiles.yml
├── requirements.txt
└── devcontainer.json
```

### Model Layers

**Staging**

Initial cleaning and standardization of source datasets.

Examples:

* municipality identifiers
* election result normalization
* demographic standardization

**Intermediate**

Business logic transformations and joins across datasets.

Examples:

* population metrics
* vote aggregation by region
* demographic enrichment

**Marts**

Analytics-ready fact and dimension tables optimized for BI tools.

Examples:

* fact_election_results
* dim_municipality
* dim_region

## Development Environment

This project is designed to run inside **GitHub Codespaces** using a pre-configured dev container.

The development environment includes:

* Python 3.11
* dbt-bigquery
* VS Code dbt extension
* BigQuery client libraries

## Authentication

Authentication with BigQuery is handled using a **Google Cloud service account** stored securely in GitHub Secrets.

Environment variable used:

```
GCP_SERVICE_ACCOUNT
```

This avoids storing credentials in the repository.

## Running the Project

Install dependencies:

```
pip install -r requirements.txt
```

Test the dbt connection:

```
dbt debug
```

Run models:

```
dbt run
```

Run tests:

```
dbt test
```

Generate documentation:

```
dbt docs generate
dbt docs serve
```

## Future Improvements

Planned enhancements include:

* Additional datasets from IBGE and TSE
* Feature engineering for political data analysis
* Data quality tests using dbt
* Interactive dashboards using Streamlit
* Power BI analytical dashboards

## Motivation

This project explores how modern data engineering tools can be used to structure large-scale public datasets into meaningful analytical models.

It also serves as a practical demonstration of an analytics engineering workflow combining **BigQuery, dbt, and BI tools**.

## License

MIT License
