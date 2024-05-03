import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/plan_data.dart';


class PlanDetailScreen extends StatefulWidget {
  const PlanDetailScreen({Key? key, required this.plan}):super(key:key);

  final Plan plan;

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.eventName),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
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
                    Text(formatDateTime(widget.plan.start),
                      style: TextStyle(
                        fontSize: 20.0, // 글자 크기를 24로 설정
                      ),
                    ),
                    if(widget.plan.start!=widget.plan.end)
                      Text(' ~ '),
                    if(widget.plan.start!=widget.plan.end)
                      Text(formatDateTime(widget.plan.end),
                        style: TextStyle(
                          fontSize: 20.0, // 글자 크기를 24로 설정
                        ),
                      ),
                  ],
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
                          Text(widget.plan.startTime,
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
                          Text(widget.plan.endTime,
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
                      Text(widget.plan.eventLocationStart,
                        style: TextStyle(
                          fontSize: 20.0, // 글자 크기를 24로 설정
                        ),
                      ),
                      if (widget.plan.eventLocationStart != widget.plan.eventLocationEnd)
                        Text(widget.plan.eventLocationEnd,
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
