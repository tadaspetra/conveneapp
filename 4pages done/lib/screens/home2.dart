
import 'package:flutter/material.dart';

class Home2 extends StatelessWidget {
  const Home2({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        child: Container(

          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          child: Column(
            children:  <Widget>[
              const SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text('You are currently reading',
                style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: size.width,
                height: 100,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[100]
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            width: size.width / 1.5,
                          alignment: Alignment.centerLeft,
                            child: const Text('Homo Deus', style: TextStyle(fontSize: 18),)),
                        Container(
                            width: size.width / 1.5,
                            alignment: Alignment.centerLeft,
                            child: const Text('Youval Noah Harari',style: TextStyle(color: Colors.grey),)),

                        Stack(
                          children: <Widget>[
                            Container(
                              height: 10.0,
                              width: size.width / 1.5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0)
                              ),
                            ),
                            Container(
                              height: 10.0,
                              width: size.width / 2.5,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.0),

                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 80,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                          image: const DecorationImage(
                              image: AssetImage('assets/images/book_cover.png'),
                              fit: BoxFit.fill

                          )
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 60,),
              Container(
                  //width: size.width ,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text("Don't forget your clubs", style: TextStyle(fontSize: 18),)),
              Container(
                width: size.width,
                height: 100,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[100]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            width: size.width / 2,
                            alignment: Alignment.centerLeft,
                            child: const Text('The Boys', style: TextStyle(fontSize: 18),)),
                        Container(
                            width: size.width / 2,
                            alignment: Alignment.centerLeft,
                            child: const Text('Next meeting in 4 days',style: TextStyle(color: Colors.grey),)),
                        Container(
                            width: size.width / 2,
                            alignment: Alignment.centerLeft,
                            child: const Text('Fri, 17 Oct 2021',style: TextStyle(color: Colors.grey),)),

                      ],
                    ),
                    Container(
                      height: 80,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                          image: DecorationImage(
                              image: AssetImage('assets/images/group.jpg'),
                              fit: BoxFit.fill
                          )
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.black,
                  ),
                  SizedBox(width: 5,),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.grey,
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Container(
                //width: size.width ,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text("You may like these books", style: TextStyle(fontSize: 18),)),
              const SizedBox(height: 10,),
              Container(
                width: size.width,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10.0),
                height: 200,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      width: size.width - 20,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.orange,
                          image: DecorationImage(
                              image: AssetImage('assets/images/nature.jpg'),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                    Container(
                      width: size.width - 80,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.green,
                          image: DecorationImage(
                              image: AssetImage('assets/images/group1.jpg'),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                    Container(
                      width: size.width - 120,
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.blue,
                        image: DecorationImage(
                          image: AssetImage('assets/images/group.jpg'),
                          fit: BoxFit.fill
                        )
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){},
                child: const Text('New Journey',style: TextStyle(fontSize: 19),),
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(size.width / 1.3, 50 )),
                    backgroundColor: MaterialStateProperty.all(Colors.black)
                ),
              ),
              const SizedBox(height: 5.0,)
            ],
          ),
        ),
      ),
    );
  }
}
