# AcmeMart-Data-Warehouse

A centralized, end-to-end data warehouse pipeline to ingest, transform, and analyse retail transaction data. Built for **AcmeMart**, a mid-sized retail and e-commerce company operating both physical stores and an online shopping platform. This project leverages a modern data stack to consolidate fragmented data sources into a single source of truth, enabling self-service analytics and proactive decision-making.

![Google Drive](https://img.shields.io/badge/Google_Drive-4285F4?style=for-the-badge&logo=googledrive&logoColor=white)
![Airbyte](https://img.shields.io/badge/Airbyte-615EFF?style=for-the-badge&logo=airbyte&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

---

## Table of Contents

- [AcmeMart-Data-Warehouse](#acmemart-data-warehouse)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
    - [Expected Outcomes](#expected-outcomes)
  - [Business Context](#business-context)
  - [Architecture](#architecture)
    - [Data Flow](#data-flow)
  - [Tech Stack](#tech-stack)
  - [Project Structure](#project-structure)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [Step 1 — Clone the repository](#step-1--clone-the-repository)

---

## Project Overview

AcmeMart generates large volumes of transaction data daily across in-store and online channels. This data was previously fragmented across multiple source files in Google Drive with no unified schema, making consistent reporting difficult.

This project addresses those challenges by building a structured batch data pipeline that:

- **Ingests** raw CSV files from Google Drive into Snowflake using Airbyte on a daily schedule
- **Transforms** raw data through staged cleaning, typing, and renaming using dbt
- **Models** data into fact and dimension tables following a star schema
- **Aggregates** key business metrics — sales by product, store performance, customer behaviour trends
- **Validates** data quality through dbt tests at every layer
- **Documents** all models, columns, and lineage via the dbt docs site

### Expected Outcomes

- **Centralised data warehouse** — single source of truth for all retail transaction data
- **Clean fact and dimension tables** — structured, query-ready gold layer
- **Aggregated datasets** — pre-built summaries for reporting and dashboards
- **Improved data quality** — validated through automated dbt tests
- **Faster insight generation** — self-service SQL analytics on Snowflake
- **Reduced manual reporting** — replaces spreadsheet-based processes

---

## Business Context

**Company:** AcmeMart  
**Industry:** Retail & E-commerce  
**Core services:** In-store retail sales, online platform, customer management, supplier & product management

AcmeMart sells a wide range of consumer goods including groceries, household items, and personal care products. With growing transaction volume across multiple channels, the company needed a scalable data foundation to move from reactive reporting to proactive, data-driven decision-making.

**Key challenges this project solves:**

- **Data silos** — source files logically isolated in Google Drive with no integration layer
- **Limited analytics capability** — no unified view of sales by product, store, or customer
- **Manual reporting** — teams relying on spreadsheets causing delays and inconsistencies
- **Poor data quality** — inconsistent data types and formats across source files
- **No scalable data model** — no structured warehouse layer to support analytics

---

## Architecture

```
Google Drive (CSV files)
        │
        ▼
   Airbyte (batch ingestion · daily schedule)
        │
        ▼
┌─────────────────────────────────────────────┐
│           Snowflake Data Warehouse          │
│                                             │
│  BRONZE schema  ──►  Staging  ──►  Gold     │
│  (raw ingest)      (cleaned)   (fact+dim)   │
│                                     │       │
│                               Aggregates    │
│                                             │
│         dbt tests · dbt docs · Git          │
└─────────────────────────────────────────────┘
        │
        ▼
  SQL Analytics · BI Reporting · dbt Docs Site
```

### Data Flow

| Layer | Tool | Description |
|---|---|---|
| **Source** | Google Drive | Raw CSV files: transactions, customers, products, stores |
| **Ingestion** | Airbyte | Batch connector syncing CSVs to Snowflake BRONZE schema daily |
| **Bronze** | Snowflake | Raw landing zone — untransformed, all columns as VARCHAR |
| **Staging** | dbt | Cleaned, typed, renamed, deduplicated models |
| **Gold** | dbt | Fact and dimension tables following star schema |
| **Aggregates** | dbt | Pre-summarised metrics: sales by store, product, customer |
| **Validation** | dbt tests | not_null, unique, accepted_values, referential integrity |
| **Documentation** | dbt docs | Auto-generated lineage graph and data dictionary |
| **Version control** | Git / GitHub | All dbt models, tests, and schema YAML files |

---

## Tech Stack

| Tool | Purpose |
|---|---|
| **Google Drive** | Source file storage (CSV) |
| **Airbyte** | Data ingestion — Google Drive → Snowflake |
| **Snowflake** | Cloud data warehouse |
| **dbt** | Data transformation, modelling, testing, documentation |
| **Python** | Scripting and pipeline utilities |
| **Git / GitHub** | Version control |

---

## Project Structure

```
acmemart-data-warehouse/
├── models/
│   ├── staging/
│   │   ├── stg_transactions.sql
│   │   ├── stg_customers.sql
│   │   ├── stg_products.sql
│   │   ├── stg_stores.sql
│   │   └── schema.yml
│   ├── gold/
│   │   ├── fct_sales.sql
│   │   ├── dim_customers.sql
│   │   ├── dim_products.sql
│   │   ├── dim_stores.sql
│   │   └── schema.yml
│   └── aggregates/
│       ├── agg_sales_by_store.sql
│       ├── agg_sales_by_product.sql
│       ├── agg_customer_summary.sql
│       └── schema.yml
├── macros/
│   └── clean_string.sql
├── tests/
│   └── assert_positive_amounts.sql
├── dbt_project.yml
├── packages.yml
├── .gitignore
└── README.md
```

---

## Prerequisites

Ensure the following are in place before proceeding:

- [Snowflake account](https://signup.snowflake.com/) (free trial available)
- [Airbyte Cloud](https://airbyte.com/) account or self-hosted Airbyte instance
- [Google Drive](https://drive.google.com/) folder containing the source CSV files
- [dbt Core](https://docs.getdbt.com/docs/core/installation) installed locally (`pip install dbt-snowflake`)
- [Python 3.9+](https://www.python.org/)
- [Git](https://git-scm.com/)

Verify your dbt installation:

```bash
dbt --version
```

---

## Getting Started

### Step 1 — Clone the repository

```bash
git clone https://github.com/<your-username>/acmemart-data-warehouse.git
cd acmemart-data-warehouse
```
