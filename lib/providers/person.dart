import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String server = "http://13.237.43.243:8000"; // 국민 서버
const String server2 = "http://43.202.133.222:8080"; // 지훈 서버

class UserProfile {
  final String userName;
  final String department;
  final String year;
  final String studentId;
  final int graduationScore;
  final int maxScore;
  final List<String> skills;
  final Map<String, bool> subjects;
  final String? profileImage;

  UserProfile({
    required this.userName,
    required this.department,
    required this.year,
    required this.studentId,
    required this.graduationScore,
    required this.maxScore,
    required this.skills, // 스킬 넣는거임 ex) 파이썬 이런거
    required this.subjects, // 내가 수강한 과목 넣기!
    required this.profileImage,
  });

  // JSON 데이터를 UserProfile 객체로 변환하기 위한 factory constructor 추가
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userName: json['userName'] ?? '',
      department: json['department'] ?? '',
      year: json['year'] ?? '',
      studentId: json['studentId'] ?? '',
      graduationScore: json['graduationScore'] ?? 0,
      maxScore: json['maxScore'] ?? 0,
      skills: List<String>.from(json['skills'] ?? ["파이썬"]),
      subjects: Map<String, bool>.from(
          json['subjects'] ?? {"자료구조": true, "알고리즘": true, "캡스톤디자인": true}),
      profileImage: json['profileImage'],
    );
  }
}

// 전역 UserProfile 인스턴스
UserProfile userProfile = UserProfile(
  userName: '김성민',
  department: '컴퓨터공학과',
  year: '4-1',
  studentId: '20180595',
  graduationScore: 30,
  maxScore: 1000,
  skills: ["파이썬"],
  subjects: {"자료구조": true, "알고리즘": true, "캡스톤디자인": true},
  profileImage: null,
);

Future<bool> sendLoginRequest(String studentId, String password) async {
  final url = Uri.parse('$server2/member/login');
  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({"studentId": studentId, "memberPassword": password});

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Login successful');
    final responseBody = json.decode(utf8.decode(response.bodyBytes));
    print('response : $responseBody');

    final token = response.headers['authorization'];
    if (token != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      print('Token saved: $token');
    }
    userProfile = UserProfile.fromJson(responseBody['useData']);
    return true; // 로그인 성공 시 true 반환
  } else {
    print('Login failed: ${response.statusCode}');
    print('Response body: ${response.body}');
    return false; // 로그인 실패 시 false 반환
  }
}
