import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:hacker_stories/api/newsapi.dart';
import 'package:hacker_stories/helper/webservice.dart';

class TopArticleList extends StatefulWidget {
  @override
  _TopArticleListState createState() => _TopArticleListState();
}

class _TopArticleListState extends State<TopArticleList> {
  List<Story> _stories = List<Story>();

  @override
  void initState() {
    super.initState();
    _populateTopStories();
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true);
    }
  }

  void _populateTopStories() async {
    final responses = await Webservice().getTopStories();
    final stories = responses.map((response) {
      final json = jsonDecode(response.body);
      return Story.fromJSON(json);
    }).toList();

    setState(() {
      _stories = stories;
    });
  }

  // ignore: unused_element

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Hacker News"), backgroundColor: Colors.red),
        body: ListView.builder(
            itemCount: _stories.length,
            itemBuilder: (_, index) {
              var date = DateTime.fromMillisecondsSinceEpoch(
                  _stories[index].time * 1000);
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(right: 6.0),
                          child: Text(
                            _stories[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 17.0),
                          ),
                        )),
                        Column(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_drop_up_outlined,
                              color: Colors.red,
                              size: 45,
                            ),
                            Text(
                              "${_stories[index].score}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            )
                          ],
                        )
                      ],
                    )),
                    Container(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Row(
                        children: [
                          Text(
                            "${_stories[index].commentIds.length} Comments\t\t ",
                            style: TextStyle(
                                // fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                                color: Colors.black),
                          ),
                          Text(
                            "By ${_stories[index].by != null ? _stories[index].by : 'unknown'} - ${timeago.format(date)}",
                            style: TextStyle(
                                // fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    child: Text(
                                  _stories[index].url != null
                                      ? _stories[index].url
                                      : "-",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.0,
                                  ),
                                )),
                              ),
                            ],
                          )),
                      onTap: () {
                        launchURL(_stories[index].url);
                      },
                    )
                  ],
                ),
              );
            }));
  }
}
