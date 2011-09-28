# Yarn #

Yarn is a multi-threaded webserver written in Ruby 1.9 by Jesper Kjeldgaard.
It handles concurrent requests by means of a set of workers and a job queue for incomming requests.

Supports:
* 


## Installation ##
`gem install yarn`


## Usage ##
To use Yarn with Rack applications:

`rackup -s Yarn <rackup file (config.ru)>`


To use Yarn for serving static and ruby (*.rb) files:


    yarn [options]
    where [options] are:
      --host, -h <s>:   Hostname or IP address of the server (default: 127.0.0.1)
      --port, -p <i>:   Port number to listen on for incomming requests (default: 3000)
      --workers, -w <s>:   Number of worker threads (default: 32)
