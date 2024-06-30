import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_response_model.dart';

class NetworkManager {
  NetworkManager._internal();

  static final NetworkManager _instance = NetworkManager._internal();

  factory NetworkManager() => _instance;

  Future<HttpResponseModel> get(
    String url, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Dio dio = _getDio(headers: headers);
      final response =
          await dio.get(url, queryParameters: params, options: options);
      HttpResponseModel r = _handleRephonse(response);

      // 处理token失效
      if (r is UnauthorisedException || r.code == '401') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('token');
        // TODO: 提示登录
      }

      return r;
    } on Exception catch (e) {
      return _handleException(e);
    }
  }

  /// 处理接口响应
  HttpResponseModel _handleRephonse(Response? response) {
    if (response == null) {
      return RequestException('NO CONTENT', '返回值空异常');
    }

    /// 使用的接口返回数据没有统一规范，不能通过code(没有)判断状态，
    /// 因此这里统一返回成功，业务层需要自行通过数据进行判断
    var data = response.data;
    log(data);
    return HttpResponseModel.success(data);
    // var data = response.data;
    // var code = data["code"];
    // log(data);
    // switch (code) {
    //   case 'OK':
    //     return HttpResponse.success(data);
    //   case 'UNAUTHORIZED':
    //     return UnauthorisedException(code, data["msg"]);
    //   default:
    //     return RequestException(code, data["msg"]);
    // }
  }

  /// 处理接口异常
  HttpResponseModel _handleException(Exception exception) {
    print(exception);
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.cancel:
        case DioExceptionType.connectionError:
          return NetworkException(
              exception.response?.statusCode ?? 0, exception.message ?? '');
        case DioExceptionType.badCertificate:
          return UnauthorisedException(
              exception.response?.statusCode.toString() ?? 'NO CONTENT',
              exception.message ?? '');
        case DioExceptionType.badResponse:
          return RequestException('NO CONTENT', exception.message ?? '');
        case DioExceptionType.unknown:
          if (exception is SocketException) {
            return NetworkException(
                exception.response?.statusCode ?? 0, exception.message ?? '');
          }
          return RequestException('NO CONTENT', exception.message ?? '');
        default:
          return RequestException('NO CONTENT', exception.message ?? '');
      }
    }

    return RequestException('NO CONTENT', exception.toString());
  }
}

extension NetworkConfig on NetworkManager {
  Dio _getDio({Map<String, dynamic>? headers}) {
    final BaseOptions options = BaseOptions(
        baseUrl: '',
        contentType: 'application/json',
        headers: headers,
        connectTimeout: const Duration(milliseconds: 3000),
        sendTimeout: const Duration(milliseconds: 3000),
        receiveTimeout: const Duration(milliseconds: 3000));

    final PrettyDioLogger logger = PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
        maxWidth: 100);

    final Dio dio = Dio()
      ..options = options
      ..interceptors.add(_getInterceptors())
      ..interceptors.add(logger);

    return dio;
  }
}

extension HttpInterceptor on NetworkManager {
  InterceptorsWrapper _getInterceptors() {
    final InterceptorsWrapper interceptors = InterceptorsWrapper(
        onRequest: (options, handler) => _requestInterceptor(options, handler),
        onResponse: (response, handler) =>
            _responseInterceptor(response, handler),
        onError: (error, handler) => _exceptionInterceptor(error, handler));
    return interceptors;
  }

  // 接口请求拦截器
  void _requestInterceptor(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Do something before request is sent.
    // If you want to resolve the request with custom data,
    // you can resolve a `Response` using `handler.resolve(response)`.
    // If you want to reject the request with a error message,
    // you can reject with a `DioException` using `handler.reject(dioError)`.
    // return handler.next(options);

    if (options.headers.containsKey("requiresToken")) {
      // 判断是否需要设置token
      if (options.headers["requiresToken"]) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.get("token");

        if (token == null) {
          // 本地无token,拒绝接口请求
          return handler.reject(DioException(
              requestOptions: options,
              type: DioExceptionType.badCertificate,
              message: "token无效"));
        }
        options.headers.addAll({"Token": "$token${DateTime.now()}"});
      }

      // 移除备用字段
      options.headers.remove("requiresToken");
    }

    return handler.next(options);
  }

  void _responseInterceptor(
      Response response, ResponseInterceptorHandler handler) {
    // Do something with response data.
    // If you want to reject the request with a error message,
    // you can reject a `DioException` object using `handler.reject(dioError)`.
    return handler.next(response);
  }

  void _exceptionInterceptor(
      DioException error, ErrorInterceptorHandler handler) {
    // Do something with response error.
    // If you want to resolve the request with some custom data,
    // you can resolve a `Response` object using `handler.resolve(response)`.
    return handler.next(error);
  }
}
