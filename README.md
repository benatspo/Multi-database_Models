# Multi-database Models
This repository is the replication package for the paper: "An Empirical Study of (Multi-) Database Models in Open-Source Projects"

It permits to (rebuild or) use the surveyed database to replicate the observed results, and to filter/update/complete the dataset.

Link to download the SQLite database containing all the data for the replication: [SQL_NoSQL_Survey.db](https://figshare.com/s/fb5c35279ab68ec52ffc)

In the resources folder, you can find:
1. A database folder containing CSV files with the the content of the different tables/views of the full database:
   - Tables:
     - SQL_NOSQL_DATASET_REPOSITORIES: contains repositories meta-data for the 5 versions of the datasets
     - SQL_NOSQL_DEPENDENCY: contains the list of the manually identified database drivers/dependencies
     - SQL_NOSQL_REPOSITORY_DEPENDENCIES: contains the list of database-dependent repositories and their underlying database dependencies
     - SQL_NOSQL_DISTINCT_REPOSITORY_DEPENDENCIES: equivalent to SQL_NOSQL_REPOSITORY_DEPENDENCIES without duplicates
     - SQL_NOSQL_REPOSITORY_WITH_DBMS: contains for each database-dependent repository a flag for each database management system
     - SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES: equivalent to SQL_NOSQL_REPOSITORY_DEPENDENCIES with the quality filtered repositories only
     - SQL_NOSQL_DISTINCT_FILTERED_REPOSITORY_DEPENDENCIES: equivalent to SQL_NOSQL_DISTINCT_REPOSITORY_DEPENDENCIES with the quality filtered repositories only
   - Views:
     - FILTERED_REPOSITORIES_VIEW: contains the list of the quality filtered repositories
     - SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE: contains for each database-dependent repository a flag for each data model

2. CSV files containing the data from main tables:
   - REPOSITORIES.csv contains repositories meta-data for the 5 versions of the datasets
   - DEPENDENCIES.csv contains the list of the manually identified database drivers/dependencies
   - REPOSITORY_DEPENDENCIES.csv contains contains the list of database-dependent repositories and their underlying database dependencies
   - FILTERED_REPOSITORY_DEPENDENCIES.csv contains a sublist of REPOSITORY_DEPENDENCIES.csv filtered on our chosen repository quality filters (size >= 100kB, contributors count >= 2, stars count >= 2)

3. A SQL folder containing SQL scripts to rebuild the full database.
   Preliminary tasks are necessary before using the SQL scripts:
   - download LibrariesIO datasets from https://libraries.io/data,
   - extract "repositories" and "repository_dependencies" CSV files and
   - import them in a new database.

   Once the previous tasks executed, you can run the following scripts in the correct order to build and fill the new database for one snapshot.
   All the process can be executed again to build other versions of the input datasets.

   Scripts:
   - 1_1_DDL.sql: contains the SQL DDL operations to build the main tables.
   - 1_2_Insert_Identified_Dependencies.sql: contains the insert statements to fill the table containing the list of identified database drivers/dependencies.
   - 1_3_Filter_Repository_dependencies.sql: contains the scripts to filter the database-dependent projects from all repositories.
   - 1_4_Update_Dependencies_Language.sql: contains the scripts to define each repository dependency programming language.
   - 2_1_SQL_NOSQL_REPOSITORY_DEPENDENCIES.sql: contains the scripts to build the table containing all the repositories and their underlying database dependencies.
   - 2_2_SQL_NOSQL_DATASET_REPOSITORIES.sql: contains the insert statements to fill, for each dataset version, the meta-data of the repositories
   - 2_3_SQL_NOSQL_REPOSITORY_WITH_DBMS: contains the scripts to flag all the repositories with a boolean for each database management system.
   - 3_1_Analysis.sql: contains the scripts to filter the repositories on quality criteria, and other scripts to query the database and build the results presented in the survey.
