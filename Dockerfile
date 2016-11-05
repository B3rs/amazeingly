# Start from ruby 2.3.1 container
FROM ruby:2.3.1
# create app folder
RUN mkdir /usr/src/app
# add app files to app folder
ADD . /usr/src/app
# set working directory
WORKDIR /usr/src/app/
# install development dependencies
RUN bundle install
# run all tests to be sure everithing is fine
RUN ruby -I . -e "require 'minitest/autorun'; Dir.glob('test/*.rb') { |f| require(f) }"
