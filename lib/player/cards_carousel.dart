import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:echoes_of_expanse/player/character_data.dart';

class CardsCarousel extends StatefulWidget {
  final List<CharacterCard> cards;
  final Function onCarouselChange;
  final Function onCardTap;
  final String cardTapBehavior;

  const CardsCarousel(
      {super.key,
      required this.cards,
      required this.onCarouselChange,
      required this.onCardTap,
      this.cardTapBehavior = 'flip'});

  @override
  _CardsCarouselState createState() => _CardsCarouselState();
}

class _CardsCarouselState extends State<CardsCarousel> {
  late FocusNode _focusNode;
  late SwiperController _swiperController;
  Map<int, bool> dimmedCards = {};

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _swiperController = SwiperController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double viewportFraction = screenWidth < 600 ? 0.8 : 0.5;

    return Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent) {
            // debugPrint('Key event: ${event.runtimeType}, ${event.logicalKey}');
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _swiperController.next(animation: true);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _swiperController.previous(animation: true);
            }
          }
          return KeyEventResult.handled;
        },
        child: Swiper(
            controller: _swiperController,
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                color: Colors.grey[
                    300]!, // Light grey color for inactive dots. The `!` asserts the value is non-null.
                activeColor: Colors.black, // Black color for the active dot
                size: 7.0, // Dot size
                activeSize: 10.0, // Active dot size
              ),
            ),
            onIndexChanged: (int index) {
              widget.onCarouselChange(index);
            },
            itemBuilder: (BuildContext context, int index) {
              return widget.cardTapBehavior == 'flip'
                  ? _buildFlipCard(widget.cards[index])
                  : _buildDimmableCard(widget.cards[index], index);
            },
            itemCount: widget.cards.length,
            // pagination: const SwiperPagination(),
            control: const SwiperControl(),
            viewportFraction: viewportFraction,
            scale: 0.8,
            scrollDirection: Axis.horizontal,
            indicatorLayout: PageIndicatorLayout.SCALE,
            // layout: SwiperLayout.CUSTOM,
            // customLayoutOption: CustomLayoutOption(startIndex: -1, stateCount: 3)
            //   ..addRotate([-45.0 / 180, 0.0, 45.0 / 180])
            //   ..addTranslate([Offset(-370.0, -40.0), Offset(0.0, 0.0), Offset(370.0, -40.0)]),
            loop: false));
  }

  Widget _buildFlipCard(CharacterCard card) {
    double screenWidth = MediaQuery.of(context).size.width;
    BoxFit fit = screenWidth < 600 ? BoxFit.fitWidth : BoxFit.fitHeight;
    return FlipCard(
      onFlip: () => widget.onCardTap(card),
      direction: FlipDirection.HORIZONTAL,
      side: CardSide.FRONT,
      front: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(card.frontAsset),
            fit: fit,
          ),
        ),
      ),
      back: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(card.backAsset),
            fit: fit,
          ),
        ),
      ),
    );
  }

  Widget _buildDimmableCard(CharacterCard card, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    BoxFit fit = screenWidth < 600 ? BoxFit.fitWidth : BoxFit.fitHeight;
    final card = widget.cards[index];
    bool isDimmed = dimmedCards[index] ?? false;

    return GestureDetector(
        onTap: () {
          widget.onCardTap(card);
          setState(() {
            dimmedCards[index] = !isDimmed;
          });
        },
        child: Opacity(
            opacity: isDimmed ? 0.5 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(card.frontAsset),
                  fit: fit,
                ),
              ),
            )));
  }
}
