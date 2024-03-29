#!/bin/bash

MODE="$1"
BRANCH_P=$2
MESSAGE_P=$3

function confirm {
    echo -en "\e[33mwould you like to continue (y/n): "
    read reply
    echo -e "\e[0m"

    if [ "${reply,,}" == "y" ]; then
        return 1
    else 
        return 0
    fi
}

function startup {
    git branch -a
    echo -e "\e[35m"
    git status
    echo -e "\e[0m"
}

function checkout {
    local mode=$1
    local branch_p=$2
    if [[ "${MODE,,}" =~ "c" ]]; then
        git checkout $branch_p
        return 1
    else
        return 0
    fi
}

function alltopush {
    local message=$1
    git add .
    echo ""
    echo -e "\e[32mAdded .\e[0m"
    echo ""
    git commit -m "$message"
    echo ""
    echo -e "\e[32mCommited with message \e[35m\"$message\"\e[32m\e[0m"
    echo ""
    git push
}

function run {
    local mode=$1
    local branch_p=$2
    local message_p=$3

    if [[ "${mode,,}" =~ "n" ]]; then

        startup
        checkout "$mode" "$branch_p"

        finalmessage=$( [ $? -eq 1 ] && echo "$message_p" || echo "$branch_p" )

        confirm
        if [ $? -eq 1 ]; then
            alltopush "$finalmessage"
        fi
    fi
}

run "$MODE" "$BRANCH_P" "$MESSAGE_P"
echo -e "\e[32mDone :)\e[0m"
exit 0
