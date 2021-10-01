# Decidim Coopcat

Instància de [Decidim](https://github.com/decidim/decidim) per a CoopCat

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:

```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```

3. Visit `<your app url>/system` and login with your system admin credentials
4. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
5. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
6. Fill the rest of the form and submit it.

You're good to go!

### How to deploy

This app has Heroku [automatic deploys](https://devcenter.heroku.com/articles/github-integration#automatic-deploys) enabled on `master` so any push there will trigger a deploy.

Alternatively, you can trigger one from the `Manual deploy` section in the Heroku dashboard. There you can choose any branch.

## Development

### Project management

In this repo you'll find all the issues needed to fulfill CoopCat's requirements. These are epics that represent the development that needs to happen to implement the features that CoopCat needs. Among these, you'll also find other regular issues that are simply things we need to do to maintain the Rails app.

Most of the implementation for these epics is happening in the separate module [decidim-module-action_delegator](https://github.com/coopdevs/decidim-module-action_delegator/). So expect to see non-epic issues and pull requests there.

### Run action delegator's seed data

You can do so from the Rails console and manually executing the method:

```sh
$ heroku run rails c
irb(main):001:0> Decidim::ActionDelegator::Engine.load_seed
=> true
```

### Upgrading Decidim

This entails updating the non-core Decidim modules we rely on, decidim-action_delegator
and decidim-direct_verifications, to support the Decidim version we want to
upgrade to. See
https://github.com/coopdevs/decidim-module-action_delegator/pull/80 for
reference.

Once that's done, we need to update `DECIDIM_VERSION` in the Gemfile to point to the target
version and possibly update the `gem "decidim-action_delegator"` and `gem
"decidim-direct_verifications"` to point to their upgrade branches. Don't forget
to get those merged and released so they get updated in our Gemfile later on.

Then, to update run:

```sh
bundle update decidim decidim-consultations
bundle exec rake railties:install:migrations
bundle exec rake db:migrate
```

You can check https://github.com/coopdevs/decidim-coopcat/pull/109 as an
example.
