import 'package:echoes_of_expanse/data.dart';
import 'package:flutter/material.dart';

class CharacterSheet extends StatefulWidget {
  final Hand hand;

  CharacterSheet({required this.hand});

  @override
  _CharacterSheetState createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  Map<String, String> characterStats = {};
  @override
  void initState() {
    super.initState();
    widget.hand.loadCards().then((stats) {
      setState(() {
        characterStats = stats;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Class fields
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'Name')),
                SizedBox(width: 10),
                Expanded(child: _buildTextField(label: 'Class')),
              ],
            ),
            SizedBox(height: 10),

            // Drive, Ancestry, Background fields
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'Drive')),
                SizedBox(width: 10),
                Expanded(
                    child: _buildLabelWithLineAndText(
                        label: 'Ancestry', value: characterStats['ancestry'])),
                SizedBox(width: 10),
                Expanded(child: _buildTextField(label: 'Background')),
              ],
            ),
            SizedBox(height: 10),

            // Mission and Counterpart Name fields
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'Mission')),
                SizedBox(width: 10),
                Expanded(child: _buildTextField(label: 'Counterpart Name')),
              ],
            ),
            SizedBox(height: 20),

            // Stats sections
            _buildStatSection('Power',
                'Power through or test your might.\nLeap, throttle, destroy, dodge.', 'Weak', '+2'),
            _buildStatSection(
                'Smarts',
                'Think through or rely on senses.\nOutwit, investigate, decipher.',
                'Confused',
                '+1'),
            _buildStatSection('Charm',
                'Charm, bluff, impress, or fit in.\nSeduce or compel someone.', 'Scarred', '0'),
            _buildStatSection(
                'Grit', 'Endure or hold steady.\nDefend or protect others.', 'Sick', '-1'),
            SizedBox(height: 20),

            // Bottom icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconLabel(Icons.favorite, 'Health'),
                _buildIconLabel(Icons.attach_money, 'Coin'),
                _buildIconLabel(Icons.fitness_center, 'Weight'),
                _buildIconLabel(Icons.shield, 'Armor'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.all(8),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelWithLineAndText({required String label, required String? value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8), // Space between label and line
        Text(value ?? '', style: TextStyle(fontSize: 18)),
        Container(
          height: 1,
          color: Colors.black,
        ),
        SizedBox(height: 8), // Space below the line
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
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(description),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (value) {}),
                    Text(condition),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
