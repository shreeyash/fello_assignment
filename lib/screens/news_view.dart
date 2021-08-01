import 'dart:convert';

import 'package:fello_assignment/models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsView extends StatefulWidget {
  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  ScrollController _scrollController = ScrollController();
  static const String apiPath =
      "https://newsapi.org/v2/everything?q=bitcoin&apiKey=c8ec83cde494416b89832477faf42bcb&pageSize=20&page=";

  final Uri apiUri = Uri.parse(apiPath);

  bool _initialLoading = true;
  bool _loadingMoreNews = false;
  int _pageNo = 1;
  List<Articles> _articles = [];

  @override
  void initState() {
    super.initState();

    getNewsData(1).then((value) {
      setState(() {
        _initialLoading = false;
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getNewsData(_pageNo);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getNewsData(int pageNo) async {
    final url = apiPath + "$pageNo";
    final Uri apiUri = Uri.parse(url);

    setState(() {
      _loadingMoreNews = true;
    });

    try {
      final response = await http.get(apiUri);
      if (response.statusCode == 200) {
        final NewsModel newsModel =
            NewsModel.fromJson(jsonDecode(response.body));
        if (pageNo > 1) {
          setState(() {
            newsModel.articles.forEach((element) {
              _articles.add(element);
            });
          });
        } else {
          newsModel.articles.forEach((element) {
            _articles.add(element);
          });
        }
        _pageNo++;
      } else {
        throw Exception('Failed to load album');
      }

      setState(() {
        _loadingMoreNews = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _initialLoading
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) => ListTile(
                  minVerticalPadding: 12,
                  tileColor: Colors.white,
                  leading: Text("${index + 1}"),
                  title: Text(_articles[index].title),
                  subtitle: Text(_articles[index].description),
                  minLeadingWidth: 4,
                ),
                itemCount: _articles.length,
              ),
              if (_loadingMoreNews)
                Center(
                  child: Container(
                    height: 120,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Fetching more news, please wait",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CircularProgressIndicator(
                            strokeWidth: 5,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
  }
}
