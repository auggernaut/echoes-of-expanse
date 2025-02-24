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
  final FocusNode _focusNode = FocusNode();

  // Original card dimensions and aspect ratio
  final double originalCardWidth = 406.0;
  final double originalCardHeight = 716.0;
  late final double aspectRatio;

  List<GlobalKey<FlipCardState>> cardKeys = [];

  @override
  void initState() {
    super.initState();
    aspectRatio = originalCardWidth / originalCardHeight;
    _pageController = PageController(viewportFraction: 0.4);
    cardKeys = List.generate(
      widget.cards.length,
      (_) => GlobalKey<FlipCardState>(),
    );
    _focusNode.requestFocus();
  }

  @override
  void didUpdateWidget(PaginatedCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cards.length != oldWidget.cards.length) {
      cardKeys = List.generate(
        widget.cards.length,
        (_) => GlobalKey<FlipCardState>(),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page >= 0 && page < widget.cards.length) {
      _pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _flipCurrentCard() {
    if (_currentPage >= 0 && _currentPage < cardKeys.length) {
      cardKeys[_currentPage].currentState?.toggleCard();
      widget.onCardTap(widget.cards[_currentPage]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            _flipCurrentCard();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _pageController.previousPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          _flipCurrentCard();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            double cardHeight = constraints.maxHeight * 0.8;
            double cardWidth = cardHeight * aspectRatio;

            if (cardWidth > constraints.maxWidth * 0.8) {
              cardWidth = constraints.maxWidth * 0.8;
              cardHeight = cardWidth / aspectRatio;
            }

            final viewportFraction = cardWidth / constraints.maxWidth;

            _pageController =
                PageController(viewportFraction: viewportFraction); // Use calculated fraction

            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.cards.length,
                  // viewportFraction: 0.85,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    widget.onPageChanged(index);
                  },
                  itemBuilder: (context, index) {
                    if (index >= widget.cards.length) {
                      return SizedBox.shrink();
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
                                key: cardKeys[index],
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
      ),
    );
  }
}
