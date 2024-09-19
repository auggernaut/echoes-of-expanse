import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:echoes_of_expanse/player/character_data.dart';

class CardsPaginatedCarousel extends StatefulWidget {
  final List<CharacterCard> cards;
  final Function(int) onPageChanged;
  final Function(CharacterCard) onCardTap;

  const CardsPaginatedCarousel({
    super.key,
    required this.cards,
    required this.onPageChanged,
    required this.onCardTap,
  });

  @override
  CardsPaginatedCarouselState createState() => CardsPaginatedCarouselState();
}

class CardsPaginatedCarouselState extends State<CardsPaginatedCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  // Original card dimensions and aspect ratio
  final double originalCardWidth = 748.0;
  final double originalCardHeight = 1044.0;
  late final double aspectRatio;

  Set<int> _borderedCards = {};

  @override
  void initState() {
    super.initState();
    aspectRatio = originalCardWidth / originalCardHeight;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _flipCurrentCard() {
    setState(() {
      widget.cards[_currentPage].flip();
    });
  }

  void _toggleBorder(int index) {
    setState(() {
      if (_borderedCards.contains(index)) {
        _borderedCards.remove(index);
      } else {
        _borderedCards.add(index);
      }
    });

    // Add a short delay before calling onCardTap
    Future.delayed(Duration(milliseconds: 500), () {
      widget.onCardTap(widget.cards[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _pageController.previousPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else if (event.logicalKey == LogicalKeyboardKey.space) {
            _toggleBorder(_currentPage);
          }
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Fixed card height (adjust this value as needed)
          double cardHeight = constraints.maxHeight * 0.8;
          double cardWidth = cardHeight * aspectRatio;

          // Ensure card width doesn't exceed screen width
          if (cardWidth > constraints.maxWidth * 0.8) {
            cardWidth = constraints.maxWidth * 0.8;
            cardHeight = cardWidth / aspectRatio;
          }

          final viewportFraction = cardWidth / constraints.maxWidth;
          _pageController = PageController(
            viewportFraction: viewportFraction,
            initialPage: _currentPage,
          );

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.cards.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  widget.onPageChanged(index);
                },
                itemBuilder: (context, index) {
                  bool isCenter = index == _currentPage;
                  double scale = isCenter ? 1.0 : 0.8;

                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: scale, end: scale),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Center(
                          child: Container(
                            width: cardWidth,
                            height: cardHeight,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Card(
                                    elevation: isCenter ? 8 : 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                          image: AssetImage(widget.cards[index].frontAsset),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (_borderedCards.contains(index))
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green, width: 2),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () => _toggleBorder(index),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () =>
                        _goToPage((_currentPage - 1 + widget.cards.length) % widget.cards.length),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () => _goToPage((_currentPage + 1) % widget.cards.length),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
