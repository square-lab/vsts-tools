# env vars: Mandatory: GIT_LOCALREPO_PATH; Optionnal: GIT_USER_EMAIL, GIT_USER_NAME

function configureGitLocalRepo() {

    if [[ -z $GIT_LOCALREPO_PATH ]]
    then
        echo "git: missing environment variables" >&2
        return 1
    fi

    echo "Configuring git repository"
    mkdir -p $GIT_LOCALREPO_PATH

    git -C $GIT_LOCALREPO_PATH init > /dev/null
    git -C $GIT_LOCALREPO_PATH config user.email $GIT_USER_EMAIL
    git -C $GIT_LOCALREPO_PATH config user.name $GIT_USER_NAME 
}    
