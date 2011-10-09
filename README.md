# Yarn #

Yarn is a multi-process webserver written in Ruby 1.9 by Jesper Kjeldgaard.


## Installation ##
`gem install yarn`


## Usage ##


    Usage: yarn [options]
    where [options] are:
      --host, -h <s>:   Hostname or IP address of the server (default: 127.0.0.1)
      --port, -p <i>:   Port number to listen on for incomming requests (default: 3000)
      --workers, -w <i>:   Number of worker threads (default: 4)
      --rack, -r <s>:   Rackup file <config.ru> (default: off)
      --log, -l:   Enable logging
      --debug, -d:   Output debug messages
      --version, -v:   Print version and exit
      --help, -e:   Show this message


## Todo list ##


* Support persistent connections.
