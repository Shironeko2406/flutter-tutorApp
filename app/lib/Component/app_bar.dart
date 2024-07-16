// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final Function(String) onSearch;
//   final Function(String) onSort; // Thêm hàm onSort

//   CustomAppBar(
//       {this.onSearch = _defaultOnSearch,
//       this.onSort = _defaultOnSort,
//       Key? key})
//       : super(key: key);

//   static void _defaultOnSearch(String query) {
//     // Hàm trống mặc định
//   }

//   static void _defaultOnSort(String value) {
//     // Hàm trống mặc định
//   }

//   void logoutHandle(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('accessToken');
//     await prefs.remove('userLogin');

//     // Show toast notification at the top of the screen
//     Fluttertoast.showToast(
//       msg: "Logout success",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.TOP,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.black54,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );

//     // Navigate to login page
//     context.go('/login');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _searchController = TextEditingController();

//     return AppBar(
//       backgroundColor: Colors.blue,
//       title: const Text('Home'),
//       actions: [
//         Container(
//           width: 200, // Đặt chiều rộng tùy ý
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: TextField(
//             onChanged: onSearch,
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.search),
//               hintText: 'Search...',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: EdgeInsets.zero,
//               filled: true,
//               fillColor: Colors.white,
//             ),
//           ),
//         ),
//         PopupMenuButton<String>(
//           onSelected: (String value) {
//             // Hành động khi chọn một tùy chọn Sort
//             onSort(value);
//           },
//           itemBuilder: (BuildContext context) {
//             return [
//               PopupMenuItem<String>(
//                 value: 'all',
//                 child: Text('Show all'),
//               ),
//               PopupMenuItem<String>(
//                 value: 'pending',
//                 child: Text('Post is pending'),
//               ),
//               PopupMenuItem<String>(
//                 value: 'public',
//                 child: Text('Post was public'),
//               ),
//             ];
//           },
//           icon: Icon(Icons.sort),
//         ),
//         Padding(
//           padding:
//               const EdgeInsets.only(right: 16.0), // Thêm khoảng cách bên phải
//           child: InkWell(
//             onTap: () {
//               showMenu(
//                 context: context,
//                 position: const RelativeRect.fromLTRB(100, 100, 0, 0),
//                 items: [
//                   const PopupMenuItem(
//                     value: 'Profile',
//                     child: ListTile(
//                       leading: Icon(Icons.person),
//                       title: Text('Profile'),
//                     ),
//                   ),
//                   const PopupMenuItem(
//                     value: 'Logout',
//                     child: ListTile(
//                       leading: Icon(
//                         Icons.logout,
//                         color: Colors.red,
//                       ),
//                       title: Text(
//                         'Logout',
//                         style: TextStyle(
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ).then((value) {
//                 if (value != null) {
//                   if (value == 'Profile') {
//                     // Navigate to profile page
//                     print(value);
//                   } else if (value == 'Logout') {
//                     // Logout action
//                     logoutHandle(context);
//                   }
//                 }
//               });
//             },
//             child: const CircleAvatar(
//               backgroundImage: NetworkImage(
//                 'https://i.pinimg.com/736x/95/e8/6b/95e86bcc378d6f9b32480833f73c485b.jpg',
//               ),
//               radius: 20.0,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onSearch;
  final Function(String) onSort; // Thêm hàm onSort
  final String avatarUrl;

  CustomAppBar(
      {this.onSearch = _defaultOnSearch,
      this.onSort = _defaultOnSort,
      required this.avatarUrl,
      Key? key})
      : super(key: key);

  static void _defaultOnSearch(String query) {
    // Hàm trống mặc định
  }

  static void _defaultOnSort(String value) {
    // Hàm trống mặc định
  }

  void logoutHandle(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userLogin');

    // Show toast notification at the top of the screen
    Fluttertoast.showToast(
      msg: "Logout success",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Navigate to login page
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text('Home'),
      actions: [
        Container(
          width: 200, // Đặt chiều rộng tùy ý
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (String value) {
            // Hành động khi chọn một tùy chọn Sort
            onSort(value);
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'all',
                child: Text('Show all'),
              ),
              PopupMenuItem<String>(
                value: 'pending',
                child: Text('Post is pending'),
              ),
              PopupMenuItem<String>(
                value: 'public',
                child: Text('Post was public'),
              ),
            ];
          },
          icon: Icon(Icons.sort),
        ),
        Padding(
          padding:
              const EdgeInsets.only(right: 16.0), // Thêm khoảng cách bên phải
          child: InkWell(
            onTap: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  const PopupMenuItem(
                    value: 'Profile',
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Logout',
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  if (value == 'Profile') {
                    // Navigate to profile page
                    context.go('/home/user-profile');
                    print(value);
                  } else if (value == 'Logout') {
                    // Logout action
                    logoutHandle(context);
                  }
                }
              });
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                avatarUrl ?? 'https://i.pinimg.com/736x/95/e8/6b/95e86bcc378d6f9b32480833f73c485b.jpg',
              ),
              radius: 20.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
