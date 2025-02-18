FROM ruby:3.2.2

RUN gem update --system && \
    gem install bundler -v 2.6.3

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      nodejs \
      postgresql-client \
      curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /shortener
COPY Gemfile Gemfile.lock ./

RUN bundle install && bundle clean --force

COPY . /shortener

EXPOSE 3000

CMD ["bash"]
