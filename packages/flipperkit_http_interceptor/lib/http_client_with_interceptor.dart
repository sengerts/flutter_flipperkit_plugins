library flipperkit_http_client;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class HttpClientWithInterceptor implements http.BaseClient {
  Uuid _uuid = new Uuid();
  http.Client _client = new http.Client();

  @override
  void close() {
    _client.close();
  }

  @override
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _withInterceptor(
      method: 'DELETE',
      url: url,
      headers: headers ?? {},
      sendRequest: () => _client.delete(url, headers: headers),
    );
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _withInterceptor(
      method: 'GET',
      url: url,
      headers: headers ?? {},
      sendRequest: () => _client.get(url, headers: headers),
    );
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    return _withInterceptor(
      method: 'HEAD',
      url: url,
      headers: headers ?? {},
      sendRequest: () => _client.head(url, headers: headers),
    );
  }

  @override
  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _withInterceptor(
      method: 'PATCH',
      url: url,
      headers: headers ?? {},
      body: body,
      encoding: encoding,
      sendRequest: () => _client.patch(url, headers: headers, body: body, encoding: encoding),
    );
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _withInterceptor(
      method: 'POST',
      url: url,
      headers: headers ?? {},
      body: body,
      encoding: encoding,
      sendRequest: () => _client.post(url, headers: headers, body: body, encoding: encoding),
    );
  }

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _withInterceptor(
      method: 'PUT',
      url: url,
      headers: headers ?? {},
      body: body,
      encoding: encoding,
      sendRequest: () => _client.put(url, headers: headers, body: body, encoding: encoding),
    );
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    return _client.read(url, headers: headers);
  }

  @override
  Future<Uint8List> readBytes(url, {Map<String, String>? headers}) {
    return _client.readBytes(url, headers: headers);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }

  Future<http.Response> _withInterceptor({
    required String method,
    required Uri url,
    required Map<String, String> headers,
    body,
    Encoding? encoding,
    required Future<http.Response> Function() sendRequest,
  }) async {
    String requestId = _uuid.v4();
    _reportRequest(
      requestId,
      method: method,
      url: url,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    http.Response response = await sendRequest();

    _reportResponse(requestId, response);

    return response;
  }

  Future<bool> _reportRequest(
    requestId, {
    required String method,
    required Uri url,
    required Map<String, String> headers,
    body,
    Encoding? encoding,
  }) async {
    RequestInfo requestInfo = new RequestInfo(
      requestId: requestId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      uri: url.toString(),
      headers: headers,
      method: method,
      body: body,
    );

    FlipperPlugin? _flipperNetworkPlugin = FlipperClient.getDefault().getPlugin(FlipperNetworkPlugin.ID);

    if (_flipperNetworkPlugin != null && _flipperNetworkPlugin is FlipperNetworkPlugin) {
      _flipperNetworkPlugin.reportRequest(requestInfo);
    }
    return true;
  }

  Future<bool> _reportResponse(String requestId, http.Response response) async {
    ResponseInfo responseInfo = new ResponseInfo(
      requestId: requestId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      statusCode: response.statusCode,
      headers: response.headers,
      body: response.body,
    );

    FlipperPlugin? _flipperNetworkPlugin = FlipperClient.getDefault().getPlugin(FlipperNetworkPlugin.ID);

    if (_flipperNetworkPlugin != null && _flipperNetworkPlugin is FlipperNetworkPlugin) {
      _flipperNetworkPlugin.reportResponse(responseInfo);
    }
    return true;
  }
}
