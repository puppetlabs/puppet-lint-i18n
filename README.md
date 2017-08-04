# puppet-lint-i18n plugin


## Installation

To use this plugin, add the following like to the Gemfile in your Puppet code
base and run `bundle install`.

```ruby
gem 'puppet-lint-i18n'
```

## Usage

This plugin provides a new check to `puppet-lint`. It will detect functions that do not have their message wrapped in  a translate function.

Functions detected:

warning
fail 

For example the following

warning('message')

becomes 

warning(tstr('message'))

### make sure 

**--fix support: Yes**

This check will raise a warning for any files that don't have correct decoration.

```
WARNING: 'fail' messages should be decorated.
```
