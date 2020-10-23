import '../index.dart';

class TestGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF282a57), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.menu,color: Colors.white,),
                    Spacer(),
                    Text("Expense",style: TextStyle(color: Colors.white,fontSize: 18,)),
                    Spacer(),
                    Icon(Icons.clear, color: Colors.white,)
                  ],
                ),
              ),
            ),
          ],
        ),
      )
      // Scaffold(
      //   body: SingleChildScrollView(
      //     child: Container(
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: Alignment.topCenter,
      //           end: FractionalOffset.bottomCenter,
      //           colors: [Colors.green, Colors.orange],
      //           stops: [0, 1],
      //         ),
      //       ),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: List.generate(500, (ind) {
      //           return ListTile(
      //             title: Text('$ind'),
      //           );
      //         }).toList(),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}