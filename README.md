# Github Action: Fork Sync With Upstream

An action for forks! Automatically sync a branch on your fork with the latest commits from the original repo. Keep things up to date! (It actually works for syncing *any* repo branch with an upstream repo, but I was thinking about forks when I made it.)

<a href="https://www.buymeacoffee.com/aormsby" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-green.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

## How to Use

As with any Github Action, you must include it in a workflow for your repo to run. Place the workflow at `.github/workflows/my-sync-workflow.yaml` in the default repo branch. For more help, see [Github Actions documentation](https://docs.github.com/en/actions).

### Input Variables

- **upstream_repository** - Name/location of the upstream repository
  - Do not use full URLs, only user name and repo name, e.g. => aormsby/Fork-Sync-With-Upstream-action
  - **required** - action will not run without this input

- **upstream_branch** - Branch to pull from in the upstream repo
  - **required** - but defaults to 'master' branch if not specified

- **target_branch** - Branch to push to in the target repo
  - **required** - but defaults to 'master' branch if not specified

- **github_token** - Token for accessing the remote repo with authentication
  - use `${{ secrets.GITHUB_TOKEN }}` where `GITHUB_TOKEN` is the name of the secret in your repo ([see docs for help](https://docs.github.com/en/actions/configuring-and-managing-workflows/using-variables-and-secrets-in-a-workflow))
  - not required

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
    
    # Step 2: run this sync action - specify the upstream repo, upstream branch to sync with, and target sync branch
    - name: Pull upstream changes
      id: sync
      uses: aormsby/Fork-Sync-With-Upstream-action@v1
      with:
        upstream_repository: panr/hugo-theme-hello-friend
        upstream_branch: master
        target_branch: master                       # optional
        github_token: ${{ secrets.GITHUB_TOKEN }}   # optional, for accessing repos that requir authentication
        
    # Step 3: Print a helpful timestamp for your records (optional)
    - name: Timestamp
      run: date
```
