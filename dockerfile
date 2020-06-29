FROM ruby:2.5.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /workdir
WORKDIR /workdir
COPY Gemfile /workdir/Gemfile
COPY Gemfile.lock /workdir/Gemfile.lock
RUN bundle install
COPY . /workdir
ENV TERM xterm-256color
CMD /bin/sh -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"