# Pod Info Application for the Pure GitOps project

## Summary
This is a simple Go web application that exposes the main information about the pod it is running on. This repository is complementary to [pure-gitops](https://github.com/KyriakosTsalia/pure-gitops) and contains the application source code, the <code>Dockerfile</code> and the <code>.gitlab-ci.yml</code> file. <br/>
The CI pipeline consists of four stages, each with a single job: build, package, test and deploy:
* In the build stage, the Go executable is built using a <code>Makefile</code> that first formats and vets the code. Additionally, it substitutes an environment variable in the <code>main.html</code> file that represents the app version. This variable is inside an <code>h1</code> tag that is hidden and only used for testing. The app version is unique and is a combination of GitLab's <code>CI_PIPELINE_IID</code> and <code>CI_COMMIT_SHORT_SHA</code> predefined variables.
* In the package stage, the docker image is created, tagged using the <code>CI_REGISTRY_IMAGE</code> predefined variable and pushed to the project's container registry.
* In the testing stage, using GitLab services, the image is tested locally inside the GitLab runner. The integration test is a simple <code>grep</code> on the app version.
* In the deploy stage, which is only executed in the main/default branch, the manifest repository is first cloned, a new branch is created, then the new application image is substituted in the <code>manifests/deployment.yaml</code> file and finally a merge request is created. For this to work, and assuming the repositories are private/internal, the manifest repository should have the application repository included in its allowlist, so that the <code>CI_JOB_TOKEN</code> has the required <code>read_repository</code> permission. Moreover, a GitLab Personal Access Token is necessary for GitLab authentication in the merge creation step.

For the pipeline to work, four GitLab CI/CD variables must be configured in the project's settings: <code>PERSONAL_ACCESS_TOKEN</code>, <code>TARGET_REPO_DEFAULT_BRANCH</code>, <code>TARGET_REPO_NAMESPACE</code> and <code>TARGET_REPO_PROJECT</code>. </br>

Some assumptions for the repository are that the default branch is protected (any new features are added using the "feature branch" workflow) and, when merging, fast-forward merges are created, source branches are deleted, commits are squashed and pipelines must be successful.

---

## License
Copyright &copy; 2023 Kyriakos Tsaliagkos

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.