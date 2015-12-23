FROM ruby:2.0

ENV HOME /root

RUN apt-get update && \
    apt-get -y install npm && \
    apt-get -y install nodejs && \
    apt-get clean   

RUN gem install bundle dashing

RUN mkdir /dashboard    
WORKDIR /dashboard

EXPOSE 3030

CMD bundle && bundle exec dashing start