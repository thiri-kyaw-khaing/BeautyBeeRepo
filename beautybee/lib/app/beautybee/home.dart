import 'package:beautybee/app/beautybee/List_Screen.dart';
import 'package:beautybee/app/beautybee/Profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex=0;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final Screens =[
      const ListScreen(),
      // const Items(),
      const Profile()
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFC1CC),
        leading: ClipOval(child: Image.asset("assets/images/logo.png"),),
        title: Text("BeautyBee",),),
      body: Screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor:Colors.pinkAccent ,
          backgroundColor: Color(0xFFFFC1CC),
          items: const[
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag),label: 'List'),
        // BottomNavigationBarItem(icon: Icon(Icons.shopping_bag),label:'Items'),
        BottomNavigationBarItem(icon: Icon(Icons.person),label:'Profile')
      ]),
    );
  }
}
