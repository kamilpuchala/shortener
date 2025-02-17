FROM ruby:3.2.2
CMD ["rails", "server", "-b", "0.0.0.0"]

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

WORKDIR /shortener

COPY Gemfile Gemfile.lock ./

RUN bundle install && bundle clean --force

RUN bundle install

COPY . /shortener

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
