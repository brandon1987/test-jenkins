Where possible, we should use the [GitHub Flow](https://guides.github.com/introduction/flow/index.html) workflow. In this workflow, changes are made in a new branch and submitted for review and marging via pull request.

This is a good habit to get in to with several benefits:

 * Breaks changes into logical chunks. If you're about to change something that isn't covered by your branch description, you should probably make an issue for it and tackle it later.
 * Gives us a chance to send the pull request to others for feedback *before* it gets merged into the main release.
 * Discussion over code and changes are stored in a central location for each feature, rather than spread out through the commit history.

A good pull request should

 * include a complete implementation of the specified featur;
 * be fully unit tested;
 * not break existing functionality.

The process:

 1. `git checkout -b feature-name-here`
 1. Write your changes and (where applicable) tests.
 1. Run `rake test` to make sure everything is good.
 1. `git commit -am 'commit message here'`
 1. `git push origin feature-name-here`
 1. Within the [github.com](https://github.com) interface, select "new pull request" on your branch.
 1. If the pull request is in response to a specific issue, be sure to reference it in the description or title.
 1. Review the changes (or ask someone else to double check them) and then hit the merge button.
 1. When the merge is completed, `git checkout master`, `git pull` and `git branch -d feature-name-here` to delete the feature branch.
 1. If you're using the command line, you can `git fetch --prune` to clear your local branch history.
 1. Rinse and repeat!