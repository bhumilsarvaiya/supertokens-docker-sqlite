set -e
# build image
docker build -t supertokens-sqlite:circleci .

test_equal () {
    if [[ $1 -ne $2 ]]
    then
        printf "\x1b[1;31merror\x1b[0m in $3\n"
        exit 1
    fi
}

no_of_running_containers () {
    docker ps -q | wc -l
}

test_hello () {
    message=$1
    STATUS_CODE=$(curl -I -X GET http://127.0.0.1:3567/hello -o /dev/null -w '%{http_code}\n' -s)
    if [[ $STATUS_CODE -ne "200" ]]
    then
        printf "\x1b[1;31merror\xd1b[0m in $message\n"
        exit 1
    fi
}

test_session_post () {
    message=$1
    STATUS_CODE=$(curl -X POST http://127.0.0.1:3567/session -H "Content-Type: application/json" -d '{
        "userId": "testing",
        "userDataInJWT": {},
        "userDataInDatabase": {},
        "deviceDriverInfo": {
            "frontendSDK": [{
                "name": "ios",
                "version": "1.0.0"
            }],
            "driver": {
                "name": "node",
                "version": "1.0.0"
            }
        }
    }' -o /dev/null -w '%{http_code}\n' -s)
    if [[ $STATUS_CODE -ne "200" ]]
    then
        printf "\x1b[1;31merror\xd1b[0m in $message\n"
        exit 1
    fi
}

# setting network options for testing
OS=`uname`
NETWORK_OPTIONS="-p 3567:3567"

#---------------------------------------------------
# start with no params
docker run $NETWORK_OPTIONS --rm -d --name supertokens supertokens-sqlite:circleci --no-in-mem-db

sleep 17s

test_equal `no_of_running_containers` 1 "start with no params"

test_hello "start with no params"

test_session_post "start with no params"

docker rm supertokens -f

#---------------------------------------------------
# start by sharing config.yaml
docker run $NETWORK_OPTIONS -v $PWD/config.yaml:/usr/lib/supertokens/config.yaml --rm -d --name supertokens supertokens-sqlite:circleci --no-in-mem-db

sleep 17s

test_equal `no_of_running_containers` 1 "start by sharing config.yaml"

test_hello "start by sharing config.yaml"

test_session_post "start by sharing config.yaml"

docker rm supertokens -f

# ---------------------------------------------------
# test info path
docker run $NETWORK_OPTIONS -v $PWD:/home/supertokens -e INFO_LOG_PATH=/home/supertokens/info.log -e ERROR_LOG_PATH=/home/supertokens/error.log --rm -d --name supertokens supertokens-sqlite:circleci --no-in-mem-db

sleep 17s

test_equal `no_of_running_containers` 1 "test info path"

test_hello "test info path"

test_session_post "test info path"

if [[ ! -f $PWD/info.log || ! -f $PWD/error.log ]]
then
    exit 1
fi

docker rm supertokens -f

rm -rf $PWD/info.log
rm -rf $PWD/error.log
git checkout $PWD/config.yaml

printf "\x1b[1;32m%s\x1b[0m\n" "success"
exit 0