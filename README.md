# Multi-database Models
This repository is the replication package for the paper: "An Empirical Study of (Multi-) Database Models in Open-Source Projects"

It permits to (rebuild and/or) use the survey database to replicate the observed results, and to filter/update/complete the dataset.

## Survey database
The survey **SQLite** database is available on figshare, due to its size: [SQL_NoSQL_Survey.db](https://figshare.com/s/fb5c35279ab68ec52ffc)

Here is the description of the content of the different tables/views:
#### Tables
- `SQL_NOSQL_DATASET_REPOSITORIES`: contains for each filtered repository and each dataset version some descriptive data (e.g. number of stars, keywords, licence).
- `SQL_NOSQL_DBMS_TYPE_SURVIVAL`: contains for each repository the list of data model evolution (a bit code is used to represent the data model state before and after evolution: 1 for relational, 10 for document, 100 for key-value, 1000 for column, 10000 for graph data model. The states of repositories with multiple data models are represented by added bit codes).
- `SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS`: contains for each category of data model evolution the number of repositories concerned by that evolution, the source and the target data model state and the type of evolution (addition, change or deletion of a data model).
- `SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO`: contains for each evolved repository the first and the latest data model state and version (in the analysed dataset versions), two flags for the quality filtered repositories and the cyclic data model evolutions, plus some columns used to build the parallel class diagram.
- `SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO_GLOBAL`: contains a updated copy of SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO table which is used to build the parallel class diagram.
- `SQL_NOSQL_DEPENDENCY`: contains the list of database drivers used for this survey. It contains for each database driver the corresponding programming language, data model and database technology.
- `SQL_NOSQL_REPOSITORY_DEPENDENCIES`: contains the list of database-dependent repositories and the corresponding database drivers.
- `SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES`: contains the quality-filtered list of database-dependent repositories and the corresponding database drivers. It is a subset of SQL_NOSQL_REPOSITORY_DEPENDENCIES table.
- `SQL_NOSQL_REPOSITORY_WITH_DBMS`: contains for each repository and each database technology a flag
- `SQL_NOSQL_DISTINCT_REPOSITORY_DEPENDENCIES`: contains a subset of SQL_NOSQL_REPOSITORY_DEPENDENCIES table, without the duplicated results. Not used anymore.
- `SQL_NOSQL_DISTINCT_FILTERED_REPOSITORY_DEPENDENCIES`: contains a copy of SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES table, without the duplicated results. Not used anymore.

#### Views
- `FILTERED_REPOSITORIES_VIEW`: temporary view containing the quality-filtered repositories.
- `SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE`: equivalent to SQL_NOSQL_REPOSITORY_WITH_DBMS table but for the different data models. 

## Jupyter notebook
A Jupyter notebook is available in the [jupyter_notebook](jupyter_notebook/SQL_NoSQL_Survey.ipynb) folder. Download the database (follow the instruction of the previous "Survey database" step), move it in the same folder than the Jupyter notebook file, and start using the notebook which contains all the prepared queries to replicate the results of the paper.
![alt text](https://github.com/benatspo/Multi-database_Models/blob/main/img/jupyter_notebook.png?raw=true)
The Jupyter notebook documentation is available [here](https://jupyter.org/install) (follow "Getting started with the classic Jupyter Notebook" section).

## SQL scripts
The SQL scripts permit to rebuild the survey database from a [LibrariesIO](https://libraries.io/data) dataset. They are available in the [sql](sql/) folder.

#### Preliminaries
- Download a dataset from [LibrariesIO](https://libraries.io/data)
- Extract the `repository_dependencies` and `repositories` CSV files from the compressed folder and import them into a **SQLite** database (keep the same names for the database tables). **Note:** the following scripts have only been tested on a **SQLite** database.

#### Database 
Execute the SQL scripts of the [sql](sql/) folder in the correct order (follow the numbering). Here is a description of the content of each SQL script:
- `1_1_DDL.sql`: create SQL_NOSQL_DEPENDENCY, SQL_NOSQL_REPOSITORY_DEPENDENCIES, TEMP_FILTERED_REPOSITORY_DEPENDENCIES, SQL_NOSQL_DATASET_REPOSITORIES, SQL_NOSQL_REPOSITORY_WITH_DBMS, SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE tables/views and useful database indexes.
- `1_2_Insert_Identified_Dependencies.sql`: insert the identified list of database drivers in the SQL_NOSQL_DEPENDENCY table. If you want to analyse different database dependencies, programming languages, data models and/or database technologies, you can update the list.
- `1_3_Filter_Repository_dependencies.sql`: fill the TEMP_FILTERED_REPOSITORY_DEPENDENCIES temporary table containing the database-dependent repositories (according to the list of identified database drivers). You'll have to give the dataset version as input to the query (e.g. 20170721).
- `1_4_Update_Dependencies_Language.sql`: update the TEMP_FILTERED_REPOSITORY_DEPENDENCIES temporary table with the database dependency programming language.
- `2_1_SQL_NOSQL_REPOSITORY_DEPENDENCIES.sql`: fill the SQL_NOSQL_REPOSITORY_DEPENDENCIES table with the definitive list of repositories with database dependencies with the data contained in the TEMP_FILTERED_REPOSITORY_DEPENDENCIES temporary table and the SQL_NOSQL_DEPENDENCY table. You'll have to confirm the execution of the last update query.
- `2_2_SQL_NOSQL_DATASET_REPOSITORIES.sql`: fill the SQL_NOSQL_DATASET_REPOSITORIES table with the information of the filtered repositories. It will be used to filter the remaining repositories according to different quality criteria (e.g. number of contributors, creation date). You'll have to give the dataset version as input to the query (e.g. 20170721).
- `2_3_SQL_NOSQL_REPOSITORY_WITH_DBMS.sql`: insert the repositories in the SQL_NOSQL_REPOSITORY_WITH_DBMS table, and flag each repository for each database technology. If you analyse different database technologies, please update this SQL query.
- `2_4_FILTERED_SQL_NOSQL_REPOSITORY_DEPENDENCIES.sql`: create the FILTERED_SQL_NOSQL_REPOSITORY_DEPENDENCIES table which contain the repositories respecting the quality criteria defined in the query. By default, it contains the repositories with a minimum size of 100kB, at least two contributors, and having been starred at least twice. You can change the filters by updating this SQL query.
- `2_5_SURVIVAL_EVOLUTION.sql`: adapt the SQL_NOSQL_REPOSITORY_DEPENDENCIES table to permit the creation of SQL_NOSQL_DBMS_TYPE_SURVIVAL, SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS, SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO, SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO_GLOBAL tables.
- `3_1_Analysis.sql`: query the database to retrieve the results observed in the paper. These queries are the same as the one in the Jupyter notebook. Update them according to your needs.

**Important notes:** 
- Previous "Database" steps can be executed for each version of LibrariesIO dataset, according to your needs. You'll have to merge all the data from the different versions to have a complete database as the one proposed in this repository.
- `2_5_SURVIVAL_EVOLUTION.sql` SQL script is useless (as it analyses the evolution of data models between different versions of the repositories) until you merge the data from at least two versions of LibrariesIO datasets.
- `3_1_Analysis.sql` SQL script contains several queries concerning the evolution of data models, making them useless until you merge the data from at least two versions of LibrariesIO datasets.
- The proposed survey database can have different table names, but the content should be equivalent to the builded one.
