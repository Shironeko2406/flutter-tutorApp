// import 'dart:convert';
// import 'package:app/Component/app_bar.dart';
// import 'package:app/Component/nav_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List posts = [];
//   List filteredPosts = [];
//   String _sortStatus = 'all';
//   int _selectedIndex = 0;
//   String _searchQuery = '';

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     // Navigate to different pages based on the selected index
//     switch (index) {
//       case 0:
//         context.go('/home');
//         break;
//       case 1:
//         context.go('/home/appointment');

//         break;
//       case 2:
//         context.go('/home/user-profile');
//         break;
//     }
//   }

//   //Call api GET fetch data post request user login
//   Future<void> FetchPostListUserLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('accessToken');
//     const url = "https://10.0.2.2:7194/PostRequest/post-request-user-login";
//     // const url = "http://ec2-18-141-87-114.ap-southeast-1.compute.amazonaws.com/PostRequest/post-request-user-login";
//     final uri = Uri.parse(url);
//     final response = await http.get(uri, headers: {
//       'Content-type': 'application/json',
//       'Authorization': 'Bearer $token',
//     });
//     if (response.statusCode == 200) {
//       final dataPostList = jsonDecode(response.body);
//       setState(() {
//         posts = dataPostList.where((post) => post['status'] != 3).toList();
//         filteredPosts = posts;
//       });
//       print(posts);
//     } else {}
//   }

//   Future<void> DeletePostById(id) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('accessToken');
//     final url = 'https://10.0.2.2:7194/PostRequest/post-request-postId/$id';
//     // final url = 'http://ec2-18-141-87-114.ap-southeast-1.compute.amazonaws.com/PostRequest/post-request-postId/$id';
//     final uri = Uri.parse(url);
//     final response = await http.delete(uri, headers: {
//       'Content-type': 'application/json',
//       'Authorization': 'Bearer $token',
//     });

//     if (response.statusCode == 200) {
//       // Show toast notification for successful deletion
//       Fluttertoast.showToast(
//         msg: "Delete post success",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.TOP,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );

//       // Fetch updated post list
//       FetchPostListUserLogin();
//     } else {
//       // Show toast notification for failure
//       Fluttertoast.showToast(
//         msg: "Failed to delete post",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.TOP,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     }

//     print(response.body);
//   }

//   Future<void> getPostById(id) async {
//     final url = 'https://10.0.2.2:7194/PostRequest/post-request-id/$id';
//     // final url = 'http://ec2-18-141-87-114.ap-southeast-1.compute.amazonaws.com/PostRequest/post-request-id/$id';
//     final uri = Uri.parse(url);
//     final response = await http.get(uri);
//     if (response.statusCode == 200) {
//       final postData = jsonDecode(response.body);
//       // Navigate to the edit post page with the post data
//       context.go('/home/edit-post', extra: postData);
//     } else {
//       // Handle error
//       print('Failed to load post');
//     }
//   }

//   Future<void> getTutorById(String id, String postId) async {
//     final url = 'https://10.0.2.2:7194/Tutor/tutor-by-id/$id';
//     // final url = 'http://ec2-18-141-87-114.ap-southeast-1.compute.amazonaws.com/Tutor/tutor-by-id/$id';
//     final uri = Uri.parse(url);
//     final response = await http.get(uri);
//     if (response.statusCode == 200) {
//       final tutorData = jsonDecode(response.body);
//       print(tutorData);
//       //chuyển đến trong view tutor có params id
//       context.go('/home/view-tutor/$id/$postId', extra: tutorData);
//       //fetch dữ liệu lên trang
//     } else {
//       // Handle error
//       print('Failed to load post');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     FetchPostListUserLogin();
//   }

//   //Format hiện thời gian post
//   String formatDate(String dateTime) {
//     final DateTime parsedDate = DateTime.parse(dateTime);
//     final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
//     return formatter.format(parsedDate);
//   }

//   // void searchPosts(String query) {
//   //   final results = posts.where((post) {
//   //     final postDescription = post['description']?.toLowerCase() ?? '';
//   //     final input = query.toLowerCase();
//   //     return postDescription.contains(input);
//   //   }).toList();
//   //   setState(() {
//   //     filteredPosts = results;
//   //   });
//   // }

//   // void sortPosts(String status) {
//   //   final statusValue = status == 'pending' ? 0 : 1;
//   //   final results =
//   //       posts.where((post) => post['status'] == statusValue).toList();
//   //   setState(() {
//   //     filteredPosts = results;
//   //   });
//   // }

//   void searchPosts(String query) {
//     setState(() {
//       _searchQuery = query;
//       _applyFilters();
//     });
//   }

//   void sortPosts(String status) {
//     setState(() {
//       _sortStatus = status;
//       _applyFilters();
//     });
//   }

//   void _applyFilters() {
//     final results = posts.where((post) {
//       final postDescription = post['description']?.toLowerCase() ?? '';
//       final input = _searchQuery.toLowerCase();
//       final matchesSearch = postDescription.contains(input);
//       final matchesSort = _sortStatus == 'all' ||
//           (_sortStatus == 'pending' && post['status'] == 0) ||
//           (_sortStatus == 'public' && post['status'] == 1);

//       return matchesSearch && matchesSort;
//     }).toList();
//     setState(() {
//       filteredPosts = results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         onSearch: searchPosts,
//         onSort: sortPosts,
//       ),
//       body: RefreshIndicator(
//         onRefresh: FetchPostListUserLogin,
//         child: ListView.builder(
//           itemCount: filteredPosts.length,
//           itemBuilder: (context, index) {
//             final post = filteredPosts[index];
//             final id = post['postId'].toString();
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: NetworkImage(post['avatarUrl'] ??
//                               'https://via.placeholder.com/150'),
//                         ),
//                         const SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   post['createdByUsername'] ?? '',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 post['status'] == 0
//                                     ? Icon(Icons.pending,
//                                         size: 16,
//                                         color: Colors
//                                             .grey) // Biểu tượng cho trạng thái Pending
//                                     : Icon(Icons.public,
//                                         size: 16,
//                                         color: Colors
//                                             .green), // Biểu tượng cho trạng thái Public
//                               ],
//                             ),
//                             Text(
//                               formatDate(post['createdDate']!),
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         PopupMenuButton(
//                           onSelected: (value) {
//                             if (value == 'Edit') {
//                               // Edit page post
//                               // context.go("/home/edit-post");
//                               getPostById(post['postId']);
//                             } else if (value == 'Delete') {
//                               // Delete post
//                               DeletePostById(post['postId']);
//                             }
//                           },
//                           itemBuilder: (context) {
//                             return [
//                               const PopupMenuItem(
//                                 child: Text('Edit'),
//                                 value: 'Edit',
//                               ),
//                               const PopupMenuItem(
//                                 child: Text('Delete'),
//                                 value: 'Delete',
//                               ),
//                             ];
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Text(post['description']!),
//                     const SizedBox(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         text: 'Location: ',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: post['location'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         text: 'Schedule: ',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: post['schedule'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         text: 'Preferred Time: ',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: post['preferredTime'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         text: 'Gender: ',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: post['gender'] == 1 ? 'Male' : 'Female',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         text: 'Request Skill: ',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: post['requestSkill'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Divider(), // Separator line
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Row(
//                           children: [
//                             PopupMenuButton<String>(
//                               onSelected: (String selectedTutorId) {
//                                 // Implement action when a fullname is selected
//                                 final idpost =
//                                     post['postId']; // Lấy postId từ post
//                                 getTutorById(selectedTutorId,
//                                     idpost); // Gọi getTutorById với postId
//                                 // context.go('/home/view-tutor/$selectedTutorId');
//                               },
//                               itemBuilder: (BuildContext context) {
//                                 return post['applies']
//                                     .map<PopupMenuEntry<String>>((apply) {
//                                   return PopupMenuItem<String>(
//                                     value: apply['tutorId'],
//                                     child: Text(apply['fullname']),
//                                   );
//                                 }).toList();
//                               },
//                               icon: post['applies'].length > 0
//                                   ? Stack(
//                                       children: [
//                                         Icon(Icons.mail),
//                                         Positioned(
//                                           right: 0,
//                                           child: Container(
//                                             padding: EdgeInsets.all(1),
//                                             decoration: BoxDecoration(
//                                               color: Colors.red,
//                                               borderRadius:
//                                                   BorderRadius.circular(6),
//                                             ),
//                                             constraints: BoxConstraints(
//                                               minWidth: 12,
//                                               minHeight: 12,
//                                             ),
//                                             child: Text(
//                                               post['applies']
//                                                   .length
//                                                   .toString(), // Số lượng badge
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 8,
//                                               ),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   : Icon(Icons
//                                       .mail), // Hiển thị icon mặc định khi mảng rỗng
//                             ),
//                             Text("Apply"), // Label "Apply"
//                           ],
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Hành động khi nhấn nút
//           // Chuyển sang trang thêm post
//           context.go('/home/add-post');
//         },
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: CustomNavbar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:app/Component/app_bar.dart';
import 'package:app/Component/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List posts = [];
  List filteredPosts = [];
  String _sortStatus = 'all';
  int _selectedIndex = 0;
  String _searchQuery = '';
  String avatarUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4Y4d_9x8ebL0d0uGM776VrF1Ptwe7vyHDJA&s'; 


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(index);
    // Navigate to different pages based on the selected index
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/home/appointment');

        break;
      case 2:
        context.go('/home/user-profile');
        break;
    }
  }

  //Call api GET fetch data post request user login
  Future<void> FetchPostListUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    // const url = "https://10.0.2.2:7194/PostRequest/post-request-user-login";
    const url = "https://mytutorlink.arisavinh.dev/PostRequest/post-request-user-login";
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final dataPostList = jsonDecode(response.body);
      setState(() {
        posts = dataPostList.where((post) => post['status'] != 3).toList();
        filteredPosts = posts;
      });
      // print(posts);
    } else {}
  }

  Future<void> DeletePostById(id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    // final url = 'https://10.0.2.2:7194/PostRequest/post-request-postId/$id';
    final url = 'https://mytutorlink.arisavinh.dev/PostRequest/post-request-postId/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri, headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      // Show toast notification for successful deletion
      Fluttertoast.showToast(
        msg: "Delete post success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Fetch updated post list
      FetchPostListUserLogin();
    } else {
      // Show toast notification for failure
      Fluttertoast.showToast(
        msg: "Failed to delete post",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    print(response.body);
  }

  Future<void> getPostById(id) async {
    // final url = 'https://10.0.2.2:7194/PostRequest/post-request-id/$id';
    final url = 'https://mytutorlink.arisavinh.dev/PostRequest/post-request-id/$id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final postData = jsonDecode(response.body);
      // Navigate to the edit post page with the post data
      context.go('/home/edit-post', extra: postData);
    } else {
      // Handle error
      print('Failed to load post');
    }
  }

  Future<void> getTutorById(String id, String postId) async {
    // final url = 'https://10.0.2.2:7194/Tutor/tutor-by-id/$id';
    final url = 'https://mytutorlink.arisavinh.dev/Tutor/tutor-by-id/$id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final tutorData = jsonDecode(response.body);
      print(tutorData);
      //chuyển đến trong view tutor có params id
      context.go('/home/view-tutor/$id/$postId', extra: tutorData);
      //fetch dữ liệu lên trang
    } else {
      // Handle error
      print('Failed to load post');
    }
  }

  Future<void> GetUserById() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('userLogin');
    if (user != null) {
      final Map<String, dynamic> userMap = jsonDecode(user);
      final userId = userMap['userId'];
      // final url = 'https://10.0.2.2:7194/Account/get/$userId';
      final url = 'https://mytutorlink.arisavinh.dev/Account/get/$userId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final dataUserById = jsonDecode(response.body);
        setState(() {
          avatarUrl = dataUserById['avatarUrl'];
        });
        print(avatarUrl);
      } else {
        print(response.statusCode);
      }
    }
  }

  Future<void> _handleRefresh() async {
    // Gọi cả hai hàm khi người dùng thực hiện refresh
    await FetchPostListUserLogin();
    await GetUserById();
  }

  @override
  void initState() {
    super.initState();
    FetchPostListUserLogin();
    GetUserById();
  }

  //Format hiện thời gian post
  String formatDate(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    return formatter.format(parsedDate);
  }

  // void searchPosts(String query) {
  //   final results = posts.where((post) {
  //     final postDescription = post['description']?.toLowerCase() ?? '';
  //     final input = query.toLowerCase();
  //     return postDescription.contains(input);
  //   }).toList();
  //   setState(() {
  //     filteredPosts = results;
  //   });
  // }

  // void sortPosts(String status) {
  //   final statusValue = status == 'pending' ? 0 : 1;
  //   final results =
  //       posts.where((post) => post['status'] == statusValue).toList();
  //   setState(() {
  //     filteredPosts = results;
  //   });
  // }

  void searchPosts(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void sortPosts(String status) {
    setState(() {
      _sortStatus = status;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final results = posts.where((post) {
      final postDescription = post['description']?.toLowerCase() ?? '';
      final input = _searchQuery.toLowerCase();
      final matchesSearch = postDescription.contains(input);
      final matchesSort = _sortStatus == 'all' ||
          (_sortStatus == 'pending' && post['status'] == 0) ||
          (_sortStatus == 'public' && post['status'] == 1);

      return matchesSearch && matchesSort;
    }).toList();
    setState(() {
      filteredPosts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onSearch: searchPosts,
        onSort: sortPosts,
        avatarUrl: avatarUrl
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) {
            final post = filteredPosts[index];
            final id = post['postId'].toString();
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(post['avatarUrl'] ??
                              'https://via.placeholder.com/150'),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  post['createdByUsername'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                post['status'] == 0
                                    ? Icon(Icons.pending,
                                        size: 16,
                                        color: Colors
                                            .grey) // Biểu tượng cho trạng thái Pending
                                    : Icon(Icons.public,
                                        size: 16,
                                        color: Colors
                                            .green), // Biểu tượng cho trạng thái Public
                              ],
                            ),
                            Text(
                              formatDate(post['createdDate']!),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'Edit') {
                              // Edit page post
                              // context.go("/home/edit-post");
                              getPostById(post['postId']);
                            } else if (value == 'Delete') {
                              // Delete post
                              DeletePostById(post['postId']);
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                child: Text('Edit'),
                                value: 'Edit',
                              ),
                              const PopupMenuItem(
                                child: Text('Delete'),
                                value: 'Delete',
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(post['description']!),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: 'Location: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: post['location'],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: 'Schedule: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: post['schedule'],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: 'Preferred Time: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: post['preferredTime'],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: 'Gender: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: post['gender'] == 1 ? 'Male' : 'Female',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: 'Request Skill: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: post['requestSkill'],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Divider(), // Separator line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            PopupMenuButton<String>(
                              onSelected: (String selectedTutorId) {
                                // Implement action when a fullname is selected
                                final idpost =
                                    post['postId']; // Lấy postId từ post
                                getTutorById(selectedTutorId,
                                    idpost); // Gọi getTutorById với postId
                                // context.go('/home/view-tutor/$selectedTutorId');
                              },
                              itemBuilder: (BuildContext context) {
                                return post['applies']
                                    .map<PopupMenuEntry<String>>((apply) {
                                  return PopupMenuItem<String>(
                                    value: apply['tutorId'],
                                    child: Text(apply['fullname']),
                                  );
                                }).toList();
                              },
                              icon: post['applies'].length > 0
                                  ? Stack(
                                      children: [
                                        Icon(Icons.mail),
                                        Positioned(
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 12,
                                              minHeight: 12,
                                            ),
                                            child: Text(
                                              post['applies']
                                                  .length
                                                  .toString(), // Số lượng badge
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Icon(Icons
                                      .mail), // Hiển thị icon mặc định khi mảng rỗng
                            ),
                            Text("Apply"), // Label "Apply"
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Hành động khi nhấn nút
          // Chuyển sang trang thêm post
          context.go('/home/add-post');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
