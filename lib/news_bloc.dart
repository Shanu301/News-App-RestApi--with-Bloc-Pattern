import 'dart:async';
import 'dart:convert';

import 'news_info.dart';
import 'package:http/http.dart' as http;
enum NewsAction{ Fetch, Delete}

class NewsBloc {


  final _statesStreamContoller = StreamController<List<Article>>();
  StreamSink<List<Article>> get _newsSink => _statesStreamContoller.sink;
  Stream<List<Article>> get newsStream => _statesStreamContoller.stream;


  final _eventStreamContoller = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => _eventStreamContoller.sink;
  Stream<NewsAction> get _eventStream => _eventStreamContoller.stream;


  NewsBloc(){
    _eventStream.listen((event) async {
      if(event == NewsAction.Fetch )
        {
           try {
             var news = await getNews();
             _newsSink.add(news.articles);
             print('jaanu');
            //  if(news != null)
            //   // print('shanu');
            //    _newsSink.add(news.articles);
            //  else
            //
            //      _newsSink.addError('Something went wrong');
            //

           } on Exception catch (e) {
             // TODO
             _newsSink.addError('Something went wrong');
           }
        }
    });
  }



  Future<NewsModel> getNews() async {
    var client = http.Client();
    var newsModel;
   var String_news = 'http://newsapi.org/v2/everything?domains=wsj.com&apiKey=fdff9a4d5251419d84d09418e548991b';
    try {
      var response = await client.get(String_news);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        newsModel = NewsModel.fromJson(jsonMap);
      }
    } catch (Exception) {
      return newsModel;
    }

    return newsModel;
  }


  // Future<NewsModel> getNews() async {
  //   final result = await http.Client().get("http://newsapi.org/v2/everything?domains=wsj.com&apiKey=fdff9a4d5251419d84d09418e548991b");
  //
  //   if(result.statusCode != 200)
  //     throw Exception();
  //
  //   return parsedJson(result.body);
  // }
  //
  // NewsModel parsedJson(final response){
  //   final jsonDecoded = json.decode(response);
  //
  //   final jsonMap = jsonDecoded["articles"];
  //
  //   return NewsModel.fromJson(jsonMap);
  // }
}