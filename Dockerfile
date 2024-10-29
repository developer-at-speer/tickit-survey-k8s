FROM ruby:3.1.3
WORKDIR /app

COPY . .

EXPOSE 3000

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN gem install rails bundler
RUN bundle check || bundle install
RUN chmod +x ./default_entrypoint.sh

CMD ["./default_entrypoint.sh"]
