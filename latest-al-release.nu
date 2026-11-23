#!/usr/bin/env nu

# Print the flake input URL for the latest GitHub release of a repo.
# Usage: nu latest-release.nu [owner/repo]
# After you paste the URL, run: nix flake update autolith
def main [
    repo: string = "lambda-symbolics/autolith"  # GitHub repo, owner/name
] {
    let release = (http get $"https://api.github.com/repos/($repo)/releases/latest")
    let tag = ($release | get -o tag_name)
    if $tag == null {
        error make {msg: $"no tag_name in the GitHub API answer for ($repo)"}
    }
    print $"github:($repo)/($tag)"
}
