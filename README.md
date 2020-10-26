# Github Action: Fork Sync With Upstream

An action for forks! Automatically sync a branch on your fork with the latest commits from the original repo. Keep things up to date! (It actually works for syncing *any* repo branch with an upstream repo, but I was thinking about forks when I made it.)

<a href="https://www.buymeacoffee.com/aormsby" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-green.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

## How to Use

As with any Github Action, you must include it in a workflow for your repo to run. Place the workflow at `.github/workflows/my-sync-workflow.yaml` in the default repo branch (required for scheduled jobs at this time). For more help, see [Github Actions documentation](https://docs.github.com/en/actions).

### Input Variables

#### Basic Use

| Name                | Required?           | Default           | Example |
| ------------------- |:------------------: | ----------------- | ----------
| upstream_repository | :white_check_mark:  |                   | aormsby/Fork-Sync-With-Upstream-action  |
| upstream_branch     | :white_check_mark:  |                   | 'master', 'main', 'dev'                 |
| target_branch       | :white_check_mark:  |                   | 'master', 'main', 'prod'                |
| github_token        |                     |                   | ${{ secrets.GITHUB_TOKEN }}             |

For **github_token** - use `${{ secrets.GITHUB_TOKEN }}` where `GITHUB_TOKEN` is the name of the secret in your repo ([see docs for help](https://docs.github.com/en/actions/configuring-and-managing-workflows/using-variables-and-secrets-in-a-workflow))

#### Advanced Use (all optional args)

| Name                   | Required?           | Default             | Example |
| ---------------------- |:------------------: | ------------------- | ----------
| git_checkout_args      |                     |                     | '--recurse-submodules'     |
| git_fetch_args         |                     |                     | '--tags'                   |
| git_log_format_args    |                     | '--pretty=oneline'  | '--graph --pretty=oneline' |
| git_pull_args          |                     | 'pull'              | '--ff-only'                |
| git_push_args          |                     |                     | '--force'                  |
| config_git_credentials |                     | true                |                            |
| git_user               |                     | 'Action - Fork Sync'|                            |
| git_email              |                     | 'action@github.com' |                            |

`git_user` and `git_email` are set to conventional values during the action to prevent git command failure. They are automatically reset on action complete. You may pass custom values to these inputs if you need to. Set `config_git_credentials` to 'false' to skip this step and use existing credentials.

### Output Variables

**has_new_commits** - True when new commits were included in this sync

## Sync Process - Quick Overview

Right now, the `main.js` script only exists to execute `upstream-sync.sh`. It's possible that future updates will add functionality. The shell script does the following:

1. Check if you included `upstream_branch` in your inputs (required!)
2. Make sure the right local branch is checked out (`target_branch`)
3. Add the upstream repo you listed
4. Check if there are any new commits to sync (and prints any new commits as oneline statements)
5. Sync from the upstream repo (generally by pulling)
6. Push to the target branch of the target repo

**Ta-da!**

## Sample Workflow
This workflow is currently in use in some of my forked repos. [View Live Sample](https://github.com/aormsby/F-hugo-theme-hello-friend/blob/Working/.github/workflows/wf-fork-sync.yaml)

```yaml
on:
  schedule:
    - cron:  '0 7 * * 1,4'
    # scheduled at 07:00 every Monday and Thursday

jobs:
  sync_with_upstream:
    runs-on: ubuntu-latest
    name: Sync master with upstream latest

    steps:
    # Step 1: run a standard checkout action, provided by github
    - name: Checkout master
      uses: actions/checkout@v2
      with:
        ref: master
        # submodules: 'recursive'     ### possibly needed in your situation

    # Step 2: run this sync action - specify the upstream repo, upstream branch to sync with, and target sync branch
    - name: Pull (Fast-Forward) upstream changes
      id: sync
      uses: aormsby/Fork-Sync-With-Upstream-action@v2.0
      with:
        upstream_repository: panr/hugo-theme-hello-friend
        upstream_branch: master
        target_branch: master
        git_pull_args: --ff-only                    # optional arg use, defaults to simple 'pull'
        github_token: ${{ secrets.GITHUB_TOKEN }}   # optional, for accessing repos that require authentication

    # Step 3: Display a message if 'sync' step had new commits (simple test)
    - name: Check for new commits
      if: steps.sync.outputs.has-new-commits
      run: echo "There were new commits."

    # Step 4: Print a helpful timestamp for your records (not required)
    - name: Timestamp
      run: date
```
