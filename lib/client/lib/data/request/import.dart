library Request;

import 'dart:convert';
import 'dart:html';

abstract class HttpStatus {
  static const int CONTINUE = 100;
  static const int SWITCHING_PROTOCOLS = 101;
  static const int OK = 200;
  static const int CREATED = 201;
  static const int ACCEPTED = 202;
  static const int NON_AUTHORITATIVE_INFORMATION = 203;
  static const int NO_CONTENT = 204;
  static const int RESET_CONTENT = 205;
  static const int PARTIAL_CONTENT = 206;
  static const int MULTIPLE_CHOICES = 300;
  static const int MOVED_PERMANENTLY = 301;
  static const int FOUND = 302;
  static const int SEE_OTHER = 303;
  static const int NOT_MODIFIED = 304;
  static const int USE_PROXY = 305;
  static const int TEMPORARY_REDIRECT = 307;
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int PAYMENT_REQUIRED = 402;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int METHOD_NOT_ALLOWED = 405;
  static const int NOT_ACCEPTABLE = 406;
  static const int PROXY_AUTHENTICATION_REQUIRED = 407;
  static const int REQUEST_TIMEOUT = 408;
  static const int CONFLICT = 409;
  static const int GONE = 410;
  static const int LENGTH_REQUIRED = 411;
  static const int PRECONDITION_FAILED = 412;
  static const int REQUEST_ENTITY_TOO_LARGE = 413;
  static const int REQUEST_URI_TOO_LONG = 414;
  static const int UNSUPPORTED_MEDIA_TYPE = 415;
  static const int REQUESTED_RANGE_NOT_SATISFIABLE = 416;
  static const int EXPECTATION_FAILED = 417;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int NOT_IMPLEMENTED = 501;
  static const int BAD_GATEWAY = 502;
  static const int SERVICE_UNAVAILABLE = 503;
  static const int GATEWAY_TIMEOUT = 504;
  static const int HTTP_VERSION_NOT_SUPPORTED = 505;
  // Client generated status code.
  static const int NETWORK_CONNECT_TIMEOUT_ERROR = 599;
}

var _statuses = {
  HttpStatus.CONTINUE: "Continue",
  HttpStatus.SWITCHING_PROTOCOLS: "Switching Protocols",
  HttpStatus.OK: "OK",
  HttpStatus.CREATED: "Created",
  HttpStatus.ACCEPTED: "Accepted",
  HttpStatus.NON_AUTHORITATIVE_INFORMATION: "Nonauthoritative Information",
  HttpStatus.NO_CONTENT: "No Content",
  HttpStatus.RESET_CONTENT: "Reset Content",
  HttpStatus.PARTIAL_CONTENT: "Partial Content",
  HttpStatus.MULTIPLE_CHOICES: "Multiple Choices",
  HttpStatus.MOVED_PERMANENTLY: "Moved Permanently",
  HttpStatus.FOUND: "Found",
  HttpStatus.SEE_OTHER: "See Other",
  HttpStatus.NOT_MODIFIED: "Not Modified",
  HttpStatus.USE_PROXY: "Use Proxy",
  HttpStatus.TEMPORARY_REDIRECT: "Temporary Redirect",
  HttpStatus.BAD_REQUEST: "Bad Request",
  HttpStatus.UNAUTHORIZED: "Unauthorized",
  HttpStatus.PAYMENT_REQUIRED: "Payment Required",
  HttpStatus.FORBIDDEN: "Forbidden",
  HttpStatus.NOT_FOUND: "Not Found",
  HttpStatus.METHOD_NOT_ALLOWED: "Method Not Allowed",
  HttpStatus.NOT_ACCEPTABLE: "Not Acceptable",
  HttpStatus.PROXY_AUTHENTICATION_REQUIRED: "Proxy Authentication Required",
  HttpStatus.REQUEST_TIMEOUT: "Request Timeout",
  HttpStatus.CONFLICT: "Conflict",
  HttpStatus.GONE: "Gone",
  HttpStatus.LENGTH_REQUIRED: "Length Required",
  HttpStatus.PRECONDITION_FAILED: "Precondition Failed",
  HttpStatus.REQUEST_ENTITY_TOO_LARGE: "Request Entity Too Large",
  HttpStatus.REQUEST_URI_TOO_LONG: "Request URI Too Long",
  HttpStatus.UNSUPPORTED_MEDIA_TYPE: "Unsupported Media Type",
  HttpStatus.REQUESTED_RANGE_NOT_SATISFIABLE: "Requested Range Not Satisfiable",
  HttpStatus.EXPECTATION_FAILED: "Expectation Failed",
  HttpStatus.INTERNAL_SERVER_ERROR: "Internal Server Error",
  HttpStatus.NOT_IMPLEMENTED: "Not Implemented",
  HttpStatus.BAD_GATEWAY: "Bad Gateway",
  HttpStatus.SERVICE_UNAVAILABLE: "Service Unavailable",
  HttpStatus.GATEWAY_TIMEOUT: "Gateway Timeout",
  HttpStatus.HTTP_VERSION_NOT_SUPPORTED: "HTTP Version Not Supported",
  HttpStatus.NETWORK_CONNECT_TIMEOUT_ERROR: "Network Connect Timeout Error",
};

class Response {
  final String _requestMethod;
  final String _requestURL;
  final int status;
  final String raw;

  Response(
    String this._requestMethod,
    String this._requestURL,
    this.status,
    String this.raw,
  ) {}

  Map decode() {
    return jsonDecode(this.raw);
  }

  bool logIfNotOK() {
    if (HttpStatus.OK != this.status) {
      this.log();
      return true;
    }
    return false;
  }

  void log() {
    var statusMessage = _statuses[this.status];
    var response = this.raw;
    if (1024 < response.length) {
      response = this.raw.substring(0, 1024);
    }
    var message = """
      ERROR (Failed Request):
          FROM: ${this._requestMethod} ${this._requestURL}
          GOT: ${this.status} ${statusMessage}
          CONTENTS: ${response}
    """;
    print(message);
  }
}

Request delete(String url) {return new Request(url).delete();}
Request get(String url) {return new Request(url).get();}
Request post(String url) {return new Request(url).post();}
Request put(String url) {return new Request(url).put();}

class Request {
  static const _delete = "DELETE";
  static const _get = "GET";
  static const _post = "POST";
  static const _put = "PUT";

  final String _url;
  String _method = Request._get;
  String _value = "";
  Function _callback;
  FormData _form;
  Map<String, String> _headers = new Map<String, String>();

  Request(String this._url) {}

  Request delete() {
    this._method = Request._delete;
    return this;
  }

  Request get() {
    this._method = Request._get;
    return this;
  }

  Request post() {
    this._method = Request._post;
    return this;
  }

  Request put() {
    this._method = Request._put;
    return this;
  }

  Request upload(FormData form) {
    this._form = form;
    this._method = Request._post;
    return this;
  }

  Request using(String key, String value) {
    this._headers[key] = value;
    return this;
  }

  Request json(Map value) {
    this._value = jsonEncode(value);
    return this;
  }

  Request then(Function callback) {
    this._callback = callback;
    return this;
  }

  void send() {
    print("MESSAGE: ${this._method} ${this._url}");
    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      if (HttpRequest.DONE == request.readyState) {
        if (null != this._callback) {
          this._callback(new Response(
            this._method, this._url,
            request.status, request.responseText,
          ));
        }
      }
    });

    request.open(this._method, this._url, async: true);
    this._headers.forEach((String key, String value) {
      request.setRequestHeader(key, value);
    });
    if (null != this._form) {
      request.send(this._form);
    } else {
      request.send(this._value);
    }
  }
}