import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIKeys {
  final currentExchangeAPI = dotenv.env['CURRENCY_API'];
  final newsAPI = dotenv.env['NEWS_API'];
  final suggestionsAPI = dotenv.env['SUGGESTION_API'];

  final suggestionsURI = dotenv.env['SUGGESTION_API'];
  final tipsURI = dotenv.env['TIPS_URI'];
}
