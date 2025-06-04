# IMDB Rails application

A sample application that uses the [IMBb dataset](https://developer.imdb.com/non-commercial-datasets/)

## Dependencies

Make sure that you have the following dependencies installed before running the application:

  * [Ruby](https://www.ruby-lang.org/) version 3.4.4 or later
  * [Bundler](https://bundler.io/) version 2.6.7 or later
  * [PostgreSQL](https://www.postgresql.org/) version 15.13 or later

Then run the following command in order to install the application dependencies

```shell
bundle install
```

## Database

In order to create the database schema run

```shell
rails db:create db:migrate
```

Then you can load the dataset with the following command:

```shell
rails imdb:load_data
```

Note that the dataset is huge, and will take a lot of time to load.

## Running the application

Now you can run the application with the following command

```shell
rails console
```

The application is available at http://127.0.0.1:3000/

