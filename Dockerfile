FROM ruby:2.5

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN chmod +x app/shift_summery/runner.rb
CMD ["irb", "app/shift_summery/runner.rb"]
