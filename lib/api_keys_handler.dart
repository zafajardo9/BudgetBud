import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIKeys {
  final currentExchangeAPI = dotenv.env['CURRENCY_API'];
  final newsAPI = dotenv.env['NEWS_API'];
}
