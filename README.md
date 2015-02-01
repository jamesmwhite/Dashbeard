# Dashbeard
A dashboard by a guy with a beard

## Features

* RSS feed
* Dublin Bus departures from one station
* Irish Rail departures from one station

## Reqs
* Ruby
* Rails

## Secret Token error
When you clone this project, you will need to run

```rake secret```

which will generate a unique token, then create a new file config/initializers/secret_token.rb and add the following:

```AppName::Application.config.secret_key_base = '<token>'```

replacing AppName with the name of your app and <token> with the unique token you generated.

## Running
```
bundle
rails s
```
