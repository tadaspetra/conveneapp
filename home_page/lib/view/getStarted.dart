import 'package:demo/constats/constants.dart';
import 'package:demo/view/widgets/commonWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Robert!'),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: 15,
            ),
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width * .12,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(defaultProfileIcon),
                    fit: BoxFit.contain)),
          )
        ],
      ),
      body: body(context),
    );
  }

  Column body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .3,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(getStartedIcon), fit: BoxFit.contain)),
        ),
        Text(
          'Looks like you aren’t reading any books \n                         currently',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        appButton(
            buttonName: 'Start Journey', function: () {}, context: context)
      ],
    );
  }
}
