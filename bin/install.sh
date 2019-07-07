#!/bin/bash
#########################
# Author: Riccardo De Leo
#
# Description: Perform a fresh installation of SuiteCRM
#########################

#########################
# VARIABLES
#########################
DESTINATION_ENV="DEV"
ZIP_FILE_URL="https://suitecrm.com/files/160/SuiteCRM-7.10/444/SuiteCRM-7.10.18.zip"
ZIP_FILE_NAME="$(date +"%F_%H%M%S")_suitecrm.zip"
OVERRIDE=0
PROJECT_DIR=$( pwd )
DOCKER_COMPOSE_CMD=""
BEHAT_SUITE=""

#########################
# FUNCTIONS
#########################
function print_help {
    echo "Perform a fresh installation of SuiteCRM."
    echo
    echo "SYNOPSIS"
    echo "       ./install.sh [-efhop]"
    echo
    echo "COMMAND-LINE OPTIONS"
    echo
    echo "       -e --environment=DEV|UAT"
    echo "              Destination environment, default value: DEV"
    echo
    echo "       -f --file-url=URL"
    echo "              SuiteCRM installation file zip url, default behaviour: download the last lts version"
    echo
    echo "       -h --help"
    echo "              Print this help"
    echo
    echo "       -o --override"
    echo "              Delete the application directory and override with the new installation files"
    echo
    echo "       -p --project-dir=PATH"
    echo "              Project directory absolute path, if not set it will take the pwd"
    echo
}

#########################
# MAIN
#########################
while [ "$1" != "" ]; do
    case $1 in
        -e | --environment )    shift
                                DESTINATION_ENV=$1
                                ;;
        -f | --file-url )       shift
                                ZIP_FILE_URL=$1
                                ;;
        -h | --help )           print_help | less
                                exit 0
                                ;;
        -o | --override )       OVERRIDE=1
                                ;;
        -p | --project-dir )    shift
                                PROJECT_DIR=$1
                                ;;
        * )                     print_help | less
                                exit 1
    esac
    shift
done

echo
echo "Perform a fresh SuiteCRM install... STARTED"

if [ ! -x "$(command -v curl)" ]; then
    echo
    echo 'Perform a fresh SuiteCRM install... ERROR: curl command is not installed in the system'
    echo
    exit 1
fi

if [ ! -x "$(command -v unzip)" ]; then
    echo
    echo 'Perform a fresh SuiteCRM install... ERROR: unzip command is not installed in the system'
    echo
    exit 1
fi

case "${DESTINATION_ENV}" in
    "DEV")
        DOCKER_COMPOSE_CMD=docker-compose
        BEHAT_SUITE=LocalInstall
        ;;
    "UAT")
        DOCKER_COMPOSE_CMD="docker-compose -f docker-compose.uat.yml"
        BEHAT_SUITE=RemoteInstall
        ;;
    *)
        echo "Perform a fresh SuiteCRM install... ERROR: Invalid destination environment"
        echo
        print_help | less
        exit 1
        ;;
esac

if [ ! -d "${PROJECT_DIR}" ]; then
    echo
    echo "Perform a fresh SuiteCRM install... ERROR: Invalid <PROJECT_DIR>"
    echo "<PROJECT_DIR> must be a valid directory and must be the project root one"
    echo "<PROJECT_DIR> provided: ${PROJECT_DIR}"
    echo
    exit 1
fi

if [ -f "${PROJECT_DIR}/app/suitecrm_version.php" ]; then
    if [ ${OVERRIDE} == 1 ]; then
        mv ${PROJECT_DIR}/app/.gitkeep ${PROJECT_DIR}/.gitkeep
        rm -rf ${PROJECT_DIR}/app/
        mkdir ${PROJECT_DIR}/app/
        mv ${PROJECT_DIR}/.gitkeep ${PROJECT_DIR}/app/.gitkeep
    else
        echo
        echo "Performing SuiteCRM fresh install... STOPPED: CRM files are already present in application volume"
        echo "Select -o or --override to substitute the old files with new one"
        echo
        exit 0
    fi
fi

${DOCKER_COMPOSE_CMD} down

echo
echo "Performing SuiteCRM fresh install... Executed docker-compose down"

if [ ! -f "./vendor/bin/behat" ]; then
    ${DOCKER_COMPOSE_CMD} run --rm composer install

    echo
    echo "Performing SuiteCRM fresh install... Installed behat"
fi

curl -L "${ZIP_FILE_URL}" -o ${ZIP_FILE_NAME}

echo
echo "Perform a fresh SuiteCRM install... Downloaded SuiteCRM zip file"

if [ ! -f "${ZIP_FILE_NAME}" ]; then
    echo
    echo "Perform a fresh SuiteCRM install...  ERROR: download failed"
    echo "<FILE_URL> provided: ${ZIP_FILE_URL}"
    echo
    exit 1
fi

unzip ${ZIP_FILE_NAME} -d ${PROJECT_DIR}/app

mv ${PROJECT_DIR}/app/SuiteCRM-7.*/* ${PROJECT_DIR}/app/

rm -rf ${PROJECT_DIR}/app/SuiteCRM-7.*/

rm -f ${ZIP_FILE_NAME}

echo
echo "Perform a fresh SuiteCRM install... Extracted SuiteCRM zip file"

${DOCKER_COMPOSE_CMD} up -d

echo
echo "Perform a fresh SuiteCRM install... Started containers"

sleep 45

echo
echo "Perform a fresh SuiteCRM install... Running behat installation script"

${DOCKER_COMPOSE_CMD} run --rm behat --suite ${BEHAT_SUITE}

echo
echo "Perform a fresh SuiteCRM install... Successfully completed"
echo""
