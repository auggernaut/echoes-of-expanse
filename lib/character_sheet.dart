import 'package:echoes_of_expanse/data.dart';
import 'package:echoes_of_expanse/treasure_list.dart';
import 'package:flutter/material.dart';

class CharacterSheet extends StatefulWidget {
  final Hand hand;

  CharacterSheet({required this.hand});

  @override
  _CharacterSheetState createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  Map<String, dynamic> characterStats = {};
  int totalWeight = 0;

  @override
  void initState() {
    super.initState();
    widget.hand.loadCards().then((stats) {
      setState(() {
        characterStats = stats;
      });
    });
    _updateTotalWeight();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Class fields
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        label: 'Name',
                        key: 'characterName',
                        value: characterStats['characterName'] ?? '',
                        hintText: 'Your Name')),
                SizedBox(
                  width: 50,
                  child: Center(child: Text('the')),
                ),
                Expanded(
                    child: _buildLabelWithLineAndText(
                        label: 'Class', value: characterStats['class'] ?? '')),
              ],
            ),
            SizedBox(height: 10),

            // Drive, Ancestry, Background fields
            Row(
              children: [
                Expanded(
                    child: _buildLabelWithLineAndText(
                        label: 'Drive', value: characterStats['drive'] ?? '')),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildLabelWithLineAndText(
                        label: 'Ancestry', value: characterStats['ancestry'] ?? '')),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildLabelWithLineAndText(
                        label: 'Background', value: characterStats['background'] ?? '')),
              ],
            ),
            SizedBox(height: 10),

            // Mission and Counterpart Name fields
            Row(
              children: [
                Expanded(
                    child: _buildLabelWithLineAndText(
                        label: 'Bond', value: characterStats['bond'] ?? '')),
                const SizedBox(
                  width: 50,
                  child: Center(child: Text('with')),
                ),
                Expanded(
                    child: _buildTextField(
                        label: 'Name',
                        key: 'bondName',
                        value: characterStats['bondName'] ?? '',
                        hintText: 'Character Name')),
              ],
            ),
            const SizedBox(height: 20),

            // Bottom icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconLabel(Icons.favorite, 'Health', characterStats['health'] ?? 0),
                _buildIconLabel(Icons.circle, 'Coin', characterStats['coin'] ?? 0),
                _buildIconLabelFraction(
                    Icons.fitness_center, 'Weight', totalWeight, characterStats['maxWeight'] ?? 0),
                _buildIconLabel(Icons.shield, 'Armor', characterStats['armor'] ?? 0),
              ],
            ),

            const SizedBox(height: 20),

            // Stats sections
            _buildStatSection(
                'Power',
                'Power through or test your might.\nLeap, throttle, destroy, dodge.',
                'Weak',
                characterStats['power'].toString()),
            _buildStatSection(
                'Smarts',
                'Think through or rely on senses.\nOutwit, investigate, decipher.',
                'Confused',
                characterStats['smarts'].toString()),
            _buildStatSection(
                'Charm',
                'Charm, bluff, impress, or fit in.\nSeduce or compel someone.',
                'Scarred',
                characterStats['charm'].toString()),
            _buildStatSection('Grit', 'Endure or hold steady.\nDefend or protect others.', 'Sick',
                characterStats['grit'].toString()),
            TreasureList(hand: widget.hand, onUpdate: _updateTotalWeight),
            SizedBox(height: 50.0)
          ],
        ),
      ),
    );
  }

  void _updateTotalWeight() {
    int characterWeight = widget.hand.characterStats['weight'];
    int treasureWeight = widget.hand.treasureItems.fold(0, (sum, item) => sum + item.weight);
    setState(() {
      totalWeight = characterWeight + treasureWeight;
    });
  }

  Widget _buildTextField(
      {required String label,
      required String key,
      required String value,
      required String hintText}) {
    final TextEditingController controller = TextEditingController(text: value);

    controller.addListener(() {
      widget.hand.updateStat(key, controller.text);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8), // Space between label and line
        TextField(
          style: Theme.of(context).textTheme.bodyLarge,
          controller: controller,
          decoration: InputDecoration(
            // border: OutlineInputBorder(),
            // hintText: hintText,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
        Container(
          height: 1,
          color: Colors.black,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8), // Space below the line
      ],
    );
  }

  Widget _buildLabelWithLineAndText({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8), // Space between label and line
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Container(
          height: 1,
          color: Colors.black.withOpacity(0.5),
        ),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 12)),
        const SizedBox(height: 8), // Space below the line
      ],
    );
  }

  Widget _buildStatSection(String title, String description, String condition, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -5), // Move the text up by 3 pixels
                child: Text(
                  value,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(description),
                // Row(
                //   children: [
                //     Checkbox(
                //       value: false,
                //       onChanged: (bool? newValue) {
                //         setState(() {
                //           widget.hand.updateStat('condition', newValue);
                //         });
                //       },
                //     ),
                //     Text(condition),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _incrementStat(String label) {
    String lowercaseLabel = label.toLowerCase();
    setState(() {
      characterStats[lowercaseLabel] = (characterStats[lowercaseLabel] ?? 0) + 1;
      widget.hand.updateStat(lowercaseLabel, characterStats[lowercaseLabel]!);
    });
  }

  void _decrementStat(String label) {
    String lowercaseLabel = label.toLowerCase();
    setState(() {
      characterStats[lowercaseLabel] = (characterStats[lowercaseLabel] ?? 0) - 1;
      widget.hand.updateStat(lowercaseLabel, characterStats[lowercaseLabel]!);
    });
  }

  Widget _buildIconLabel(IconData icon, String label, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 45, color: Colors.black.withOpacity(0.1)), // Faded icon
            Positioned(
              top: -15, // Adjust this value to move the text up or down
              child: Text(value.toString(),
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        SizedBox(height: 8), // Add some space between the icon-value stack and the label
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8), // Add some space between the label and the buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _decrementStat(label),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, -5), // Move the text up by 3 pixels
                  child: Text('-',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(width: 8), // Add some space between the buttons
            GestureDetector(
              onTap: () => _incrementStat(label),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, -5), // Move the text up by 3 pixels
                  child: Text('+',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconLabelFraction(IconData icon, String label, int numerator, int denominator) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.14), // Flip the icon horizontally
              child: Icon(icon, size: 45, color: Colors.black.withOpacity(0.1)), // Faded icon
            ), // Faded icon
            Stack(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Positioned(
                    top: -12,
                    left: 3,
                    child: Text(numerator.toString(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                Container(
                  width: 30,
                  height: 30,
                  child: CustomPaint(
                    painter: DiagonalLinePainter(),
                  ),
                ),
                Positioned(
                    top: 3,
                    left: 17,
                    child: Text(denominator.toString(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              ],
            ),
          ],
        ),
        SizedBox(height: 8), // Add some space between the icon-value stack and the label
        Text(label, style: TextStyle(fontSize: 16)),
        numerator > denominator
            ? Container(
                height: 32,
                child: Text(
                  "Encumbered",
                  style: TextStyle(color: Colors.red),
                ))
            : SizedBox(height: 32)
      ],
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    // Draw diagonal line
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
