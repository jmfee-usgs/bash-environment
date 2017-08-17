##
## Utility functions for working with git repositories.
## Jeremy Fee <jmfee@usgs.gov>
## 2017-08-17
##
## source into bash profile using ". git-functions.sh" or similar
##


## clone a project
# - clone from fork (that must already exist)
# - set up upstream remote
# - update master branch to track upstream/master
#
# parameters
#   $1 : repository name
# environment paramters
#   $GITHUB_USER : default "`whoami`-usgs"
#   $GITHUB_UPSTREAM_USER : default "usgs"
#   $GIT_BASEDIR : default "$HOME/Documents/git"
clone() {
  project=$1

  if [ -z "$project" ]; then
    echo "USAGE: clone PROJECT"
    return
  fi

  user=${GITHUB_USER:-`whoami`-usgs}
  upstream_user=${GITHUB_UPSTREAM_USER:-usgs}
  basedir=${GIT_BASEDIR:-$HOME/Documents/git}

  origin="git@github.com:${user}-usgs/${project}.git"
  upstream="git@github.com:${upstream_user}/${project}.git"

  if [ ! -d "$basedir" ]; then
    mkdir -p $basedir
  fi

  cd $basedir && \
  echo "Cloning fork ${origin}" && \
  git clone $origin && \
  echo "Adding upstream ${upstream}" && \
  cd $project && \
  git remote add upstream $upstream && \
  echo "Resetting master branch" && \
  reset_master
}


## merge current branch into master
# - merge current branch into master, adding merge commit
# - push master to origin
# - push master to upstream
merge() {
  # get current branch name
  branch=`git branch | grep '*' | awk '{print $2}'`

  if [ "$branch" == "master" ]; then
    echo "cannot merge master branch into self"
    return
  fi

  git checkout master && \
  git merge --no-ff -m "merging ${branch} into master" ${branch} && \
  git push upstream master && \
  git push origin master
}

## rebase local master branch against upstream
# - switch to master branch
# - pull from upstream with --ff-only
# - push to origin master
rebase() {
  git checkout master && \
  git fetch --all && \
  git pull --ff-only upstream master && \
  git push origin master
}


## reset local master branch to upstream/master
# - delete existing local master branch
# - create new local master branch tracking upstream/master
reset_master() {
  git fetch --all && \
  git checkout -b temp_master && \
  git branch -D master && \
  git checkout -b master upstream/master && \
  git branch -D temp_master
}
