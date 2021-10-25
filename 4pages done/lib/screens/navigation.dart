
import 'package:assignment/screens/screens.dart';
import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Task'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home1()));
              },
              child: const Text('Screen 1',style: TextStyle(fontSize: 19),),
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(size.width / 1.3, 50 )),
                  backgroundColor: MaterialStateProperty.all(Colors.black)
              ),

            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home2()));
              },
              child: const Text('Screen 2',style: TextStyle(fontSize: 19),),
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(size.width / 1.3, 50 )),
                  backgroundColor: MaterialStateProperty.all(Colors.black)
              ),

            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBook()));
              },
              child: const Text('Screen 3',style: TextStyle(fontSize: 19),),
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(size.width / 1.3, 50 )),
                  backgroundColor: MaterialStateProperty.all(Colors.black)
              ),

            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateClub()));
              },
              child: const Text('Screen 4',style: TextStyle(fontSize: 19),),
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(size.width / 1.3, 50 )),
                  backgroundColor: MaterialStateProperty.all(Colors.black)
              ),

            ),
          ],
        ),
      ),
    );
  }
}
