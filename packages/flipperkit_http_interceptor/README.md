# flipperkit_http_interceptor

[![Original pub package](https://img.shields.io/pub/v/flipperkit_http_interceptor.svg)](https://pub.dartlang.org/packages/flipperkit_http_interceptor)

English

> `flutter_flipperkit` does not support global interception of [http](https://github.com/dart-lang/http) library network requests, please set the network plugin `useHttpOverrides` parameter to `false`.

## Getting Started

### Prerequisites

Before starting make sure you have:

- Installed [flutter_flipperkit](https://github.com/leanflutter/flutter_flipperkit)
- Installed [http](https://github.com/dart-lang/http)

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_flipperkit:
    git:
      url: https://github.com/sengerts/flutter_flipperkit_plugins
      ref: master
```

You can install packages from the command line:

```bash
$ flutter packages get
```

### Usage

```dart
void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin(
    // If you use http library, you must set it to false
    useHttpOverrides: false,
  ));
  flipperClient.start();

  runApp(MyApp());
}

...

```

```dart
import 'package:flipperkit_http_interceptor/flipperkit_http_interceptor.dart';

void sendRequest() async {
  var http = new HttpClientWithInterceptor();
  var response = http.get("https://example.com");
}
```

## License

```
MIT License

Copyright (c) 2022 sengerts <lijy91@foxmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
