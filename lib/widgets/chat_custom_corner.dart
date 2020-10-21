import '../index.dart';

class ChatCustomCorner extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool showCorner;
  final double radius;

  ChatCustomCorner({
    @required this.color,
    this.alignment,
    this.showCorner = true,
    this.radius = 16.0,
  });

  // var _radius = 10.0;
  var _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    double _corner = 8.0;
    double _radius;
    if (radius > 28) {
      _radius = 28;
    } else {
      _radius = radius;
    }
    if (radius < _corner) {
      _corner = radius;
    }
    if (alignment == Alignment.topRight) {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - 5,
            size.height,
            bottomRight: Radius.circular(_corner),
            bottomLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      path.moveTo(size.width - _x, size.height - 20);
      path.lineTo(size.width - _x, size.height);
      path.lineTo(size.width, size.height);
      canvas.clipPath(path);
      if (showCorner) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              size.width - _x,
              0.0,
              size.width,
              size.height,
              topRight: Radius.circular(_radius),
            ),
            Paint()
              ..color = this.color
              ..style = PaintingStyle.fill);
      }
    } else {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            _x - 5,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            bottomLeft: Radius.circular(_corner),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      path.moveTo(0, size.height);
      path.lineTo(_x, size.height);
      path.lineTo(_x, size.height - 20);
      canvas.clipPath(path);
      if (showCorner) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0.0,
              _x,
              size.height,
              topRight: Radius.circular(_radius),
            ),
            Paint()
              ..color = this.color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
