 import 'package:flutter/material.dart';

appButton({required String buttonName, required void Function() function ,required BuildContext context}) =>
      Container(
           margin: EdgeInsets.only(left: 40, right: 40),
            // color: Colors.black,
            height: MediaQuery.of(context).size.height * .08,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(
                  10,
                )),
        child: TextButton(
          child: Text(
            '$buttonName',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          onPressed: function,
        ),
      );