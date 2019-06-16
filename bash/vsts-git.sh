function configureGitLocalRepo() {

    if [[ -z $GIT_LOCALREPO_PATH ]]
    then
        echo "git: missing environment variables" >&2
        return 1
    fi

    echo "Configuring git repository"
    mkdir -p $GIT_LOCALREPO_PATH

    git -C $GIT_LOCALREPO_PATH config user.email $GIT_USER_EMAIL
    git -C $GIT_LOCALREPO_PATH config user.name $GIT_USER_NAME

    if [[ -n $VSTS_PAT ]]
    then
        local auth_token=$(echo -n ":${VSTS_PAT}" | openssl base64 | tr -d '\n')
        git -C $GIT_LOCALREPO_PATH config http.extraheader "Authorization: Basic ${auth_token}"
    fi   
}    
function vstsCloneRepo() {

    if [[ -z $VSTS_ORGANIZATION || -z $VSTS_PROJECT || -z $VSTS_GIT_REPO ]]
    then
        echo "vsts: missing environment variables" >&2
        return 1
    fi
    local gitrepo_url="https://dev.azure.com/${VSTS_ORGANIZATION}/${VSTS_PROJECT}/_git/${VSTS_GIT_REPO}"
    
    echo "Cloning git repository ${gitrepo_url}"
    git clone $gitrepo_url $GIT_LOCALREPO_PATH &> /dev/null
}

function vstsUploadChanges() {
   
    echo "Updating git"
    git -C $GIT_LOCALREPO_PATH commit -am $1 &> /dev/null
    git -C $GIT_LOCALREPO_PATH push &> /dev/null
}