# Contributing

When contributing to this repository, please first discuss the change you wish to make via "proposal" issue, or on the discord: https://discord.gg/H3vFPpEkN5

## How to Contribute
If it is your first time working on open source take a look at the INTRODUCTION.md file.

### Workflow
1. Pick and issue to work on, ask Tadas to assign it to you, and move it to "in progress".
1. Fork the Repository
2. Add in your changes following the project conventions
3. Add or update any tests
4. Create a pull request
1. Get PR accepted
1. Merge

Other ways to contribute include, but are not limited to: 
* Reporting Bugs
* Figma Design
* Reviewing Code
* Writing Documentation
* GitHub/Discord Organization
* CICD Workflow
* Marketing & Copywriting

Rules: 
- It is recommended to not make pull requests huge. If you want to implement a huge feature, break it down into multiple issues, and approach it one at a time
- If your code is blocking other people work, need to give daily updates as a comment on the issue, or it will be assigned to someone else.

## Propose Changes
If there is not already an issue that you want to work on, create a `proposal` issue. Then reach out to one of the collaborators
for it to get approved and turned into a `new feature` issue. Then follow the "How to Contribute" section to make changes.

## Pull Request Process

1. Ensure any install or build dependencies are removed before creating a pull request.
2. Update the README.md with details of changes to the interface, and how the app works.
3. Ensure that all the github actions pass.
4. You may merge the Pull Request in once you have the sign-off of one other developers, or if you 
   do not have permission to do that, you may request a collaborator to merge it for you.

## Code Reviews

Code reviewers will be expected to assign themselves to any code reviews that they deem capable of reviewing. Once you selected the code to review, assign yourself as a reviewer and you will have 24 hours to complete the code review.

## Testing Guidelines
* Aim for 70% test coverage
* Test everything that makes sense to test (Ex. No need to test if a StatefulWidget holds state)
* All new PRs should have tests updated if necessary, if they are not reviewer should make that an action item 