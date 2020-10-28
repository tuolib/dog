import '../index.dart';
import 'dart:math';

class ChatCustomCorner extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool showCorner;
  final double radius;
  final Color topColor;
  final Color bottomColor;
  final double stops;
  final double stops2;

  ChatCustomCorner({
    @required this.color,
    this.alignment,
    this.showCorner = true,
    this.radius = 16.0,
    this.topColor,
    this.bottomColor,
    this.stops = 0,
    this.stops2 = 1,
  });

  // var _radius = 10.0;
  var _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    double _corner = 8.0;
    double _radius;
    Color _topColor;
    Color _bottomColor;
    if (topColor == null) {
      _topColor = color;
    } else {
      _topColor = topColor;
    }
    if (bottomColor == null) {
      _bottomColor = color;
    } else {
      _bottomColor = bottomColor;
    }
    if (radius > 28) {
      _radius = 28;
    } else {
      _radius = radius;
    }
    if (radius < _corner) {
      _corner = radius;
    }

    double nipSize = _x;
    if (alignment == Alignment.topRight) {
      var rect = Offset.zero & size;
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - 5,
            size.height,
            bottomRight: Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _topColor,
                _bottomColor,
              ],
              stops: [
                stops,
                stops2,
              ],
            ).createShader(rect)
            // ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      // path.moveTo(size.width - _x, size.height - 20);
      // path.lineTo(size.width - _x, size.height);
      // path.lineTo(size.width, size.height);

      path.moveTo(radius, 0);
      path.lineTo(size.width - radius - nipSize, 0);
      path.arcToPoint(Offset(size.width - nipSize, radius),
          radius: Radius.circular(radius));

      path.lineTo(size.width - nipSize, size.height - nipSize);

      // path.arcToPoint(Offset(size.width, size.height),
      //     radius: Radius.circular(nipSize), clockwise: false);
      path.arcToPoint(Offset(size.width, size.height),
          radius: Radius.circular(nipSize - 2), clockwise: false);

      // path.arcToPoint(Offset(size.width - 2 * nipSize, size.height - nipSize),
      //     radius: Radius.circular(2 * nipSize));
      path.arcToPoint(
          Offset(size.width - nipSize / 2, size.height - nipSize - 3),
          radius: Radius.circular(2 * nipSize));

      // path.arcToPoint(Offset(size.width - 4 * nipSize, size.height),
      //     radius: Radius.circular(2 * nipSize));
      path.arcToPoint(Offset(size.width - 3 * nipSize, size.height),
          radius: Radius.circular(2 * nipSize));

      path.lineTo(radius, size.height);
      path.arcToPoint(Offset(0, size.height - radius),
          radius: Radius.circular(radius));
      path.lineTo(0, radius);
      path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

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
              ..color = _bottomColor
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
            bottomLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      // path.moveTo(0, size.height);
      // path.lineTo(_x, size.height);
      // path.lineTo(_x, size.height - 20);

      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius),
          radius: Radius.circular(radius));

      path.lineTo(size.width, size.height - radius);

      path.arcToPoint(Offset(size.width - radius, size.height),
          radius: Radius.circular(radius));

      /// change
      // path.lineTo(4 * nipSize, size.height);
      path.lineTo(3 * nipSize, size.height);

      /// change
      // path.arcToPoint(Offset(2 * nipSize, size.height - nipSize),
      //     radius: Radius.circular(2 * nipSize));
      path.arcToPoint(Offset(nipSize / 2, size.height - nipSize - 3),
          radius: Radius.circular(2 * nipSize));

      path.arcToPoint(Offset(0, size.height),
          radius: Radius.circular(2 * nipSize));

      /// change
      // path.arcToPoint(Offset(nipSize, size.height - nipSize),
      //     radius: Radius.circular(nipSize), clockwise: false);
      path.arcToPoint(Offset(nipSize, size.height - nipSize),
          radius: Radius.circular(nipSize - 2), clockwise: false);

      path.lineTo(nipSize, radius);
      path.arcToPoint(Offset(radius + nipSize, 0),
          radius: Radius.circular(radius));

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

class UniqueColorGenerator {
  static Random random = new Random();

  static Color getColor() {
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}
