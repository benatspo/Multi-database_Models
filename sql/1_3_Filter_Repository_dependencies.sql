--Temporary table containing database-dependent repositories and minimal meta-data to build SQL_NOSQL_REPOSITORY_DEPENDENCIES
--For DATASET_VERSION, use yyyyMMdd format in integer. i.e. 20200112
INSERT INTO TEMP_FILTERED_REPOSITORY_DEPENDENCIES(REPOSITORY_NAME, DEPENDENCY_MANIFEST_PLATFORM, DEPENDENCY_MANIFEST_FILE, DEPENDENCY_NAME, DATASET_VERSION)
    SELECT rep."Repository Name with Owner", rep."Manifest Platform", rep."Manifest Filepath", rep."Dependency Project Name", ?
    FROM repository_dependencies rep
    WHERE rep."Dependency Project Name" IN ( SELECT DISTINCT DEPENDENCY_NAME FROM SQL_NOSQL_DEPENDENCY );