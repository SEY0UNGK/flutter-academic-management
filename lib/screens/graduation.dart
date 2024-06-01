import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'server.dart';

class GraduationScreen extends StatefulWidget {
 @override
 _GraduationScreenState createState() => _GraduationScreenState();
 

}
class GraduationRequirement {
  final String requirement;
  final bool completed;
  final List<Map<String, String>> details;

  GraduationRequirement({
    required this.requirement,
    required this.completed,
    required this.details,
  });
}

class _GraduationScreenState extends State<GraduationScreen>{


  List<GraduationRequirement> recommendations = [
  GraduationRequirement(
    requirement: '수강신청',
    completed: true,
    details: [
      ],
  ),
  GraduationRequirement(
    requirement: '봉사활동',
    completed: false,
    details: [
     ],
  ),
  GraduationRequirement(
    requirement: '채용공고',
    completed: true,
    details: [
      ],
  ),
  GraduationRequirement(
    requirement: '자격증',
    completed: false,
    details: [
      ],
  ),
  GraduationRequirement(
    requirement: '학교활동',
    completed: false,
    details: [
     
    ],
  ),
];
  final String userName = userProfile.userName;
  final String department = userProfile.department;
  final String year = "${userProfile.year[0]}학년 ${userProfile.year[2]}학기";
  final String studentId = userProfile.studentId;
  final int graduationScore = userProfile.graduationScore; // 졸업 진척도 예시 (750점)
  final int maxScore = userProfile.maxScore; // 총점 1000점
  
  @override
  void initState(){
    super.initState();
    //fetchData(); // initState에서 초기화 시점에 데이터 요청
  }
  
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xffECEFF1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$department | $year | $studentId',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff546E7A),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Graduation Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: graduationScore / maxScore,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$graduationScore / $maxScore',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff546E7A),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                '추천 활동',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  return ExpansionTile(
                    title: Text(recommendation.requirement),
                    trailing: Icon(
                      recommendation.completed
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: recommendation.completed
                          ? Colors.green
                          : Colors.red,
                    ),
                    children: recommendation.details.map((detail) {
                      return ListTile(
                        title: Text(detail['title'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: detail.entries.
                          where((entry) => entry.key != 'title')
                          .map((entry) => Text('${entry.key}: ${entry.value}'))
                          .toList(),
                        ),
                    );
                  }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
