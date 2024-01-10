FROM ruby:3.1.4
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
RUN apt-get update && apt-get install -y nano
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
&& wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update -qq \
&& apt-get install -y build-essential libpq-dev nodejs yarn
# canvas のための依存ライブラリのインストール
RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev
RUN npm install -g sass
RUN mkdir /flow_thing
WORKDIR /flow_thing
RUN gem install bundler:2.3.17
COPY Gemfile /flow_thing/Gemfile
COPY Gemfile.lock /flow_thing/Gemfile.lock
COPY yarn.lock /flow_thing/yarn.lock
RUN bundle install
RUN yarn install
COPY . /flow_thing
EXPOSE 4000
CMD ["rails", "server", "-b", "0.0.0.0"]