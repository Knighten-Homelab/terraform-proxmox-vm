# Running GitHub Actions locally

I highly suggest running GitHub Actions workflows/actions/jobs/steps locally before pushing them to GitHub.  This can help you avoid having to push to GitHub multiple times to get your actions working as expected. Or from having to create a branch specifically for CI development before squashing and merging into your default/release branch.

It is also handy for just running basic tasks that are part of our CI/CD locally (building/linting/testing). Since everything is container based, you don't have to clutter your machine with tons of tech stacks and tools.

## GitHub Action Linting

We use [rhysd/actionlint](https://github.com/rhysd/actionlint) for linting our GitHub Actions. This is a great tool to use to catch syntax errors and other issues before pushing to GitHub.

## Available Local Executions and Tests

### Workflow - Build and Test Docker Image