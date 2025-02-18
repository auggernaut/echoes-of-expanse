import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:echoes_of_expanse/player/character_data.dart';

class CardSection {
  final String title;
  final List<CharacterCard> cards;
  final Color color;

  CardSection({required this.title, required this.cards, required this.color});
}

class SectionCardSelectionScreen extends StatefulWidget {
  final String title;
  final List<CardSection> sections;
  final List<CharacterCard> selectedCards;
  final int maxCoins;
  final Function(List<CharacterCard>) onSubmit;

  SectionCardSelectionScreen({
    Key? key,
    required this.title,
    required this.sections,
    required this.selectedCards,
    required this.maxCoins,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _SectionCardSelectionScreenState createState() => _SectionCardSelectionScreenState();
}

class _SectionCardSelectionScreenState extends State<SectionCardSelectionScreen> {
  List<CharacterCard> selectedCards = [];
  int remainingCoins = 0;
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  final FocusNode _focusNode = FocusNode();
  final double originalCardWidth = 748.0;
  final double originalCardHeight = 1044.0;
  late final double aspectRatio;

  @override
  void initState() {
    super.initState();
    aspectRatio = originalCardWidth / originalCardHeight;
    selectedCards = List.from(widget.selectedCards);
    remainingCoins = widget.maxCoins - selectedCards.fold(0, (sum, card) => sum + card.coin);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _scrollToPrevious();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _scrollToNext();
      }
    }
  }

  void _scrollToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _scrollToIndex(_currentIndex);
    }
  }

  void _scrollToNext() {
    if (_currentIndex < widget.sections.expand((s) => s.cards).length - 1) {
      setState(() {
        _currentIndex++;
      });
      _scrollToIndex(_currentIndex);
    }
  }

  void _scrollToIndex(int index) {
    final itemWidth = 300.0 + 32.0; // Card width + horizontal padding
    _scrollController.animateTo(
      index * itemWidth,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} - Coins: $remainingCoins'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: (KeyEvent event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                    _scrollToPrevious();
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                    _scrollToNext();
                  }
                }
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 450, // Approximate height of a card plus its text
                      child: ListView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        children: widget.sections
                            .expand((section) => [
                                  Container(
                                    width: 60,
                                    color: section.color,
                                    child: Center(
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                          section.title,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...section.cards.map((card) => Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: _buildCardItem(card, section.color),
                                      )),
                                ])
                            .toList(),
                      ),
                    ),
                  ),
                  if (MediaQuery.of(context).size.width >= 600) ...[
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildScrollPaddle(Icons.arrow_back, _scrollToPrevious),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _buildScrollPaddle(Icons.arrow_forward, _scrollToNext),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildScrollPaddle(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCardItem(CharacterCard card, Color sectionColor) {
    bool isSelected =
        selectedCards.any((selectedCard) => selectedCard.frontAsset == card.frontAsset);

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardHeight = 450.0; // Match your container height
        double cardWidth = cardHeight * aspectRatio;

        return GestureDetector(
          onTap: () => _toggleCardSelection(card),
          child: Center(
            child: Container(
              width: cardWidth,
              height: cardHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(card.frontAsset),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
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
                        onTap: () => _toggleCardSelection(card),
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
  }

  void _toggleCardSelection(CharacterCard card) {
    setState(() {
      bool isSelected = selectedCards.any((c) => c.frontAsset == card.frontAsset);

      if (isSelected) {
        selectedCards.removeWhere((c) => c.frontAsset == card.frontAsset);
        remainingCoins += card.coin;
      } else if (remainingCoins >= card.coin) {
        selectedCards.add(card);
        remainingCoins -= card.coin;
      }
    });
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: selectedCards.isNotEmpty ? () => widget.onSubmit(selectedCards) : null,
        child: Text('Submit'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
