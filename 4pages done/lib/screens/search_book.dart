
import 'package:flutter/material.dart';

class SearchBook extends StatelessWidget {
  const SearchBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for book'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20,),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search book',
                  prefixIcon: Icon(Icons.search)
                ),
              ),
              const SizedBox(height: 20,),
              searchCard(context),
              searchCard(context),
              searchCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchCard(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 100,
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
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
                  child: const Text('Homo Deus extra long', style: TextStyle(fontSize: 18),)),
              Container(
                  width: size.width / 1.5,
                  alignment: Alignment.centerLeft,
                  child: const Text('Whoever wrote this',style: TextStyle(color: Colors.grey),)),

            ],
          ),
          Container(
            height: 80,
            width: 50,
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
    );
  }
}
