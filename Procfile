web: bundle exec passenger start -p ${PORT:-3000} --max-pool-size ${WEB_CONCURRENCY:-5}
worker: bundle exec sidekiq -e ${RACK_ENV:-development} -C config/sidekiq.yml
release: bundle exec rails decidim_action_delegator:install:migrations && bundle exec rake db:migrate
