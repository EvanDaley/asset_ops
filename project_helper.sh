#!/bin/bash

# Function to create a new GitHub repository
create_repo() {
    local project_name="3d_asset_$1"
    local description=$2
    local visibility=$3

    if [ -z "$project_name" ]; then
        echo "Project name is required."
        return 1
    fi

    if [ -z "$description" ]; then
        description="No description provided."
    fi

    if [ -z "$visibility" ]; then
        visibility="public"
    fi

    gh repo create "$project_name" --template="3d_game_asset_template" --$visibility --description "$description" --confirm
    git clone "git@github.com:EvanDaley/$project_name.git" ../"$project_name"
    cd "$project_name" || exit
    git fetch
    git checkout main
}

# Function to set up the main branch
setup_main_branch() {
    git pull
    echo "# $1" >> README.md
    git init
    git add README.md
    git commit -m "first commit"
    git branch -M main
    git remote add origin "git@github.com:EvanDaley/$1.git"
    git push -u origin main
}

# Function to initialize a new project
init_project() {
    local project_name=$1
    local description=$2

    create_repo "$project_name" "$description"
    setup_main_branch "$project_name"
}

# Main function to handle script arguments
main() {
    local command=$1
    shift

    case $command in
        create)
            init_project "$@"
            ;;
        *)
            echo "Usage: $0 {create} <project_name> [description]"
            return 1
            ;;
    esac
}

# Call the main function with all script arguments
main "$@"
