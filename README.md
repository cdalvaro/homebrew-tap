<picture align="center">
  <source media="(prefers-color-scheme: dark)" srcset="/assets/homebrew-tap-banner-dark.png">
  <source media="(prefers-color-scheme: light)" srcset="/assets/homebrew-tap-banner-light.png">
  <img alt="cdalvaro's Homebrew tap banner." src="/assets/homebrew-tap-banner-light.png">
</picture>

[![hombrew tap cdalvaro][homebrew_tap_badge]][homebrew_tap_url]

Other languages: [🇪🇸 Español](/docs/es-ES/README.md)

[@cdalvaro](https://github.com/cdalvaro)'s custom formulae for the [Homebrew package manager](https://brew.sh).

## What is this?

This is a [Homebrew tap](https://docs.brew.sh/Taps) containing formulae for software that I use and that is not available in the main Homebrew repository or has been modified to suit my needs.

## How to enable this tap?

Just type `brew tap cdalvaro/tap`. This will allow you to install formulae from this tap.

You can directly type `brew install cdalvaro/tap/<formula>` to install the specified `<formula>`.

## Available formulae

<details>
  <summary>Formulae list</summary>
  <ul>
    <li><a href="#catboost-cli">catboost-cli</a></li>
    <li><a href="#catboostmodel-cpp">catboostmodel-cpp</a></li>
    <li><a href="#clang-format@14">clang-format@14</a></li>
    <li><a href="#cpp-jwt">cpp-jwt</a></li>
    <li><a href="#cpp-plotly">cpp-plotly</a></li>
    <li><a href="#cpp-zmq">cpp-zmq</a></li>
    <li><a href="#howard-hinnant-date">howard-hinnant-date</a></li>
    <li><a href="#json11">json11</a></li>
    <li><a href="#simple-web-server">simple-web-server</a></li>
    <li><a href="#wxwidgets">wxwidgets</a></li>
  </ul>
</details>

### `catboost-cli`

[![Badge](https://img.shields.io/badge/catboost-catboost-grey?logo=github&color=181717)](https://github.com/catboost/catboost)
[![Badge](https://img.shields.io/badge/Formula-catboost--cli-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/catboost-cli.rb)

Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool.

```sh
brew install cdalvaro/tap/catboost-cli
```

This formula is not available in homebrew-core repository because it does not meet the acceptance criteria. See [Homebrew/homebrew-core#140960](https://github.com/Homebrew/homebrew-core/pull/140960#issuecomment-1704292670) for more information.

### `catboostmodel-cpp`

[![Badge](https://img.shields.io/badge/catboost-catboost-grey?logo=github&color=181717)](https://github.com/catboost/catboost)
[![Badge](https://img.shields.io/badge/Formula-catboostmodel--cpp-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/catboostmodel-cpp.rb)

Gradient Boosting on Decision Trees C++ Model Library.

```sh
brew install cdalvaro/tap/catboostmodel-cpp
```

#### Optional Parameters

- `--with-static` Also install the static library

### `clang-format@14`

[![Badge](https://img.shields.io/badge/llvm-llvm--project-grey?logo=github&color=181717)](https://github.com/llvm/llvm-project)
[![Badge](https://img.shields.io/badge/Formula-clang--format@14-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/clang-format@14.rb)

Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript.

This formula installs: `clang-format-14` and `git-clang-format-14` to avoid collisions with their latest versions.

```sh
brew install cdalvaro/tap/clang-format@14
```

### `cpp-jwt`

[![Badge](https://img.shields.io/badge/arun11299-cpp--jwt-grey?logo=github&color=181717)](https://github.com/arun11299/cpp-jwt)
[![Badge](https://img.shields.io/badge/Formula-cpp--jwt-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/cpp-jwt.rb)

JSON Web Token library for C++.

```sh
brew install cdalvaro/tap/cpp-jwt
```

This is a header only C++ library, so it is not available in homebrew-core. But, for convenience, it is available in this tap.

### `cpp-plotly`

[![Badge](https://img.shields.io/badge/pablrod-cppplotly-grey?logo=github&color=181717)](https://github.com/pablrod/cppplotly)
[![Badge](https://img.shields.io/badge/Formula-cpp--plotly-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/cpp-plotly.rb)

Generate html/javascript charts from C++ data using javascript library plotly.js.

```sh
brew install cdalvaro/tap/cpp-plotly
```

This is a header only C++ library, so it is not available in homebrew-core. But, for convenience, it is available in this tap.

### `cpp-zmq`

[![Badge](https://img.shields.io/badge/zeromq-cppzmq-grey?logo=github&color=181717)](https://github.com/zeromq/cppzmq)
[![Badge](https://img.shields.io/badge/Formula-cpp--zmq-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/cpp-zmq.rb)

Header-only C++ binding for libzmq.

```sh
brew install cdalvaro/tap/cpp-zmq
```

This is a header only C++ library, so it is not available in homebrew-core. But, for convenience, it is available in this tap.

### `howard-hinnant-date`

[![Badge](https://img.shields.io/badge/HowardHinnant-date-grey?logo=github&color=181717)](https://github.com/HowardHinnant/date)
[![Badge](https://img.shields.io/badge/Formula-howard--hinnant--date-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/howard-hinnant-date.rb)

A date and time library based on the C++11/14/17 \<chrono\> header.

```sh
brew install cdalvaro/tap/howard-hinnant-date
```

This formula [is available](https://github.com/Homebrew/homebrew-core/blob/master/Formula/h/howard-hinnant-date.rb) at homebrew-core repository. But I have added the option `--without-string-view` to disable the use of `std::string_view` in the library. This is because `std::string_view` is not available in versions earlier than C++17.

### `json11`

[![Badge](https://img.shields.io/badge/dropbox-json11-grey?logo=github&color=181717)](https://github.com/dropbox/json11)
[![Badge](https://img.shields.io/badge/Formula-json11-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/json11.rb)

A tiny JSON library for C++11.

```sh
brew install cdalvaro/tap/json11
```

This is a header only C++ library and the project was archived on March 2020, so it is not available in homebrew-core.

### `simple-web-server`

[![Badge](https://img.shields.io/badge/eidheim-Simple--Web--Server-grey?logo=gitlab&color=FC6D26)](https://gitlab.com/eidheim/Simple-Web-Server)
[![Badge](https://img.shields.io/badge/Formula-simple--web--server-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/simple-web-server.rb)

A very simple, fast, multithreaded, platform independent HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio.

```sh
brew install cdalvaro/tap/simple-web-server
```

### `wxwidgets`

[![Badge](https://img.shields.io/badge/wxWidgets-wxWidgets-grey?logo=github&color=181717)](https://github.com/wxWidgets/wxWidgets)
[![Badge](https://img.shields.io/badge/Formula-wxwidgets-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/wxwidgets.rb)

Cross-Platform GUI Library.

```sh
brew install cdalvaro/tap/wxwidgets
```

This formula [is available](https://github.com/Homebrew/homebrew-core/blob/master/Formula/w/wxwidgets.rb) at homebrew-core repository. But I have added the option `--with-enable-abort` to allow aborting a running task using a `wxGenericProgressDialog`.

## Available casks

<details>
  <summary>Casks list</summary>
  <ul>
    <li><a href="#salt">salt</a></li>
    <li><a href="#saltlts">salt@lts</a></li>
  </ul>
</details>

### `salt`

[![Badge](https://img.shields.io/badge/saltstack-salt%20STS-grey?logo=saltproject&color=57BCAD)](https://docs.saltproject.io/salt/install-guide/en/latest/topics/install-by-operating-system/macos.html#sts-downloads)
[![Badge](https://img.shields.io/badge/Cask-salt-grey?logo=ruby&color=FBB040&logoColor=CC342D)](Casks/salt.rb)

Software to automate the management and configuration of any infrastructure or application at scale.

This cask installs salt STS using the official installation package instead
of building the whole package from source as the formula does.

```sh
brew install --cask cdalvaro/tap/salt
```

This cask [is available](https://github.com/Homebrew/homebrew-cask/blob/master/Casks/s/salt.rb) at homebrew-cask repository. However I have added [a patch](https://github.com/cdalvaro/homebrew-tap/blob/main/Casks/salt.rb#L1-L32) to the `.plist` files to make `salt` to work properly with Homebrew out of the box.

The patch adds:

- `HOMEBREW_PREFIX` to the environment.
- `PATH` env variable containing the `HOMEBREW_PREFIX` bin directory.
- `HOME` env variable containing the `root` home directory, to avoid an issue with `brew` command.

### `salt@lts`

[![Badge](https://img.shields.io/badge/saltstack-salt%20LTS-grey?logo=saltproject&color=57BCAD)](https://docs.saltproject.io/salt/install-guide/en/latest/topics/install-by-operating-system/macos.html#lts-downloads)
[![Badge](https://img.shields.io/badge/Cask-salt@lts-grey?logo=ruby&color=FBB040&logoColor=CC342D)](Casks/salt@lts.rb)

Software to automate the management and configuration of any infrastructure or application at scale.

This cask installs salt LTS using the official installation package instead
of building the whole package from source as the formula does.

```sh
brew install --cask cdalvaro/tap/salt@lts
```

This cask includes all patches from the [`salt`](#salt-1) cask.

## More documentation

More documentation is available at: [Homebrew - Taps](https://docs.brew.sh/Taps)

[homebrew_tap_badge]: https://img.shields.io/badge/brew%20tap-cdalvaro/tap-orange?logo=Homebrew&color=FBB040
[homebrew_tap_url]: https://github.com/cdalvaro/homebrew-tap
