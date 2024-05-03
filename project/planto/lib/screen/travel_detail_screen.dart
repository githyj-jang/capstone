import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/travel_data.dart';

class TravelDetailScreen extends StatefulWidget {
  const TravelDetailScreen({Key? key, required this.travel}):super(key:key);

  final Travel travel;

  @override
  State<TravelDetailScreen> createState() => _TravelDetailScreenState();
}

class _TravelDetailScreenState extends State<TravelDetailScreen> {
  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.travel.eventName),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("기간 : ",
                        style: TextStyle(
                          fontSize: 24.0, // 글자 크기
                          color: Colors.blue, // 글자 색상을 파란색으로 설정
                          fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
                        ),
                      ),
                      Text(formatDateTime(widget.travel.start),
                        style: TextStyle(
                          fontSize: 20.0, // 글자 크기를 24로 설정
                        ),
                      ),
                      if(formatDateTime(widget.travel.start)!=formatDateTime(widget.travel.end))
                        Text(' ~ '),
                      if(formatDateTime(widget.travel.start)!=formatDateTime(widget.travel.end))
                        Text(formatDateTime(widget.travel.end),
                          style: TextStyle(
                            fontSize: 20.0, // 글자 크기를 24로 설정
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.3,
                      child: Column(
                        children: [
                          Text("시작 시간",
                            style: TextStyle(
                              fontSize: 24.0, // 글자 크기
                              color: Colors.blue, // 글자 색상을 파란색으로 설정
                              fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
                            ),
                          ),
                          Text(widget.travel.startTime,
                            style: TextStyle(
                              fontSize: 20.0, // 글자 크기를 24로 설정
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.3,
                      child: Column(
                        children: [
                          Text('종료 시간',
                            style: TextStyle(
                              fontSize: 24.0, // 글자 크기
                              color: Colors.blue, // 글자 색상을 파란색으로 설정
                              fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
                            ),
                          ),
                          Text(widget.travel.endTime,
                            style: TextStyle(
                              fontSize: 20.0, // 글자 크기를 24로 설정
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),

              Card(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.7,
                  child: Column(
                    children: [
                      Text(' 경로 ',
                        style: TextStyle(
                          fontSize: 24.0, // 글자 크기
                          color: Colors.blue, // 글자 색상을 파란색으로 설정
                          fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
                        ),
                      ),
                      Text(widget.travel.eventLocationStart,
                        style: TextStyle(
                          fontSize: 20.0, // 글자 크기를 24로 설정
                        ),
                      ),
                      if (widget.travel.eventLocationStart != widget.travel.eventLocationEnd)
                        Text(widget.travel.eventLocationEnd,
                          style: TextStyle(
                            fontSize: 20.0, // 글자 크기를 24로 설정
                          ),
                        ),
                    ],

                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
