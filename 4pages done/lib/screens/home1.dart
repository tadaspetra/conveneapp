
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home1 extends StatelessWidget {
  const Home1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Hi, Robert!'),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: 10.0,),
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
                    child: SvgPicture.asset('assets/images/login.svg'),
                  ),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Looks like you are not reading any books currently',
                        style: TextStyle(
                            fontSize: 20
                        ),)
                  ),
                ],
              )

            ),
            const SizedBox(height: 10.0,),
            ElevatedButton(
                onPressed: (){},
                child: const Text('Start Journey',style: TextStyle(fontSize: 19),),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(size.width / 1.3, 50 )),
                backgroundColor: MaterialStateProperty.all(Colors.black)
              ),
            ),
            const SizedBox(height: 5.0,)
          ],
        ),
      ),
    );
  }
}
