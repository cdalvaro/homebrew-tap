[![hombrew tap cdalvaro][homebrew_tap_badge]][homebrew_tap_url]

# <img src="assets/homebrew.svg" height=24pt> Homebrew Custom Tap

[@cdalvaro](https://github.com/cdalvaro)'s custom formulae for the [Homebrew package manager](https://brew.sh).

<p align="center">
  <a href="#"><img src="assets/homebrew-tap-banner.png" height=320px></a>
</p>

## What is this?

This is a [Homebrew tap](https://docs.brew.sh/Taps) containing formulae for software that I use and that is not available in the main Homebrew repositories.

## How to enable this tap?

Just type `brew tap cdalvaro/tap`. This will allow you to install formulae from this tap.

You can directly type `brew install cdalvaro/tap/<formula>` to install the specified `<formula>`.

## Available formulae

<details>
  <summary>Formulae list</summary>
  <ul>
    <li><a href="#catboost-cli">catboost-cli</a></li>
    <li><a href="#cpp-jwt">cpp-jwt</a></li>
    <li><a href="#cpp-plotly">cpp-plotly</a></li>
    <li><a href="#cpp-zmq">cpp-zmq</a></li>
    <li><a href="#howard-hinnant-date">howard-hinnant-date</a></li>
    <li><a href="#json11">json11</a></li>
    <li><a href="#salt">salt</a></li>
    <li><a href="#simple-web-server">simple-web-server</a></li>
    <li><a href="#wxwidgets">wxwidgets</a></li>
  </ul>
</details>

#### `catboost-cli`<a href="https://github.com/catboost/catboost"><img src="https://img.shields.io/badge/catboost-catboost-grey?logo=github&color=181717" align="right"/></a>

Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool.

```sh
brew install cdalvaro/tap/catboost-cli
```

[Formula/catboost-cli.rb](Formula/catboost-cli.rb)

#### `cpp-jwt`<a href="https://github.com/arun11299/cpp-jwt"><img src="https://img.shields.io/badge/arun11299-cpp--jwt-grey?logo=github&color=181717" align="right"/></a>

JSON Web Token library for C++.

```sh
brew install cdalvaro/tap/cpp-jwt
```

[Formula/cpp-jwt.rb](Formula/cpp-jwt.rb)

#### `cpp-plotly`<a href="https://github.com/pablrod/cppplotly"><img src="https://img.shields.io/badge/pablrod-cppplotly-grey?logo=github&color=181717" align="right"/></a>

Generate html/javascript charts from C++ data using javascript library plotly.js.

```sh
brew install cdalvaro/tap/cpp-plotly
```

[Formula/cpp-plotly.rb](Formula/cpp-plotly.rb)

#### `cpp-zmq`<a href="https://github.com/zeromq/cppzmq"><img src="https://img.shields.io/badge/zeromq-cppzmq-grey?logo=github&color=181717" align="right"/></a>

Header-only C++ binding for libzmq.

```sh
brew install cdalvaro/tap/cpp-zmq
```

[Formula/cpp-zmq.rb](Formula/cpp-zmq.rb)

#### `howard-hinnant-date`<a href="https://github.com/HowardHinnant/date"><img src="https://img.shields.io/badge/HowardHinnant-date-grey?logo=github&color=181717" align="right"/></a>

A date and time library based on the C++11/14/17 \<chrono\> header.

```sh
brew install cdalvaro/tap/howard-hinnant-date
```

[Formula/howard-hinnant-date.rb](Formula/howard-hinnant-date.rb)

#### `json11`<a href="https://github.com/dropbox/json11"><img src="https://img.shields.io/badge/dropbox-json11-grey?logo=github&color=181717" align="right"/></a>

A tiny JSON library for C++11.

```sh
brew install cdalvaro/tap/json11
```

[Formula/json11.rb](Formula/json11.rb)

#### `salt`<a href="https://github.com/saltstack/salt"><img src="https://img.shields.io/badge/saltstack-salt-grey?logo=github&color=181717" align="right"/></a>

Software to automate the management and configuration of any infrastructure or application at scale.

```sh
brew install cdalvaro/tap/salt
```

[Formula/salt.rb](Formula/salt.rb)

#### `simple-web-server`<a href="https://gitlab.com/eidheim/Simple-Web-Server"><img src="https://img.shields.io/badge/eidheim-Simple--Web--Server-grey?logo=gitlab&color=FC6D26" align="right"/></a>

A very simple, fast, multithreaded, platform independent HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio.

```sh
brew install cdalvaro/tap/simple-web-server
```

[Formula/simple-web-server.rb](Formula/simple-web-server.rb)

#### `wxwidgets`<a href="https://github.com/wxWidgets/wxWidgets"><img src="https://img.shields.io/badge/wxWidgets-wxWidgets-grey?logo=github&color=181717" align="right"/></a>

Cross-Platform GUI Library.

```sh
brew install cdalvaro/tap/wxwidgets
```

[Formula/wxwidgets.rb](Formula/wxwidgets.rb)

## Available casks

<details>
  <summary>Casks list</summary>
  <ul>
    <li><a href="#autofirma">autofirma</a></li>
    <li><a href="#salt-1">salt</a></li>
  </ul>
</details>

#### `autofirma`<a href="https://firmaelectronica.gob.es/Home/Descargas.html"><img src="https://img.shields.io/badge/Government%20of%20Spain-autofirma-grey?color=70130B" align="right"/></a>

Aplicación de firma electrónica desarrollada por el Ministerio de Asuntos Económicos y Transformación Digital.

Al poder ser ejecutada desde el navegador, permite la firma en páginas de Administración Electrónica cuando se requiere la firma en un procedimiento administrativo.

```sh
brew install --cask cdalvaro/tap/autofirma
```

[Casks/autofirma.rb](Casks/autofirma.rb)

#### `salt`<a href="https://docs.saltproject.io/salt/install-guide/en/latest/topics/install-by-operating-system/macos.html"><img src="https://img.shields.io/badge/saltstack-salt-grey?logo=saltproject&color=57BCAD" align="right"/></a>

Software to automate the management and configuration of any infrastructure or application at scale.

This cask installs salt using the official installation package instead
of building the whole package from source as the formula does.

⚠️ _This cask is currently only available for Intel Macs._ (See: [saltstack/salt#60560](https://github.com/saltstack/salt/issues/60560))

```sh
brew install --cask cdalvaro/tap/salt
```

[Casks/salt.rb](Casks/salt.rb)

## More Documentation

More documentation is available at: [Homebrew - Taps](https://docs.brew.sh/Taps)

[homebrew_tap_badge]: https://img.shields.io/badge/brew%20tap-cdalvaro/tap-orange?logo=Homebrew&color=FBB040
[homebrew_tap_url]: https://github.com/cdalvaro/homebrew-tap
