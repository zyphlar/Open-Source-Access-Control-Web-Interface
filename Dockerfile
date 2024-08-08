FROM ruby:1.9.3

# TODO: install imagemagick, arp-scan(?)

WORKDIR /app
COPY . /app

RUN bundle install

# Copy example Docker configs and generate a random secret token
# .env will be handled by ENV in docker-compose
RUN cp config/database.yml.docker config/database.yml &&\
    cp config/config.yml.docker config/config.yml &&\
    echo "Dooraccess::Application.config.secret_token = \"$(tr -dc A-Za-z0-9 </dev/urandom | head -c 30; echo)\"" > config/initializers/secret_token.rb

EXPOSE 3000
CMD "/app/docker-run.sh"