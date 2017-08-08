# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/puppetlabs/pdk/issues.

# Running tests

pdk has the following testing rake tasks

## spec

Run unit tests.

## rubocop

Run ruby style checks. Use `rake rubocop:auto_correct` to fix the easy ones.

# Release Process

1. Bump the version in `lib/puppet-lint/plugins/version.rb`.
1. In a clean checkout of master, run `bundle exec rake changelog`.
1. Edit PR titles and tags, until `bundle exec rake changelog` output makes sense.
1. Commit and PR the changes.
1. When the PR is merged, get a clean checkout of the merged commit, and run `bundle exec rake release[upstream]` (where "upstream" is your local name of the puppetlabs remote)
1. Profit!
1. Update `lib/pdk/version.rb` with `x.y.z.pre` version bump, commit, and PR to prepare for next release.

