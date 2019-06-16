function vstsCloneRepo() {

    [[ -z $1 ]] && local vsts_organization=$VSTS_ORGANIZATION || local vsts_organization=$1
    [[ -z $2 ]] && local vsts_project=$VSTS_PROJECT || local vsts_project=$2
    [[ -z $3 ]] && local vsts_git_repo=$VSTS_GIT_REPO || local vsts_git_repo=$3
    [[ -z $4 ]] && local localrepo_path=$LOCALREPO_PATH || local localrepo_path=$4

    if [[ -z $vsts_organization || -z $vsts_project || -z $vsts_organization ]]
    then
        echo "vsts: missing environment variables" >&2
        return 1
    fi

    local REPO_URL=https://dev.azure.com/$vsts_organization/$vsts_project/_git/$vsts_git_repo
    local AUTH=$(echo -n ":$VSTS_PAT" | openssl base64 | tr -d '\n')

    echo "Cloning git repository ${REPO_URL}"
    git -c http.extraheader="Authorization: Basic $AUTH" clone $REPO_URL $localrepo_path &> /dev/null
}