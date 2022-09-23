# R18n Rails API

[![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/r18n/r18n-rails-api?style=flat-square)](https://cirrus-ci.com/github/r18n/r18n-rails-api)
[![Codecov branch](https://img.shields.io/codecov/c/github/r18n/r18n-rails-api/main.svg?style=flat-square)](https://codecov.io/gh/r18n/r18n-rails-api)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/r18n/r18n-rails-api.svg?style=flat-square)](https://codeclimate.com/github/r18n/r18n-rails-api)
[![Depfu](https://img.shields.io/depfu/r18n/r18n-rails-api?style=flat-square)](https://depfu.com/repos/github/r18n/r18n-rails-api)
[![License](https://img.shields.io/github/license/r18n/r18n-rails-api.svg?style=flat-square)](LICENSE)
[![Gem](https://img.shields.io/gem/v/r18n-rails-api.svg?style=flat-square)](https://rubygems.org/gems/r18n-rails-api)

Rails I18n compatibility for R18n:
* R18n loader for Rails I18n translation format;
* R18n back-end.

It is just a wrapper for [R18n core library](https://github.com/r18n/r18n-core).
See [R18n documentation](https://github.com/r18n/r18n-core/blob/main/README.md)
for more information.

## How To

### Rails Translations

You can use `R18n::Loader::Rails` to load translations from `I18n.load_path`:

`i18n/en.yml`:

```yaml
en:
  posts:
    one: One post
    many: %{count} posts
```

`example.rb`:

```ruby
require 'r18n-rails-api'

I18n.load_path = ['i18n/en.yml']
i18n = R18n::I18n.new('en', R18n::Loader::Rails)

i18n.posts(count: 5) #=> "5 posts"
```

### Back-end

You can use R18n as a back-end for Rails I18n:

```ruby
require 'r18n-rails-api'

R18n.set('en', 'path/to/translation')
I18n.backend = R18n::Backend.new

I18n.l Time.now, format: :full #=> "6th of December, 2009 22:44"
I18n.t :greeting, name: 'John' #=> "Hi, John"
I18n.t :users, count: 5        #=> "5 users"
```

## R18n Features

* Nice Ruby-style syntax.
* Filters.
* Flexible locales.
* Custom translations loaders.
* Translation support for any classes.
* Time and number localization.
* Several user languages support.

## License

R18n is licensed under the GNU Lesser General Public License version 3.
You can read it in LICENSE file or in [www.gnu.org/licenses/lgpl-3.0.html](https://www.gnu.org/licenses/lgpl-3.0.html).

## Author

Andrey “A.I.” Sitnik [andrey@sitnik.ru](mailto:andrey@sitnik.ru)
