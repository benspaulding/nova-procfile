# `Procfile` extension for Nova

A [Nova][nova] [extension][novaext] with support for [`Procfile`s][heroku].

The `Procfile` is mostly known for its use by [Heroku][] and [Foreman][]. However, it
is supported by a number of other services and utilities, and is extremely handy for
development. With this `.env` file:

```dotenv
DJANGO_SETTINGS_MODULE=my_site.settings.local
WEB_HOST=0.0.0.0:8000
BROWSERSYNC_PORT=9000
```

… and this `Procfile`:

```procfile
# Run the Django Web app.
django: django-admin runserver "$WEB_HOST"

# Monitor and rebuild all static/front-end assets.
assets: npm run watch

# Run Browser Sync proxied to the Django Web app.
djsync: browser-sync start --proxy="$WEB_HOST" --port="$BROWSERSYNC_PORT"
```

You can run `honcho start` and have it all up and running!

## Features

### Syntax Highlighting

Procfiles are highlighted not only to show what a valid process definition is, but it
also highlights the command to run using the shell highlighter.

### Symbol Navigation

You have probably never seen a long `Procfile`, but just in case you do, this
extension has you covered! You can navigate through the processes with the symbol
navigator or the command palette.

## Release Notes

See [CHANGELOG](./CHANGELOG.md).

## Todo

There are still a few things I plan to do.

### Features

- Add diagnostics to warn if a process name is not unique.
- Add formatting capabilities.
- Add automatic tasks for running Procfiles.

## `Procfile` runners: Foreman & Clones

The most used and robust are:

- [Foreman][] (Ruby)
- [Honcho][] (Python)
- [Goreman][] (Go)

Others include:

- [node-foreman][noreman] (Node) _— n.b. How on earth is this not named “Noreman”?
  I insist on referring to it as such!_
- [Shoreman][] (Shell)
- [forego][] (Go)

[nova]: https://nova.app/
[novaext]: https://extensions.panic.com
[heroku]: https://devcenter.heroku.com/articles/procfile
[foreman]: http://ddollar.github.io/foreman/
[honcho]: https://github.com/nickstenning/honcho
[goreman]: https://github.com/mattn/goreman
[noreman]: https://github.com/strongloop/node-foreman
[shoreman]: https://github.com/chrismytton/shoreman
[forego]: https://github.com/ddollar/forego

There is no published standard for `Procfile` syntax, but Foreman can be used as the
reference implementation. Though the various runners recognize different things as
comments, process, or errors, Foreman’s syntax is recognized by this extension.

| _`Procfile`_ | Foreman |   Honcho    | Goreman | Noreman | Shoreman | forego |
| ------------ | :-----: | :---------: | :-----: | :-----: | :------: | :----: |
| `n0:·…`      |    ✓    |      ✓      |    ✓    |    ✓    |    ✓     |   ✓    |
| `n1:…`       |    ✓    |      ✓      |    ✓    |    ✓    |    ✗     |   ✓    |
| `n-4:·…`     |    ✓    | # [\*](#f1) |    ✓    |    ✓    |    ✓     |   ✓    |
| `# n3:·…`    |    #    |      #      |    #    |    #    |    #     |   ✗    |
| `#n4:·…`     |    #    |      #      |    #    |    #    |    #     |   ✗    |
| `n5·:…`      |    #    |      #      |    ✓    |    ✗    |    ✓     |   ✗    |
| `·n6:·…`     |    #    |      #      |    ✓    |    ✗    |    ✓     |   ✗    |
| `n·7:·…`     |    #    |      #      |    ✓    |    ✗    |  ✓ / ✗   |   ✗    |
| `n8·:·…`     |    #    |      #      |    ✓    |    ✗    |    ✓     |   ✗    |
| `n9·…`       |    #    |      #      |    #    |    ✗    |    ✗     |   ✗    |

| _legend_          |     |
| ----------------- | :-: |
| valid process     |  ✓  |
| ignored / comment |  #  |
| error / hang      |  ✗  |

<a name="f1">\*</a> _Support for dashes is coming to Honcho (<a href="https://github.com/nickstenning/honcho/pull/218">PR #218</a>)._
