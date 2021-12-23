import 'package:flutter/material.dart';

class CustomLineWidget extends StatelessWidget {
  const CustomLineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.width * 0.25),
      painter: RPSCustomPainter(),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint()
      ..color = Colors.pink.shade200.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
     
         
    Path path1 = Path();
    path1.moveTo(size.width,size.height*0.7650000);
    path1.quadraticBezierTo(size.width*1.1075000,size.height*1.0013000,size.width,size.height);
    path1.lineTo(0,size.height);
    path1.quadraticBezierTo(size.width*0.4753250,size.height*0.9313000,size.width*0.5100000,size.height*0.8800000);
    path1.cubicTo(size.width*0.6653250,size.height*0.7825000,size.width*0.8822000,size.height*0.6825000,size.width,size.height*0.7650000);
    path1.close();

    canvas.drawPath(path1, paint1);

    Paint paint0 = Paint()
      ..color = Colors.pink.shade200
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    //+1- unexpected line under path 
    path0.moveTo(0, size.height+1);
    path0.lineTo(0, size.height * 0.7728000);
    path0.quadraticBezierTo(size.width * 0.0692250, size.height * 0.7026000,
        size.width * 0.1451000, size.height * 0.7808000);
    path0.cubicTo(
        size.width * 0.2255250,
        size.height * 0.8176000,
        size.width * 0.2737000,
        size.height * 1.0160000,
        size.width * 0.5274750,
        size.height * 0.9378000);
    path0.quadraticBezierTo(size.width * 0.8770000, size.height * 0.9310000,
        size.width, size.height+1);
    path0.lineTo(0, size.height+1);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
