class HttpResponseModel {
  /// 接口请求是否成功
  bool success = false;

  /// 状态码
  String code = '';

  /// 状态提示
  String message = '';

  /// 业务数据
  dynamic data;

  HttpResponseModel.success(this.data)
      : code = 'ok',
        success = true;

  HttpResponseModel.failure({
    this.code = '',
    this.message = '',
    this.data,
  }) : success = false;

  @override
  String toString() {
    return 'HttpResponse code:$code, message:$message, data:$data';
  }
}

/// 请求异常
class RequestException extends HttpResponseModel {
  RequestException(String code, String message)
      : super.failure(code: code, message: message);
}

/// 网络异常
class NetworkException extends RequestException {
  NetworkException(int statusCode, String message)
      : super('NO CONTENT', message);
}

/// 授权异常
class UnauthorisedException extends RequestException {
  UnauthorisedException(super.code, super.message);
}
