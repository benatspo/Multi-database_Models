--For DATASET_VERSION, use yyyyMMdd format in integer. i.e. 20200112
INSERT INTO SQL_NOSQL_DATASET_REPOSITORIES(DATASET_VERSION, REPOSITORY_NAME, REPOSITORY_LANGUAGE, HOST_TYPE, DESCRIPTION, STATUS, FORK, CREATION_DATETIME, LAST_UPDATE_DATETIME, LAST_PUSH_DATETIME, LAST_SYNC_DATETIME, HOMEPAGE_URL, SIZE, STARS_COUNT, FORKS_COUNT, OPEN_ISSUES_COUNT, WATCHERS_COUNT, CONTRIBUTORS_COUNT, SOURCE_RANK, SOURCE_FORK_REPOSITORY_NAME, LICENCE, KEYWORDS)
SELECT ?, "Name with Owner", Language, "Host Type", Description, Status, Fork, "Created Timestamp", "Updated Timestamp", "Last pushed Timestamp", "Last Synced Timestamp", "Homepage URL", Size, "Stars Count", "Forks Count", "Open Issues Count", "Watchers Count", "Contributors Count", SourceRank, "Fork Source Name with Owner", License, Keywords
FROM repositories
WHERE "Name with Owner" IN (
	SELECT DISTINCT REPOSITORY_NAME FROM SQL_NOSQL_REPOSITORY_DEPENDENCIES
);