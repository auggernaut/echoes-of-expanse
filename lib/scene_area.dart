import 'package:flutter/material.dart';
import 'adventure_data.dart';

class SceneArea extends StatefulWidget {
  final List<AdventureCard> selectedCards;

  const SceneArea({Key? key, required this.selectedCards}) : super(key: key);

  @override
  _SceneAreaState createState() => _SceneAreaState();
}

class _SceneAreaState extends State<SceneArea> {
  Map<AdventureCard, Offset> cardPositions = {};

  @override
  void initState() {
    super.initState();
    _initializeCardPositions();
  }

  @override
  void didUpdateWidget(SceneArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeCardPositions();
  }

  void _initializeCardPositions() {
    for (var card in widget.selectedCards) {
      if (!cardPositions.containsKey(card)) {
        cardPositions[card] = Offset.zero;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: widget.selectedCards.map((card) => _buildDraggableCard(card)).toList(),
      ),
    );
  }

  Widget _buildDraggableCard(AdventureCard card) {
    return Positioned(
      left: cardPositions[card]?.dx ?? 0,
      top: cardPositions[card]?.dy ?? 0,
      child: Draggable<AdventureCard>(
        data: card,
        feedback: _buildCardWidget(card),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: _buildCardWidget(card),
        ),
        onDragEnd: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.offset);
          setState(() {
            cardPositions[card] = localPosition;
          });
        },
        child: _buildCardWidget(card),
      ),
    );
  }

  Widget _buildCardWidget(AdventureCard card) {
    double width = 100;
    double height = 70;
    if (card.type.toLowerCase() == 'location') {
      width = 200;
      height = 140;
    }

    return CustomPaint(
      painter: CardPainter(cardType: card.type),
      child: SizedBox(
        width: width,
        height: height,
        child: ClipPath(
          clipper: CardShapeClipper(cardType: card.type),
          child: Image.asset(
            card.isFlipped ? card.backAsset : card.frontAsset,
            fit: BoxFit.cover,
            width: width,
            height: height * 2,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }
}

class CardPainter extends CustomPainter {
  final String cardType;

  CardPainter({required this.cardType});

  @override
  void paint(Canvas canvas, Size size) {
    final path = getCardPath(cardType, size);
    final shadow = Path()
      ..addPath(path, Offset(0, 4))
      ..addPath(path, Offset(0, 3))
      ..addPath(path, Offset(0, 2))
      ..addPath(path, Offset(0, 1));

    canvas.drawPath(
      shadow,
      Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Path getCardPath(String cardType, Size size) {
  final clipper = CardShapeClipper(cardType: cardType);
  return clipper.getClip(size);
}

class CardShapeClipper extends CustomClipper<Path> {
  final String cardType;

  CardShapeClipper({required this.cardType});

  @override
  Path getClip(Size size) {
    switch (cardType.toLowerCase()) {
      case 'location':
        return _getLocationPath(size);
      case 'threat':
        return _getThreatPath(size);
      case 'character':
        return _getCharacterPath(size);
      default:
        return _getLocationPath(size);
    }
  }

  Path _getLocationPath(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  Path _getThreatPath(Size size) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(10),
      ));
  }

  Path _getCharacterPath(Size size) {
    final path = Path();
    final diagonalCut = 15.0;

    path.moveTo(diagonalCut, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - diagonalCut, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Assuming you have this enum defined in your adventure_data.dart file
enum CardType { location, threat, character }
