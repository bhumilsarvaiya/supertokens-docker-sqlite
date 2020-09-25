## Quickstart
```bash
# This will start with an in memory database.

$ docker run -p 3567:3567 -d supertokens/supertokens-sqlite
```

## Configuration
You can use your own `config.yaml` file as a shared volume or pass the key-values as environment variables. 

If you do both, only the shared `config.yaml` file will be considered.
  
#### Using environment variable
Available environment variables
- **Core** [[click for more info](https://supertokens.io/docs/community/configuration/core)]
	- COOKIE\_DOMAIN
	- REFRESH\_API\_PATH
	- SUPERTOKENS\_HOST
	- SUPERTOKENS\_PORT
	- ACCESS\_TOKEN\_VALIDITY
	- ACCESS\_TOKEN\_BLACKLISTING
	- ACCESS\_TOKEN\_PATH
	- ACCESS\_TOKEN\_SIGNING\_KEY\_DYNAMIC
	- ACCESS\_TOKEN\_SIGNING\_KEY\_UPDATE\_INTERVAL
	- ENABLE\_ANTI\_CSRF
	- REFRESH\_TOKEN\_VALIDITY
	- INFO\_LOG\_PATH
	- ERROR\_LOG\_PATH
	- COOKIE\_SECURE
	- SESSION\_EXPIRED\_STATUS\_CODE
	- COOKIE\_SAME\_SITE
    - MAX\_SERVER\_POOL\_SIZE
- **SQLITE:** [[click for more info](https://supertokens.io/docs/community/configuration/database/sqlite)]
	- SQLITE\_CONNECTION\_POOL\_SIZE
	- SQLITE\_DATABASE\_NAME
	- SQLITE\_KEY\_VALUE\_TABLE\_NAME
	- SQLITE\_SESSION\_INFO\_TABLE\_NAME
	- SQLITE\_PAST\_TOKENS\_TABLE\_NAME
  

```bash
$ docker run \
	-p 3567:3567 \
	-v /path/to/sqlite_data:/sqlite_db \
	-d supertokens/supertokens-sqlite
```

#### Using custom config file
- In your `config.yaml` file, please make sure you store the following key / values:
  - `core_config_version: 0`
  - `host: "0.0.0.0"`
  - `sqlite_config_version: 0`
  - `sqlite_database_folder_location: "/sqlite_db"`
  - `info_log_path: null` (to log in docker logs)
  - `error_log_path: null` (to log in docker logs)
- The path for the `config.yaml` file in the container is `/usr/lib/supertokens/config.yaml`

```bash
$ docker run \
	-p 3567:3567 \
	-v /path/to/config.yaml:/usr/lib/supertokens/config.yaml \
	-v /path/to/sqlite_data:/sqlite_db \
	-d supertokens/supertokens-sqlite
```

## Logging
- By default, all the logs will be available via the `docker logs <container-name>` command.
- You can setup logging to a shared volume by:
	- Setting the `info_log_path` and `error_log_path` variables in your `config.yaml` file (or passing the values asn env variables).
	- Mounting the shared volume for the logging directory.

```bash
$ docker run \
	-p 3567:3567 \
	-v /path/to/logsFolder:/home/logsFolder \
	-e INFO_LOG_PATH=/home/logsFolder/info.log \
	-e ERROR_LOG_PATH=/home/logsFolder/error.log \
	-v /path/to/sqlite_data:/sqlite_db \
	-d supertokens/supertokens-sqlite
```

## Database storage
The docker container stores SQLite data in `/sqlite_db` folder. You can mount a shared volume at that path to persist data across docker restarts.

## CLI reference
Please refer to our [documentation](https://supertokens.io/docs/community/cli/overview) for this.