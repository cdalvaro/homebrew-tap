<picture align="center">
  <source media="(prefers-color-scheme: dark)" srcset="/assets/homebrew-tap-banner-dark.png">
  <source media="(prefers-color-scheme: light)" srcset="/assets/homebrew-tap-banner-light.png">
  <img alt="cdalvaro's Homebrew tap banner." src="/assets/homebrew-tap-banner-light.png">
</picture>

[![hombrew tap cdalvaro][homebrew_tap_badge]][homebrew_tap_url]

Otros idiomas: [🇺🇸 English](/docs/en-US/README.md)

Fórmulas personalizadas de [@cdalvaro](https://github.com/cdalvaro) para el [gestor de paquetes Homebrew](https://brew.sh).

## Qué es esto?

Esto es un [Tap de Homebrew](https://docs.brew.sh/Taps) que contiene fórmulas para software que utilizo y que no está disponible en el repositorio principal de Homebrew o que ha sido modificado para adaptarse a mis necesidades.

## Cómo habilitar el tap?

Simplemente introduce `brew tap cdalvaro/tap` en la terminal y presiona <kbd>Enter</kbd>. Esto te permitirá instalar fórmulas de este tap.

Puedes introducir directamente `brew install cdalvaro/tap/<formula>` para instalar la `formula` especificada.

## Fórmulas disponibles

<details>
  <summary>Lista de fórmulas</summary>
  <ul>
    <li><a href="#catboost-cli">catboost-cli</a></li>
    <li><a href="#catboostmodel-cpp">catboostmodel-cpp</a></li>
    <li><a href="#clang-format@14">clang-format@14</a></li>
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

### `catboost-cli`

[![Badge](https://img.shields.io/badge/catboost-catboost-grey?logo=github&color=181717)](https://github.com/catboost/catboost)
[![Badge](https://img.shields.io/badge/Formula-catboost--cli-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/catboost-cli.rb)

Herramienta de línea de comandos de Gradient Boosting rápida, escalable y de alto rendimiento.

```sh
brew install cdalvaro/tap/catboost-cli
```

Esta fórmula no está disponible en el repositorio homebrew-core porque no cumple con los criterios de aceptación. Consulta [Homebrew/homebrew-core#140960](https://github.com/Homebrew/homebrew-core/pull/140960#issuecomment-1704292670) para más información.

### `catboostmodel-cpp`

[![Badge](https://img.shields.io/badge/catboost-catboost-grey?logo=github&color=181717)](https://github.com/catboost/catboost)
[![Badge](https://img.shields.io/badge/Formula-catboostmodel--cpp-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/catboostmodel-cpp.rb)

Librería de C++ del modelo Catboost Gradient Boosting basada en árboles de decisión.

```sh
brew install cdalvaro/tap/catboostmodel-cpp
```

#### Parámetros Opcionales

- `--with-static` Instala también la librería estática

### `clang-format@14`

[![Badge](https://img.shields.io/badge/llvm-llvm--project-grey?logo=github&color=181717)](https://github.com/llvm/llvm-project)
[![Badge](https://img.shields.io/badge/Formula-clang--format@14-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/clang-format@14.rb)

Herramientas para formatear C, C++, Obj-C, Java, JavaScript, TypeScript.

Esta fórmula instala: `clang-format-14` y `git-clang-format-14` para evitar colisiones con las últimas versiones.

```sh
brew install cdalvaro/tap/clang-format@14
```

### `cpp-jwt`

[![Badge](https://img.shields.io/badge/arun11299-cpp--jwt-grey?logo=github&color=181717)](https://github.com/arun11299/cpp-jwt)
[![Badge](https://img.shields.io/badge/Formula-cpp--jwt-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/cpp-jwt.rb)

Librería de JSON Web Token para C++.

```sh
brew install cdalvaro/tap/cpp-jwt
```

Al tratarse de una librería de C++ compuesta únicamente por archivos de cabecera, no cumple los criterios de aceptación de homebrew-core. Pero por comodidad, está disponible en este tap.

### `cpp-plotly`

[![Badge](https://img.shields.io/badge/pablrod-cppplotly-grey?logo=github&color=181717)](https://github.com/pablrod/cppplotly)
[![Badge](https://img.shields.io/badge/Formula-cpp--plotly-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/cpp-plotly.rb)

Librería para generar gráficos html/javascript a partir de datos de C++ utilizando la librería de javascript plotly.js.

```sh
brew install cdalvaro/tap/cpp-plotly
```

Al tratarse de una librería de C++ compuesta únicamente por archivos de cabecera, no cumple los criterios de aceptación de homebrew-core. Pero por comodidad, está disponible en este tap.

### `cpp-zmq`

[![Badge](https://img.shields.io/badge/zeromq-cppzmq-grey?logo=github&color=181717)](https://github.com/zeromq/cppzmq)
[![Badge](https://img.shields.io/badge/Formula-cpp--zmq-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/cpp-zmq.rb)

Librería para C++ compuesta únicamente por archivos de cabecera para la librería libzmq.

```sh
brew install cdalvaro/tap/cpp-zmq
```

Al tratarse de una librería de C++ compuesta únicamente por archivos de cabecera, no cumple los criterios de aceptación de homebrew-core. Pero por comodidad, está disponible en este tap.

### `howard-hinnant-date`

[![Badge](https://img.shields.io/badge/HowardHinnant-date-grey?logo=github&color=181717)](https://github.com/HowardHinnant/date)
[![Badge](https://img.shields.io/badge/Formula-howard--hinnant--date-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/howard-hinnant-date.rb)

Librería de fechas y horas basada en la cabecera \<chrono\> de C++11/14/17.

```sh
brew install cdalvaro/tap/howard-hinnant-date
```

Esta fórmula [está disponible](https://github.com/Homebrew/homebrew-core/blob/master/Formula/h/howard-hinnant-date.rb) en el repositorio homebrew-core. Pero he añadido la opción `--without-string-view` para deshabilitar el uso de `std::string_view` en la librería. Esto se debe a que `std::string_view` no está disponible en versiones anteriores a C++17.

### `json11`

[![Badge](https://img.shields.io/badge/dropbox-json11-grey?logo=github&color=181717)](https://github.com/dropbox/json11)
[![Badge](https://img.shields.io/badge/Formula-json11-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/json11.rb)

Librería para C++11 de JSON.

```sh
brew install cdalvaro/tap/json11
```

Se trata de una librería compuesta únicamente por archivos de cabecera y además el proyecto fue archivado en marzo de 2020, por lo que no está disponible en homebrew-core.

### `salt`

[![Badge](https://img.shields.io/badge/saltstack-salt-grey?logo=github&color=181717)](https://github.com/saltstack/salt)
[![Badge](https://img.shields.io/badge/Formula-salt-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/salt.rb)

Software para automatizar la gestión y configuración de cualquier infraestructura o aplicación a escala.

```sh
brew install cdalvaro/tap/salt
```

Salt usa su propia versión de python, por lo que [fue eliminado](https://github.com/Homebrew/homebrew-core/pull/157157) del repository homebrew-core. Pero lo mantengo actualizado por comodidad para instalarlo en mi NAS de Synology.

### `simple-web-server`

[![Badge](https://img.shields.io/badge/eidheim-Simple--Web--Server-grey?logo=gitlab&color=FC6D26)](https://gitlab.com/eidheim/Simple-Web-Server)
[![Badge](https://img.shields.io/badge/Formula-simple--web--server-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/simple-web-server.rb)

Servidor y cliente HTTP y HTTPS muy simple, rápido, multihilo e independiente de la plataforma, implementado en C++11 y Boost.Asio.

```sh
brew install cdalvaro/tap/simple-web-server
```

### `wxwidgets`

[![Badge](https://img.shields.io/badge/wxWidgets-wxWidgets-grey?logo=github&color=181717)](https://github.com/wxWidgets/wxWidgets)
[![Badge](https://img.shields.io/badge/Formula-wxwidgets-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Formula/wxwidgets.rb)

Librería de GUI multiplataforma.

```sh
brew install cdalvaro/tap/wxwidgets
```

Esta fórmula [está disponible](https://github.com/Homebrew/homebrew-core/blob/master/Formula/w/wxwidgets.rb) en el repositorio homebrew-core. Pero he añadido la opción `--with-enable-abort` para permitir la cancelación de una tarea en ejecución utilizando un `wxGenericProgressDialog`.

## Casks disponibles

<details>
  <summary>Lista de casks</summary>
  <ul>
    <li><a href="#salt-1">salt</a></li>
    <li><a href="#salt3006">salt@3006</a></li>
  </ul>
</details>

### `salt`

[![Badge](https://img.shields.io/badge/saltstack-salt-grey?logo=saltproject&color=57BCAD)](https://docs.saltproject.io/salt/install-guide/en/latest/topics/install-by-operating-system/macos.html)
[![Badge](https://img.shields.io/badge/Cask-salt-grey?logo=ruby&color=FBB040&logoColor=CC342D)](/Casks/salt.rb)

Software para automatizar la gestión y configuración de cualquier infraestructura o aplicación a escala.

Este cask instala salt STS usando el paquete de instalación oficial en lugar de construir el paquete completo desde el código fuente como hace la fórmula.

```sh
brew install --cask cdalvaro/tap/salt
```

Este cask [está disponible](https://github.com/Homebrew/homebrew-cask/blob/master/Casks/s/salt.rb) en el repositorio homebrew-cask. Sin embargo, he añadido [un parche](https://github.com/cdalvaro/homebrew-tap/blob/main/Casks/salt.rb#L1-L32) a los archivos `.plist` para que `salt` funcione correctamente con Homebrew sin necesidad de realizar ajustes adicionales.

El parche añade:

- La variable de entorno `HOMEBREW_PREFIX`.
- La variable de entorno `PATH` en el directorio de binarios asociado a `HOMEBREW_PREFIX`.
- La variable de entorno `HOME` con el directorio _home_ de `root`, para evitar un problema con el comando `brew`.

## Más documentación

Más documentación está disponible en: [Homebrew - Taps](https://docs.brew.sh/Taps)

### `salt@3006`

[![Badge](https://img.shields.io/badge/saltstack-salt%20LTS-grey?logo=saltproject&color=57BCAD)](https://docs.saltproject.io/salt/install-guide/en/latest/topics/install-by-operating-system/macos.html#lts-downloads)
[![Badge](https://img.shields.io/badge/Cask-salt@3006-grey?logo=ruby&color=FBB040&logoColor=CC342D)](Casks/salt@3006.rb)

Software para automatizar la gestión y configuración de cualquier infraestructura o aplicación a escala.

Este cask instala salt LTS usando el paquete de instalación oficial en lugar de construir el paquete completo desde el código fuente como hace la fórmula.

```sh
brew install --cask cdalvaro/tap/salt@3006
```

Este cask incluye todos los parches indicados en [`salt`](#salt-1).

## Más documentación

Más documentación está disponible en: [Homebrew - Taps](https://docs.brew.sh/Taps)

[homebrew_tap_badge]: https://img.shields.io/badge/brew%20tap-cdalvaro/tap-orange?logo=Homebrew&color=FBB040
[homebrew_tap_url]: https://github.com/cdalvaro/homebrew-tap
