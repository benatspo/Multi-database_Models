



--These queries return the total number of distinct repositories of the survey, for the 5 input datasets
SELECT COUNT(DISTINCT REPOSITORY_NAME) AS TOTAL_NUMBER_OF_REPOSITORIES FROM SQL_NOSQL_REPOSITORY_DEPENDENCIES;
SELECT COUNT(DISTINCT REPOSITORY_NAME) AS TOTAL_NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES;
--This query returns the total number of filtered repositories of the survey per dataset version
SELECT DATASET_VERSION, COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES GROUP BY DATASET_VERSION;

--This query returns the total number of filtered repositories of the survey per data model and dependency programming language in 2020
SELECT DBMS_TYPE, DEPENDENCY_LANGUAGE, COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE DATASET_VERSION = '20200112' GROUP BY DBMS_TYPE, DEPENDENCY_LANGUAGE ORDER BY DBMS_TYPE, NUMBER_OF_FILTERED_REPOSITORIES DESC;

--This query returns the total number of filtered repositories of the survey per dataset version and data model
SELECT DATASET_VERSION, DBMS_TYPE, COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES GROUP BY DBMS_TYPE, DATASET_VERSION;

--This query returns the total number of filtered repositories of the survey per database implementation in 2020
SELECT DBMS, COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE DATASET_VERSION = '20200112' GROUP BY DBMS ORDER BY COUNT(DISTINCT REPOSITORY_NAME) DESC;

--This query returns the total number of filtered repositories of the survey per dependency in 2020 and dependency programming language in 2020
SELECT DEPENDENCY_NAME, DEPENDENCY_LANGUAGE, ODM AS 'ORM/ONM', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE DATASET_VERSION = '20200112' GROUP BY DEPENDENCY_NAME, DEPENDENCY_LANGUAGE ORDER BY COUNT(DISTINCT REPOSITORY_NAME) DESC;

--This query returns the total number of filtered repositories of the survey per combination of data model in 2020 and dependency programming language in 2020
SELECT DATASET_VERSION, DATA_MODELS, NUMBER_OF_FILTERED_REPOSITORIES FROM (
    --Only relational DB
    SELECT DATASET_VERSION, 'R' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Only document DB
    SELECT DATASET_VERSION, 'D' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Only key-value DB
    SELECT DATASET_VERSION, 'K' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Only column DB
    SELECT DATASET_VERSION, 'C' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Only graph DB
    SELECT DATASET_VERSION, 'G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Number of projects having two database types
    --Relational DB & Key-Value DB
    SELECT DATASET_VERSION, 'R + K' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Document DB
    SELECT DATASET_VERSION, 'R + D' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Document DB & Key-Value DB
    SELECT DATASET_VERSION, 'D + K' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Column DB
    SELECT DATASET_VERSION, 'R + C' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Key-Value DB & Column DB
    SELECT DATASET_VERSION, 'K + C' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Document DB & Column DB
    SELECT DATASET_VERSION, 'D + C' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Graph DB
    SELECT DATASET_VERSION, 'R + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Document DB & Graph DB
    SELECT DATASET_VERSION, 'D + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Key-Value & Graph DB
    SELECT DATASET_VERSION, 'K + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Column DB & Graph DB
    SELECT DATASET_VERSION, 'C + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Number of projects having three database types
    --Relational DB & Document DB & Key-Value DB
    SELECT DATASET_VERSION, 'R + D + K' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Key-Value DB & Column DB
    SELECT DATASET_VERSION, 'R + K + C' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Document DB & Column DB
    SELECT DATASET_VERSION, 'R + D + C' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Document DB & Key-Value DB & Column DB
    SELECT DATASET_VERSION, 'D + K + C' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Document DB & Graph DB
    SELECT DATASET_VERSION, 'R + D + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Document DB & Key-Value DB & Graph DB
    SELECT DATASET_VERSION, 'D + K + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Key-Value DB & Graph DB
    SELECT DATASET_VERSION, 'R + K + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Column DB & Graph DB
    SELECT DATASET_VERSION, 'R + C + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Document DB & Column DB & Graph DB
    SELECT DATASET_VERSION, 'D + C + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Key-Value DB & Column DB & Graph DB
    SELECT DATASET_VERSION, 'K + C + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Number of projects having four database types
    --Relational DB & Document DB & Key-Value DB & Column DB
    SELECT DATASET_VERSION, 'R + D + K + C' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = false
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Document DB & Key-Value DB & Graph DB
    SELECT DATASET_VERSION, 'R + D + K + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = false AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Document DB & Key-Value DB & Column DB & Graph DB
    SELECT DATASET_VERSION, 'D + K + C + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = false AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Document DB & Column & Graph DB
    SELECT DATASET_VERSION, 'R + D + C + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = false AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Relational DB & Key-Value DB & Column & Graph DB
    SELECT DATASET_VERSION, 'R + K + C + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = false AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = true
    ) GROUP BY DATASET_VERSION
    UNION
    --Number of projects having five database types
    --Relational DB & Document DB & Key-Value DB & Column DB & Graph DB
    SELECT DATASET_VERSION, 'R + D + K + C + G' AS 'DATA_MODELS', COUNT(DISTINCT REPOSITORY_NAME) AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
        SELECT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_WITH_DBMS_TYPE WHERE HAS_RELATIONAL_DB_DEPENDENCY = true AND HAS_DOCUMENT_DB_DEPENDENCY = true AND HAS_KEY_VALUE_DB_DEPENDENCY = true AND HAS_COLUMN_DB_DEPENDENCY = true AND HAS_GRAPH_DB_DEPENDENCY = true
    )
)
ORDER BY DATASET_VERSION, NUMBER_OF_FILTERED_REPOSITORIES DESC;

--This query returns the total number of filtered repositories of the survey which evolved their data model(s)
SELECT COUNT(DISTINCT REPOSITORY_NAME) AS TOTAL_NUMBER_OF_FILTERED_EVOLVING_REPOSITORIES FROM SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO_GLOBAL;

--This query is used to build the parallel class diagram
SELECT SOURCE_STATE_TEXT AS INITIAL_VERSION, FINAL_STATE_TEXT AS LATEST_VERSION, GLOBAL_EVOLUTION_TYPE_COUNT_FILTERED AS NUMBER_OF_EVOLVING_REPOSITORIES FROM SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO_GLOBAL ORDER BY GLOBAL_EVOLUTION_TYPE_COUNT_FILTERED DESC;

--This query returns the total number of filtered repositories of the survey per category of data model evolution
SELECT GLOBAL_EVOLUTION_TYPE, COUNT() AS NUMBER_OF_FILTERED_REPOSITORIES FROM SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO_GLOBAL GROUP BY GLOBAL_EVOLUTION_TYPE;

--This query returns the total number of filtered repositories of the survey per category of data model evolution and hybridation level
SELECT GLOBAL_EVOLUTION_TYPE AS GLOBAL_EVO_TYPE, COUNT() AS NB_REPO, CASE WHEN NB_SOURCE_DBMS_TYPES < NB_FINAL_DBMS_TYPES THEN 'More hybrid' WHEN NB_SOURCE_DBMS_TYPES = NB_FINAL_DBMS_TYPES THEN 'Unchanged' WHEN NB_SOURCE_DBMS_TYPES > NB_FINAL_DBMS_TYPES THEN 'Less hybrid' END AS LATEST_STATE, NB_SOURCE_DBMS_TYPES AS NB_SRC_DATA_MODEL, NB_FINAL_DBMS_TYPES AS NB_TRG_DATA_MODEL
FROM SQL_NOSQL_DBMS_TYPE_SURVIVAL_ANALYSIS_REPO_GLOBAL
WHERE GLOBAL_EVOLUTION_TYPE IN (
    --'Become hybrid',
    'Stay hybrid'
)
GROUP BY NB_SOURCE_DBMS_TYPES, NB_FINAL_DBMS_TYPES
ORDER BY NB_REPO DESC;