# puppet-lint-i18n plugin


## Installation

To use this plugin, add the following like to the Gemfile in your Puppet code base and run `bundle install`.

```ruby
gem 'puppet-lint-i18n'
```

## Usage

This plugin provides a new check to `puppet-lint`. It will detect functions that do not have their output message wrapped in a translate call.

### Functions detected

+ warning
+ fail

### Before and after

For example the following puppet code does not wrap the message
```ruby
warning('message')
```
wrapping the message then looks like
```ruby
warning(translate('message'))
```

### Example output

```
WARNING: 'warning' messages should be decorated: eg translate('old_root_password is no longer used and will be removed in a future release') on line 48
```
This tells you which file and what line the infringement occurred, as well as the suggested fix

### Other Infringements

+ Multiline strings

**BAD**
```ruby
warning(translate('to be or') / 
translate('not to be'))
```

**GOOD**
```ruby
warning(translate('to be or not to be')
```

+ Concatenated strings
+ Heredoc strings
+ Interpolated strings

### Fix issues automatically

**--fix support: Yes**

### Disabling checks

Please refer to the documentation here [https://github.com/rodjek/puppet-lint#disable-lint-checks]
