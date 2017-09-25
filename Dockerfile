FROM postgres:9.6


# == Basics ==

RUN apt-get update && apt-get install -y git curl build-essential


# == Erlang/Elixir ==

# Erlang requirements
RUN apt-get install -qy make autoconf m4 libncurses5-dev
# For building with wxWidgets
RUN apt-get install -qy libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng3
# For building ssl (libssh-4 libssl-dev zlib1g-dev)
RUN apt-get install -qy libssh-dev
# ODBC support (libltdl3-dev odbcinst1debian2 unixodbc)
RUN apt-get install -qy unixodbc-dev
# Install asdf/erlang/elixir
ENV HOME /root
RUN git clone https://github.com/HashNuke/asdf.git $HOME/.asdf
ENV PATH $HOME/.asdf/bin:$HOME/.asdf/shims:$PATH
RUN asdf plugin-add erlang https://github.com/HashNuke/asdf-erlang.git
RUN asdf plugin-add elixir https://github.com/HashNuke/asdf-elixir.git
RUN asdf install erlang '20.0'
RUN asdf install elixir '1.5.1'
RUN asdf global erlang '20.0'
RUN asdf global elixir '1.5.1'
RUN mix local.hex --force
RUN mix local.rebar --force


# == Yarn ==

# Sources for a modern version of NodeJs
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
# Sources for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list
# Update and install
RUN apt-get update && apt-get install nodejs yarn -qy
