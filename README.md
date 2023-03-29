# Library

## Welcome to the CutTime Library project!

Here you will get the opportunity to see a list of all the books in the catalogue, add/edit books, register new members, and even let the members check out and return books.

In order to get this project up and running, you'll need to do a few things:

1. Make sure you have Elixir installed. If you don't, you can either use brew, or install natively

The easiest way to do this is via Homebrew:
> `brew install elixir`

The next easiest thing is installing it directly from the Elixir project. More information may be found [here](https://elixir-lang.org/install.html)


2. PostgreSQL (there are a lot of tutorials for this, we won't go into that now), but you can find more [here](https://www.postgresql.org/docs/current/tutorial-install.html)


Once installed, verify your Elixir version with `elixir -v`. You should see something like:
```bash
$> elixir -v
$> Erlang/OTP 25 [erts-13.0.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

$> Elixir 1.14.3 (compiled with Erlang/OTP 23)
```

After the main tools are installed, you can cd into the project directory from your shell, then you should be able to run this to have the dependencies to run the application:

```bash
$> mix setup
``` 
This should create the application, setup the database, and seed the database with the initial set of books.

Then run the app with 

```bash
$> mix phx.server
```


Now you can visit [`localhost:32084`](http://localhost:32084) from your browser.


Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

