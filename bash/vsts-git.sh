function vstsCloneRepo() {

    if [[ -z $VSTS_ORGANIZATION || -z $VSTS_PROJECT || -z $VSTS_GIT_REPO ]]
    then
        echo "vsts: missing environment variables" >&2
        return 1
    fi
    local gitrepo_url="https://dev.azure.com/${VSTS_ORGANIZATION}/${VSTS_PROJECT}/_git/${VSTS_GIT_REPO}"
    
    echo "Cloning git repository ${gitrepo_url}"
    git -C $GIT_LOCALREPO_PATH remote add origin $gitrepo_url &> /dev/null
    git -C $CLUSTERINFO_PATH fetch origin &> /dev/null
    git -C $CLUSTERINFO_PATH checkout master &> /dev/null
}

function vstsUploadChanges() {
   
    if [[ $(git -C $GIT_LOCALREPO_PATH status --porcelain) ]]; then return 0; fi

    echo "Updating git"
    git -C $GIT_LOCALREPO_PATH commit -am $1 &> /dev/null
    git -C $GIT_LOCALREPO_PATH push &> /dev/null
}
