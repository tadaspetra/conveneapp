
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateClub extends StatelessWidget {
  const CreateClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Create a club'),
        actions:const <Widget>[

          CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.person),
          ),
          SizedBox(width: 10,),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30.0,),
            SizedBox(
                width: size.width,
                height: 280,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: size.width,
                      height: 200,
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                      ),
                      child: SvgPicture.asset('assets/images/1.svg'),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('When is this book due?',
                          style: TextStyle(
                              fontSize: 20
                          ),)
                    ),
                  ],
                )

            ),
            const SizedBox(height: 50.0,),
            ElevatedButton(
              onPressed: (){},
              child: const Text('June 12, 2021',style: TextStyle(fontSize: 19),),
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(size.width / 1.3, 50 )),
                  backgroundColor: MaterialStateProperty.all(Colors.black)
              ),
            ),
            const SizedBox(height: 10.0,),
            ElevatedButton(
              onPressed: (){},
              child: const Text('7:00 PM',style: TextStyle(fontSize: 19),),
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
