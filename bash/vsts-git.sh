# env vars: Mandatory: GIT_LOCALREPO_PATH, VSTS_ORGANIZATION, VSTS_PROJECT, VSTS_GIT_REPO; Optionnal: VSTS_PAT

function vstsCloneRepo() {

    if [[ -n $VSTS_PAT ]]
    then
        local auth_token=$(echo -n ":${VSTS_PAT}" | openssl base64 | tr -d '\n')
        git -C $GIT_LOCALREPO_PATH config http.extraheader "Authorization: Basic ${auth_token}"
    fi  
    
    if [[ -z $VSTS_ORGANIZATION || -z $VSTS_PROJECT || -z $VSTS_GIT_REPO ]]
    then
        echo "vsts: missing environment variables" >&2
        return 1
    fi
    local gitrepo_url="https://dev.azure.com/${VSTS_ORGANIZATION}/${VSTS_PROJECT}/_git/${VSTS_GIT_REPO}"
    
    echo "Cloning git repository ${gitrepo_url}"
    git -C $GIT_LOCALREPO_PATH remote add origin $gitrepo_url > /dev/null
    git -C $GIT_LOCALREPO_PATH fetch origin > /dev/null
    git -C $GIT_LOCALREPO_PATH checkout master > /dev/null
}

function vstsUploadChanges() {
   
    if [[ -z $(git -C $GIT_LOCALREPO_PATH status --porcelain) ]]; then return 0; fi

    echo "Updating git"
    git -C $GIT_LOCALREPO_PATH add -A
    git -C $GIT_LOCALREPO_PATH commit -am "$1" > /dev/null
    git -C $GIT_LOCALREPO_PATH push > /dev/null
}