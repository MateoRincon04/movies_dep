## Source Code Management – SCM

> "Everything should be versionable!"

---

After some research about different branching strategies, I came across 5 that are supposedly the most common or popular ones, these are:

- Git Flow

- GitHub Flow

- GitLab Flow

- One Flow

- Trunk-based Development

So I started to research and understand the thought behind each of these models in order to make the best decision about which to pick for the app that I'm using during the Ramp Up.

## Git Flow

Created by Vincent Driessen in 2010, Git Flow is an alternative Git branching model that has multiple, long-lived branches .

Normally, the MASTER (MAIN) branch is the one that has the official release history (production code), is the origin of all branches and is where at some point all code will be merged. Along with the main branch, there is a DEVELOP branch from where the CI is carried out with all successful tests included and all commits in the main branch represent a new version number of the product. 

- Ideal for multiple version in production.

- Overcomplicate release cycle can be a thing.

- Redundant branches MASTER/DEVELOP that could cause a harder CI/CD practice unless the project has a scheduled release cycle.

```
GitFlow.svg
```

## GitHub Flow

Created by GitHub in 2011, GitHub Flow is one of the simpler if not the simplest branching model that follows 6 principles:

1. The MASTER branch is all deployable.

2. The new features are developed on a branch created based on the MASTER.

3. CI in the feature branch locally.

4. In case of help or the feature is done, open a PR (pull request).

5. After reviewed by someone else and tests pass, the merge will be done.

6. Then deploy.

This model is good for small teams and web apps. Because of its simplicity it supports CI/CD. Nevertheless its very susceptible that production becomes buggy and unstable because its lack of dedicated development process through other branches but the MASTER.

```
GitHubFlow.svg
```

## GitLab Flow

Created by GitLab in 2014, it is an intermedium between GitHub and Git branching in terms of complexity. It essentially works like a GitHub model, but it distinguishes between the MASTER branch and 2 (normally) environmental branches, STAGING and PRODUCTION.

So, the MASTER branch has deployable code but it is not used for that purpose, instead, there's a new branch that is created every time the project wants to deploy.

GitLab Flow follows 11 principles:

1. Use FEATURE branches and merge them to MASTER.
2. Test all commits no matter the branch.
3. If a test is taking to long run it in parallel.
4. Review the code before any merge into MASTER.
5. Deployments are automatic, based on branches or tags.
6. Tags are set by someone, not by CI.
7. Tags represent releases.
8. Pushed commits are never rebased ( use another version of the branch is forked).
9. All branches start from master and are based on it.
10. Debugging start in MASTER then to all RELEASE branches.
11. Representative commit messages.

The flow defines the CI/CD

- CI: as all branches are based on MASTER the CI is straight forward.

- CD: because every commit can be treated as a deployment or every certain amount of features or time, depending on how the model is going to be implemented for the project.

The only drawback is that it can become messy overtime because of the amount of releases that are in play and/or their maintenance

```
GitLabFlow page
```

## One Flow

Created by Adam Ruka in 2015, is proposed as an alternative to Git Flow. And its principle is that every new production release needs to be based on the previous one. Therefore there is no DEVELOP branch as in Git Flow.

It is a very dynamic model and it can be adapted to every teams necessities, it provides a clear version history. Although, it is not recommended for CD because there is not a clear deployment process to follow, and CI is done via FEATURE branches not to one only branch.

```
One Flow page
```

## Trunk-based Development

A branching strategy where everyone has to integrate their changes to a shared TRUNK branch daily, that has to be deployable. Which means merge issues very day, but creates a culture of collaboration and means that every member of the teams has to be to date with the other's work.

CI/CD are both consequences to work with this method. CI is done by small steps of each person task as it needs to be deployable after merged. Which means that in case there's an error, its easy to find because of the little change done that day.

- Branching by abstraction: you rely on a source code abstraction to achieve the effect of a branch without an actual version control branch.

- Feature flags: allow developers to deploy unfinished code to production while hiding it from end-users. And allow you to wire your branch by abstraction to an externally controllable mechanism, such as an application configuration file or even an external database or service.
  
    TBD.jfif

---

# DECISION FOR MOVIE PROJECT

After all this research, analysis, understanding and debate ( with Carlos ), I've come to a decision:

I will be implementing a variation of the GitHub Flow, the only thing that I want to change is that I want a DEVELOP branch where I can fork the FEATURE branches and where CI would take place. Instead of using rebasing as a strategy to add the features I am going to implement a merging strategy that at a certain point will have to pass all tests for the merging to take place.

When the app is ready or at a version that the teams thinks can be deployed, it will be merged to the MASTER branch and deployed on it. The CD of the project is dictated by the deployment cycle that the team decides on.
