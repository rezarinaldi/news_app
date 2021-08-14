import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:card_swiper/card_swiper.dart';
import 'package:news_app/details_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _get = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "News Apps CodingTalk",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1D282A),
          title: new Center(
            child: Text(
              "News Page",
              style: TextStyle(color: Colors.white),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        author: _get[index]["author"],
                        title: _get[index]["title"],
                        description: _get[index]["description"],
                        urlToImage: _get[index]["urlToImage"],
                        publishedAt: _get[index]["publishedAt"],
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          topRight: Radius.circular(35.0),
                        ),
                        child: Image.network(
                          _get[index]["urlToImage"],
                          fit: BoxFit.cover,
                          height: 400.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 350.0, 0.0, 0.0),
                      child: Container(
                        height: 200.0,
                        width: 400.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(35.0),
                          elevation: 10.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 20.0),
                                child: Text(
                                  _get[index]["title"],
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: _get == null ? 0 : _get.length,
            autoplay: true,
            viewportFraction: 0.8,
            scale: 0.9,
          ),
        ),
      ),
    );
  }

  Future _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://newsapi.org/v2/everything?q=tech&apiKey=0b0b712f35b54dae9b147f3105cf60cc"),
      );

      // untuk cek data
      if (response.statusCode == 200) {
        print(response.body);
        final data = jsonDecode(response.body);
        setState(() {
          _get = data['articles'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
