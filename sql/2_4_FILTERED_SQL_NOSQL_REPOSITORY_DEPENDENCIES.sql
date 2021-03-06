--Quality filtered repositories
CREATE VIEW FILTERED_REPOSITORIES_VIEW AS
    SELECT DISTINCT REPOSITORY_NAME
    FROM SQL_NOSQL_DATASET_REPOSITORIES
    WHERE LAST_PUSH_DATETIME IS NOT NULL
    AND CREATION_DATETIME IS NOT NULL
    AND LAST_PUSH_DATETIME > CREATION_DATETIME
    AND SIZE >= 100
    AND CONTRIBUTORS_COUNT >= 2
    AND STARS_COUNT >= 2
;

CREATE TABLE SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES (
	ID INTEGER,
	REPOSITORY_NAME VARCHAR2 not null,
	DEPENDENCY_MANIFEST_PLATFORM VARCHAR2 not null,
	DEPENDENCY_MANIFEST_FILE VARCHAR2 not null,
	DEPENDENCY_NAME VARCHAR2 not null,
	DEPENDENCY_ID INTEGER,
	DEPENDENCY_LANGUAGE VARCHAR2 not null,
	DBMS_TYPE VARCHAR2,
	DBMS VARCHAR2,
	ODM INTEGER(1) default 0,
	DATASET_VERSION INTEGER not null
);


create index "SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES-DATASET_VERSION" on SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES (DATASET_VERSION);
create index "SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES-DBMS" on SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES (DBMS);
create index "SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES-DBMS_TYPE" on SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES (DBMS_TYPE);
create index "SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES-DEPENDENCY_LANGUAGE" on SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES (DEPENDENCY_LANGUAGE);
create index "SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES-DEPENDENCY_NAME" on SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES (DEPENDENCY_NAME);
create index "SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES-ODM" on SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES (ODM);
create index "SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES-REPOSITORY_NAME" on SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES (REPOSITORY_NAME);

INSERT INTO SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES
SELECT * FROM SQL_NOSQL_REPOSITORY_DEPENDENCIES WHERE REPOSITORY_NAME IN (
    SELECT REPOSITORY_NAME FROM FILTERED_REPOSITORIES_VIEW
);

CREATE TABLE SQL_NOSQL_DATASET_FILTERED_REPOSITORIES (
    DATASET_VERSION INTEGER not null,
    REPOSITORY_NAME VARCHAR2 not null,
	REPOSITORY_LANGUAGE VARCHAR2,
	HOST_TYPE VARCHAR2,
	DESCRIPTION VARCHAR2,
	STATUS VARCHAR2,
	FORK VARCHAR2,
	CREATION_DATETIME DATETIME,
	LAST_UPDATE_DATETIME DATETIME,
	LAST_PUSH_DATETIME DATETIME,
	LAST_SYNC_DATETIME DATETIME,
	HOMEPAGE_URL VARCHAR2,
	SIZE INTEGER,
	STARS_COUNT INTEGER,
	FORKS_COUNT INTEGER,
	OPEN_ISSUES_COUNT INTEGER,
	WATCHERS_COUNT INTEGER,
	CONTRIBUTORS_COUNT INTEGER,
	SOURCE_RANK INTEGER,
	SOURCE_FORK_REPOSITORY_NAME VARCHAR2,
	LICENCE VARCHAR2,
	KEYWORDS VARCHAR2,
	COMMITS_NUMBER INTEGER
, LINES_OF_CODE_COUNT int);

create index "SQL_NOSQL_DATASET_FILTERED_REPOSITORIES-REPOSITORY_NAME"
	on SQL_NOSQL_DATASET_FILTERED_REPOSITORIES (REPOSITORY_NAME);
create index "SQL_NOSQL_DATASET_FILTERED_REPOSITORIES-FORK"
	on SQL_NOSQL_DATASET_FILTERED_REPOSITORIES (FORK);
create index "SQL_NOSQL_DATASET_FILTERED_REPOSITORIES-SOURCE_FORK_REPOSITORY_NAME"
	on SQL_NOSQL_DATASET_FILTERED_REPOSITORIES (SOURCE_FORK_REPOSITORY_NAME);

INSERT INTO SQL_NOSQL_DATASET_FILTERED_REPOSITORIES
SELECT *, 0 FROM SQL_NOSQL_DATASET_REPOSITORIES WHERE REPOSITORY_NAME IN (SELECT REPOSITORY_NAME FROM SQL_NOSQL_FILTERED_REPOSITORY_DEPENDENCIES);