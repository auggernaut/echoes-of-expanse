import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flip_card/flip_card.dart'; // Add this import
import 'adventure_data.dart';

class PaginatedCarousel extends StatefulWidget {
  final List<AdventureCard> cards;
  final Function(int) onPageChanged;
  final Function(AdventureCard) onCardTap;

  const PaginatedCarousel({
    Key? key,
    required this.cards,
    required this.onPageChanged,
    required this.onCardTap,
  }) : super(key: key);

  @override
  _PaginatedCarouselState createState() => _PaginatedCarouselState();
}

class _PaginatedCarouselState extends State<PaginatedCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  // Original card dimensions and aspect ratio
  final double originalCardWidth = 406.0;
  final double originalCardHeight = 716.0;
  late final double aspectRatio;

  List<GlobalKey<FlipCardState>> cardKeys = [];

  @override
  void initState() {
    super.initState();
    aspectRatio = originalCardWidth / originalCardHeight;
    _pageController = PageController();
    cardKeys = List.generate(
      widget.cards.length,
      (_) => GlobalKey<FlipCardState>(),
    );
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
    cardKeys[_currentPage].currentState?.toggleCard();
    widget.onCardTap(widget.cards[_currentPage]);
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
            _flipCurrentCard();
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
                  // Add this check to ensure we don't access out-of-range indices
                  if (index >= widget.cards.length) {
                    return SizedBox.shrink(); // Return an empty widget if index is out of range
                  }

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
                          child: SizedBox(
                            width: cardWidth,
                            height: cardHeight,
                            child: FlipCard(
                              key: ValueKey('card_$index'),
                              onFlip: () => widget.onCardTap(widget.cards[index]),
                              direction: FlipDirection.HORIZONTAL,
                              side: CardSide.FRONT,
                              front: Card(
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
                              back: Card(
                                elevation: isCenter ? 8 : 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: AssetImage(widget.cards[index].backAsset),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
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
