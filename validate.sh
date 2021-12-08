#!/bin/bash

WORKING_DIRECTORY="$PWD"
GITHUB_PAGES_REPO=$1
PR_NUMBER=$2
GITHUB_BRANCH=$3
GITHUB_PAGES_TEST=$4

[ "$GITHUB_PAGES_REPO" ] || {
  echo "ERROR: Environment variable GITHUB_PAGES_REPO is required"
  exit 1
}

[ "$PR_NUMBER" ] || {
  echo "ERROR: Environment variable PR_NUMBER is required"
  exit 0
}

# Get labels from github-api and deserialize response using jq and sed
LABELS=$(curl -s 'https://api.github.com/repos/'"${GITHUB_PAGES_TEST}"'/issues/'"${PR_NUMBER}"'/labels' | jq -r '.[] | .name' | sed 's/do not merge/do_not_merge/g') || {
  echo "ERROR: curl failed to get response from github-api  /  failed to serialize data"
  exit 1
}

if [ -z "$LABELS" ]; then
  echo "ERROR: Github-api failed to return answer / no labels found"
  exit 1 
fi

[ -z "$GITHUB_PAGES_BRANCH" ] && GITHUB_PAGES_BRANCH=gh-pages
[ -z "$HELM_CHARTS_SOURCE" ] && HELM_CHARTS_SOURCE="$WORKING_DIRECTORY/charts"
[ -d "$HELM_CHARTS_SOURCE" ] || {
  echo "ERROR: Could not find Helm charts in $HELM_CHARTS_SOURCE"
  exit 1
}
[ -z "$HELM_VERSION" ] && HELM_VERSION=2.8.1
[ "$GITHUB_BRANCH" ] || {
  echo "ERROR: Environment variable GITHUB_BRANCH is required"
  exit 1
}

echo "LABELS=$LABELS"
echo "PR_NUMBER=$PR_NUMBER"
echo "GITHUB_PAGES_REPO=$GITHUB_PAGES_REPO"
echo "GITHUB_PAGES_BRANCH=$GITHUB_PAGES_BRANCH"
echo "HELM_CHARTS_SOURCE=$HELM_CHARTS_SOURCE"
echo "HELM_VERSION=$HELM_VERSION"
echo "GITHUB_BRANCH=$GITHUB_BRANCH"

echo ">> Checking out $GITHUB_PAGES_BRANCH branch from $GITHUB_PAGES_REPO"
cd /tmp/helm/publish
mkdir -p "$HOME/.ssh"
git clone -b "${GITHUB_PAGES_BRANCH}" "https://github.com/${GITHUB_PAGES_REPO}.git" #GITHUB_PAGES_REPO
alias helm="/tmp/helm/bin/linux-amd64/helm"
cd helm-charts/
echo "$LABELS"

echo '>> Building charts and comparing with labels...'
sudo find "$HELM_CHARTS_SOURCE" -mindepth 1 -maxdepth 1 -type d | while read chart; do
  chart_name="`basename "$chart"`"
  for label in $LABELS; do
  if [ $label = $chart_name ]; then
    echo ">>> fetching chart $chart_name version"
    chart_version=$(cat $chart/Chart.yaml | grep -oE "version:\s[0-9]+\.[0-9]+\.[0-9]+" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
    echo ">>> checking if version is already published"
    if [ -f "$chart_name/$chart_name-$chart_version.tgz" ]; then
      echo ">>> Error: CHART $chart_name VERSION $chart_version ALREADY EXISTS! Update chart version."
      exit 1
    else
      echo ">>> chart version is valid, continuing..."
    fi
  else
    echo ">>> skipped version check on $chart_name"
  fi
  done
  echo ">>> helm lint $chart"
  helm lint "$chart"
  echo ">>> helm package -d $chart_name $chart"
  mkdir -p "$chart_name"
  helm package -d "$chart_name" "$chart"
done
