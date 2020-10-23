import 'package:flutter/material.dart';
import '../index.dart';
//
// class ColorFiltersDemo extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => ColorFilterDemoState();
// }
//
// class ColorFilterDemoState extends State<ColorFiltersDemo> {
//   int selectedBlendModeIndex = 0;
//
//   Map<String, BlendMode> blendModeMap = Map();
//
//   @override
//   void initState() {
//     super.initState();
//     blendModeMap.putIfAbsent("Normal", () => BlendMode.clear);
//     blendModeMap.putIfAbsent("Color Burn", () => BlendMode.colorBurn);
//     blendModeMap.putIfAbsent("Color Dodge", () => BlendMode.colorDodge);
//     blendModeMap.putIfAbsent("Saturation", () => BlendMode.saturation);
//     blendModeMap.putIfAbsent("Hue", () => BlendMode.hue);
//     blendModeMap.putIfAbsent("Soft light", () => BlendMode.softLight);
//     blendModeMap.putIfAbsent("Overlay", () => BlendMode.overlay);
//     blendModeMap.putIfAbsent("Multiply", () => BlendMode.multiply);
//     blendModeMap.putIfAbsent("Luminosity", () => BlendMode.luminosity);
//     blendModeMap.putIfAbsent("Plus", () => BlendMode.plus);
//     blendModeMap.putIfAbsent("Exclusion", () => BlendMode.exclusion);
//     blendModeMap.putIfAbsent("Hard Light", () => BlendMode.hardLight);
//     blendModeMap.putIfAbsent("Lighten", () => BlendMode.lighten);
//     blendModeMap.putIfAbsent("Screen", () => BlendMode.screen);
//     blendModeMap.putIfAbsent("Modulate", () => BlendMode.modulate);
//     blendModeMap.putIfAbsent("Difference", () => BlendMode.difference);
//     blendModeMap.putIfAbsent("Darken", () => BlendMode.darken);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Stack(
//           children: <Widget>[
//             // Image.asset(
//             //   "assets/cm0.jpeg",
//             //   height: double.maxFinite,
//             //   width: double.maxFinite,
//             //   fit: BoxFit.fitHeight,
//             //   color: selectedBlendModeIndex == 0 ? null : Colors.red,
//             //   colorBlendMode: selectedBlendModeIndex == 0
//             //       ? null
//             //       : blendModeMap.values.elementAt(selectedBlendModeIndex),
//             // ),
//             ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 Colors.red.withOpacity(0.2),
//                 BlendMode.screen,
//               ),
//               child: Container(
//                 height: double.maxFinite,
//                 width: double.maxFinite,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//
//             Positioned(
//               left: 0.0,
//               bottom: 0.0,
//               height: 100.0,
//               right: 0.0,
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//                 child: Center(
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: 20.0),
//                     height: 40.0,
//                     child: ListView.builder(
//                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: blendModeMap.keys.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           padding: EdgeInsets.all(4.0),
//                           child: ChoiceChip(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 0.0),
//                               labelStyle: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: (selectedBlendModeIndex == index)
//                                       ? 15.0
//                                       : 13.0,
//                                   fontWeight: (selectedBlendModeIndex == index)
//                                       ? FontWeight.bold
//                                       : FontWeight.normal),
//                               backgroundColor: Colors.black.withOpacity(0.8),
//                               selectedColor: Colors.blue,
//                               label: Center(
//                                 child: Text(blendModeMap.keys.elementAt(index)),
//                               ),
//                               selected: selectedBlendModeIndex == index,
//                               onSelected: (bool selected) {
//                                 setState(() {
//                                   selectedBlendModeIndex =
//                                   selected ? index : null;
//                                 });
//                               }),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ColorFiltersDemo extends StatelessWidget {
//   Color gradientStart = Colors.blue;
//   Color gradientEnd = Colors.red;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Stack(
//           children: <Widget>[
//             ShaderMask(
//               shaderCallback: (rect) {
//                 return LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [gradientStart, gradientEnd],
//                 ).createShader(Rect.fromLTRB(0, -140, rect.width, rect.height-20));
//               },
//               blendMode: BlendMode.screen,
//               child: Container(
//                 decoration: BoxDecoration(
//                   // gradient: LinearGradient(
//                   //   colors: [gradientStart, gradientEnd],
//                   //   begin: FractionalOffset(0, 0),
//                   //   end: FractionalOffset(0, 1),
//                   //   stops: [0.0, 1.0],
//                   //   tileMode: TileMode.clamp
//                   // ),
//                   color: Colors.black,
//                   // image: DecorationImage(
//                   //   image: ExactAssetImage('assets/cm0.jpeg'),
//                   //   fit: BoxFit.cover,
//                   // ),
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 Expanded(
//                   child: Container(
//                     child: Align(
//                       alignment: FractionalOffset(0.5, 0.0),
//                       child: Container(
//                         margin: EdgeInsets.only(top: 110.0),
//                         decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey[600],
//                               blurRadius:
//                               20.0, // has the effect of softening the shadow
//                               spreadRadius:
//                               0, // has the effect of extending the shadow
//                               // offset: Offset(
//                               //   10.0, // horizontal, move right 10
//                               //   10.0, // vertical, move down 10
//                               // ),
//                             )
//                           ],
//                         ),
//                         child: Image.asset('assets/cm1.jpeg',
//                             width: 70),
//                       ),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//                 Expanded(
//                   child: Container(
//                       margin: EdgeInsets.only(bottom: 10.0),
//                       child: Text(
//                         'Explore New Job Opportunities',
//                         style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                         textAlign: TextAlign.center,
//                       )),
//                   flex: 0,
//                 ),
//                 Expanded(
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: 28.0),
//                     child: Text(
//                       'We do all the best for your future endeavors by providing the connections you need during your job seeking process.',
//                       style: TextStyle(fontSize: 16.0, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 18.0),
//                     constraints: BoxConstraints(
//                       maxWidth: 330.0,
//                     ),
//                   ),
//                   flex: 0,
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white,),
//                     ),
//                     child: Text(
//                       'Sign Up',
//                       style: TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   // child: ButtonTheme(
//                   //   minWidth: 320.0,
//                   //   height: 50.0,
//                   //   child: RaisedButton(
//                   //     onPressed: () {},
//                   //     // textColor: Colors.blueAccent,
//                   //     // color: Colors.white,
//                   //     shape: RoundedRectangleBorder(
//                   //         borderRadius: BorderRadius.circular(10.0)
//                   //     ),
//                   //     child: Container(
//                   //       child: Text(
//                   //         'Sign Up',
//                   //         style: TextStyle(
//                   //             fontSize: 16, fontWeight: FontWeight.bold),
//                   //         textAlign: TextAlign.center,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   flex: 0,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: ButtonTheme(
//                       minWidth: 320.0,
//                       height: 50.0,
//                       child: Container(
//                         child: Text(
//                           'Continue with Google',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ),
//                   flex: 0,
//                 ),
//                 Expanded(
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: 20.0),
//                     child: ButtonTheme(
//                       minWidth: 200.0,
//                       height: 50.0,
//                       child: FlatButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/signup');
//                         },
//                         textColor: Colors.white,
//                         child: Container(
//                           child: Text(
//                             'Log In',
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   flex: 0,
//                 ),
//               ],
//             ),
//           ]
//       ),
//     );
//   }
// }

class ColorFiltersDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/cm0.jpeg'), fit: BoxFit.cover),
      ),
      child: Center(
        child: CustomPaint(
          painter: CutOutTextPainter(text: 'YOUR NAME'),
        ),
      ),
    );
  }
}

class CutOutTextPainter extends CustomPainter {
  CutOutTextPainter({this.text}) {
    _textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPainter.layout();
  }

  final String text;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the text in the middle of the canvas
    final textOffset = size.center(Offset.zero) - _textPainter.size.center(Offset.zero);
    final textRect = textOffset & _textPainter.size;

    // The box surrounding the text should be 10 pixels larger, with 4 pixels corner radius
    final boxRect = RRect.fromRectAndRadius(textRect.inflate(10.0), Radius.circular(4.0));
    final boxPaint = Paint()..color = Colors.white..blendMode=BlendMode.srcOut;

    canvas.saveLayer(boxRect.outerRect, Paint());

    _textPainter.paint(canvas, textOffset);
    canvas.drawRRect(boxRect, boxPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CutOutTextPainter oldDelegate) {
    return text != oldDelegate.text;
  }
}