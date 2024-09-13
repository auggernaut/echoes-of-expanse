import 'package:echoes_of_expanse/character_data.dart';
import 'package:flutter/material.dart';

class MasonryGridScreen extends StatefulWidget {
  final List<CharacterCard> cards;
  final Function(List<CharacterCard>) onSubmit;

  MasonryGridScreen({required this.cards, required this.onSubmit});

  @override
  _MasonryGridScreenState createState() => _MasonryGridScreenState();
}

class _MasonryGridScreenState extends State<MasonryGridScreen> {
  late int remainingCoins;
  List<CharacterCard> selectedCards = [];

  @override
  void initState() {
    super.initState();
    remainingCoins = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text('Spend $remainingCoins coins.'), automaticallyImplyLeading: false),
        body: CustomScrollView(slivers: [
          _buildSection(
              'Recommended', widget.cards.where((card) => card.type == 'recommended').toList()),
          _buildSection(
              'Equipment', widget.cards.where((card) => card.type == 'equipment').toList()),
          _buildSection('Skills', widget.cards.where((card) => card.type == 'skill').toList()),
          _buildSubmitButton()
        ]));
  }

  Widget _buildSection(String title, List<CharacterCard> cards) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            _buildSectionTitle(title),
            _buildMasonryGrid(cards),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMasonryGrid(List<CharacterCard> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        const cardWidth = 300.0; // Adjust to fit 2 columns with padding
        final crossAxisCount = (screenWidth / cardWidth).floor();

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(), // Prevent the grid from scrolling independently
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 748 / 1044, // Aspect ratio of the card images
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return _buildCardItem(cards[index]);
          },
        );
      },
    );
  }

  Widget _buildCardItem(CharacterCard card) {
    bool isSelected = selectedCards.contains(card);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCards.remove(card);
            remainingCoins += card.coin;
            print('Removed: ${card.coin}, Remaining Coins: $remainingCoins');
          } else if (remainingCoins >= card.coin) {
            selectedCards.add(card);
            remainingCoins -= card.coin;
            print('Added: ${card.coin}, Remaining Coins: $remainingCoins');
          }
        });
      },
      child: Opacity(
          opacity: isSelected ? 0.5 : 1.0,
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.0)),
              color: isSelected ? Colors.green.withOpacity(0.5) : Colors.white,
              image: DecorationImage(
                image: AssetImage(card.frontAsset),
                fit: BoxFit.cover,
              ),
            ),
          )),
    );
  }

  Widget _buildSubmitButton() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: selectedCards.isNotEmpty
              ? () {
                  // Perform submission logic here
                  print('Submitted: ${selectedCards.length} cards');
                  widget.onSubmit(selectedCards);
                }
              : null,
          child: Text('Submit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Background color
            foregroundColor: Colors.white, // Text color
          ),
        ),
      ),
    );
  }
}
