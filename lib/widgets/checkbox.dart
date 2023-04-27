import 'package:flutter/material.dart';

class CheckboxText extends StatefulWidget {
  final String checkboxText;
  List checkboxValues;
  CheckboxText(this.checkboxText, this.checkboxValues, {super.key});

  @override
  State<CheckboxText> createState() => _CheckboxTextState(checkboxText, checkboxValues);
}

class _CheckboxTextState extends State<CheckboxText> {
  bool? isChecked=false;
  final String checkboxText;
  List checkboxValues;
  _CheckboxTextState(this.checkboxText, this.checkboxValues);
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(checkboxText, style: const TextStyle(fontSize: 16.0),),
      value: isChecked,
      activeColor: const Color.fromRGBO(162, 183, 155, 1),
      onChanged: (bool? newValue) {
        setState(() {
          isChecked=newValue;
          for(int i=0; i<checkboxValues.length;i++){
            if(checkboxText==checkboxValues[i][0]){
              if (newValue==true) {
                checkboxValues[i][1]=true;
              }
              if (newValue==false) {
                checkboxValues[i][1]=false;
              }
            }
          }
        });
      },
    );
  }
}
