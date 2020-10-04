# Github Action: Fork Sync With Upstream

An action for forks! Automatically sync a branch on your fork with the latest commits from the original repo. Keep things up to date! (It actually works for syncing *any* repo branch with an upstream repo, but I was thinking about forks when I made it.)

<a href="https://www.buymeacoffee.com/aormsby" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-green.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

## How to Use

As with any Github Action, you must include it in a workflow for your repo to run. Place the workflow at `.github/workflows/my-sync-workflow.yaml` in the default repo branch. For more help, see [Github Actions documentation](https://docs.github.com/en/actions).

### Input Variables

| Name                    | Required?           | Default           | Example |
| ----------------------- |:------------------: | ----------------- | ----------
| upstream_repository     | :white_check_mark:  |                   | aormsby/Fork-Sync-With-Upstream-action        |
| upstream_branch         |                     | 'main'            | 'master'                                      |
| target_branch           |                     | 'main'            | 'main'                                        |
| github_token            |                     |                   | ${{ secrets.GITHUB_TOKEN }}                   |
| git_checkout_extra_args |                     | ''                | '--recurse-submodules'                        |
| git_fetch_extra_args    |                     | ''                | '--recurse-submodules'                        |
| git_log_format_args     |                     | '--prety=oneline' | '--graph --pretty=oneline'                    |
| git_sync_command        |                     | 'pull'            | 'pull' or 'merge --ff-only' or 'reset --hard' |
| git_push_extra_args     |                     | ''                | '--force'                                     |

For **github_token** - use `${{ secrets.GITHUB_TOKEN }}` where `GITHUB_TOKEN` is the name of the secret in your repo ([see docs for help](https://docs.github.com/en/actions/configuring-and-managing-workflows/using-variables-and-secrets-in-a-workflow))

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
    name: Sync main with upstream latest

    steps:
    # Step 1: run a standard checkout action, provided by github
    - name: Checkout main
      uses: actions/checkout@v2
      with:
        ref: main

    # Step 2: run this sync action - specify the upstream repo, upstream branch to sync with, and target sync branch
    - name: Pull (Fast-Forward) upstream changes
      id: sync
      uses: aormsby/Fork-Sync-With-Upstream-action@v1
      with:
        upstream_repository: panr/hugo-theme-hello-friend
        upstream_branch: master                     # optional, defaults to main
        target_branch: main                         # optional, defaults to main
        git_sync_command: pull --ff-only            # optional, defaults to pull
        github_token: ${{ secrets.GITHUB_TOKEN }}   # optional, for accessing repos that require authentication

    # Step 3: Display a message if 'sync' step had new commits (simple test)
    - name: Check for new commits
      if: steps.sync.outputs.has-new-commits
      run: echo "There were new commits."

    # Step 4: Print a helpful timestamp for your records (not required)
    - name: Timestamp
      run: date
```
