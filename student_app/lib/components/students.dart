import 'package:attendease/database/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//create a list from pocketbase
class TestList extends StatefulWidget {
  const TestList({super.key});

  @override
  State<TestList> createState() => _TestListState();
}

class _TestListState extends State<TestList> {
  List<Student> students = [];
  RxBool isLoading = true.obs;
  @override
  void initState() {
    super.initState();
    try {
      PbDb.pb
          .collection('users')
          .getFullList(
            batch: 200,
            sort: '-created',
          )
          .then((value) {
        // print(value);
        for (var element in value) {
          // print(element.data['name']);
          students.add(Student(
            uid: element.data['uid'],
            name: element.data['name'],
            year: element.data['year'],
            division: element.data['division'],
            subdivision: element.data['subdivision'],
            id: element.id,
          ));
        }
        isLoading.value = false;
      });
    } catch (e) {
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        child: (isLoading.value)
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount: students.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tileColor: Colors.blue,
                          splashColor: Colors.blueGrey,
                          title: Text(students[index].name),
                          subtitle: Text(students[index].uid.toString()),
                          trailing: Column(
                            children: [
                              const Text("\nDivision",
                                  style: TextStyle(fontSize: 10)),
                              Text(students[index].subdivision.toString()),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
      );
    });
  }
}

class Student {
  final int uid;
  final String name;
  final int year;
  final String division;
  final String subdivision;
  final String id;
  Student({
    required this.uid,
    required this.name,
    required this.year,
    required this.division,
    required this.subdivision,
    required this.id,
  });
   factory Student.fromJson(dynamic json) {
    return Student(
      uid: json['uid'] as int,
      name: json['name'] as String,
      year: json['year'] as int,
      division: json['division'] as String,
      subdivision: json['subdivision'] as String,
      id: json['id'] as String,
      );
  }
  Map toJson() => {
        'uid': uid,
        'name': name,
        'year': year,
        'division': division,
        'subdivision': subdivision,
        'id': id,
      };

      //get name, uid, year, division, subdivision
        String getName() {
        return name;
      }
  // static fromJson(jsonDecode) {
  //   return {
  //     'uid': jsonDecode['uid'],
  //     'name': jsonDecode['name'],
  //     'year': jsonDecode['year'],
  //     'division': jsonDecode['division'],
  //     'subdivision': jsonDecode['subdivision'],
  //   };
  // }
}
