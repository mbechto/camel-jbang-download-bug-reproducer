FROM jbangdev/jbang-action:0.113.0

# Setup Camel & JBang
RUN jbang jdk install 17
RUN jbang trust add https://github.com/apache/camel
RUN jbang app install camel@apache/camel
ENV PATH="$PATH:/jbang/.jbang/bin"

# Cache dependencies in $HOME/.m2/repository
RUN camel run --verbose --max-seconds=1 --code="" --deps camel:timer,camel:log,camel:http

