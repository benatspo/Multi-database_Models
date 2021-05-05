# Multi-database Models
This repository is the replication package for the paper: "An Empirical Study of (Multi-) Database Models in Open-Source Projects"

It permits to (rebuild and/or) use the survey database to replicate the observed results, and to filter/update/complete the dataset.

## Survey database
The survey database is available on figshare, due to its size: [SQL_NoSQL_Survey.db](https://figshare.com/s/fb5c35279ab68ec52ffc)

Here is the description of the content of the different tables/views:
#### Tables
- `SQL_NOSQL_DATASET_REPOSITORIES`:
- `SQL_NOSQL_DBMS_TYPE_SURVIVAL`:
- `SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS`:
- `SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO`:
- `SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO_GLOBAL`:
- `SQL_NOSQL_DEPENDENCY`:
- `SQL_NOSQL_DISTINCT_FILTERED_REPOSITORY_DEPENDENCIES`:
- `SQL_NOSQL_DISTINCT_REPOSITORY_DEPENDENCIES`:
- `SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES`:
- `SQL_NOSQL_REPOSITORY_DEPENDENCIES`:
- `SQL_NOSQL_REPOSITORY_WITH_DBMS`:

#### Views
- `FILTERED_REPOSITORIES_VIEW`:
- `SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE`:

## Jupyter notebook
A Jupyter notebook is available in the [jupyter_notebook](jupyter_notebook/SQL_NoSQL_Survey.ipynb) folder. Download the database (follow the instruction of the previous "Survey database" step), move it in the same folder than the Jupyter notebook file, and start using the notebook which contains all the prepared queries to replicate the results of the paper.
The Jupyter notebook documentation is available [here](https://jupyter.org/install) (follow "Getting started with the classic Jupyter Notebook" section).

## SQL scripts
The SQL scripts permit to rebuild the survey database from a [LibrariesIO](https://libraries.io/data) dataset. They are available in the [sql](sql/) folder.

#### Preliminaries
- Download a dataset from [LibrariesIO](https://libraries.io/data)
- Extract the `repository_dependencies` and `repositories` CSV files from the compressed folder and import them into a SQL database (keep the same names for the database tables)

#### Database 
Execute the SQL scripts of the [sql](sql/) folder in the correct order (follow the numbering). Here is a description of the content of each SQL script:
- `1_1_DDL.sql`: 
- `1_2_Insert_Identified_Dependencies.sql`: 
- `1_3_Filter_Repository_dependencies.sql`: 
- `1_4_Update_Dependencies_Language.sql`: 
- `2_1_SQL_NOSQL_REPOSITORY_DEPENDENCIES.sql`: 
- `2_2_SQL_NOSQL_DATASET_REPOSITORIES.sql`: 
- `2_3_SQL_NOSQL_REPOSITORY_WITH_DBMS.sql`: 
- `3_1_Analysis.sql`: 
