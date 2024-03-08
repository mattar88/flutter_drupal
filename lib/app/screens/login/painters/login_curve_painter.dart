import 'package:flutter/cupertino.dart';

class LoginCurvePainter extends CustomPainter {
  Color colorFill;
  LoginCurvePainter(this.colorFill);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = colorFill;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(
        size.width / 2, size.height / 3, size.width, size.height * 0.15);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
