import 'package:flutter/material.dart';

class GameGuide extends StatefulWidget {
  @override
  _GameGuideState createState() => _GameGuideState();
}

class _GameGuideState extends State<GameGuide> {
  final List<GuideElement> _elements = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add initial guide text and actions
    _elements.add(GuideTextElement(
        "Halls of the Blood King is a Fantasy Horror adventure—a manor from a dimension of horror and pain materializes and begins disrupting the world's balance. Inside, a powerful undead lord guards secrets, treasures and unspeakable monsters while his forces pillage the countryside's blood and souls."));
    _elements.add(ActionBlockElement("Pick a Hook card, add to Scene, read to party"));
    _elements.add(ActionBlockElement("Add the Main Gate card to the Scene"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _elements.length,
            itemBuilder: (context, index) {
              return _elements[index].build(context, () {
                setState(() {}); // Rebuild when action block is toggled
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _elements.add(UserTextElement(_textController.text));
        _textController.clear();
        // Simulate guide response (replace with actual logic later)
        _elements.add(GuideTextElement("Thank you for your message. Here's a sample action:"));
        _elements.add(ActionBlockElement("Complete this action"));
      });
    }
  }
}

abstract class GuideElement {
  Widget build(BuildContext context, VoidCallback onStateChanged);
}

class GuideTextElement extends GuideElement {
  final String text;

  GuideTextElement(this.text);

  @override
  Widget build(BuildContext context, VoidCallback onStateChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(12),
          child: Text(text),
        ),
      ),
    );
  }
}

class UserTextElement extends GuideElement {
  final String text;

  UserTextElement(this.text);

  @override
  Widget build(BuildContext context, VoidCallback onStateChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(12),
          child: Text(text),
        ),
      ),
    );
  }
}

class ActionBlockElement extends GuideElement {
  final String text;
  bool isComplete = false;

  ActionBlockElement(this.text);

  @override
  Widget build(BuildContext context, VoidCallback onStateChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          isComplete = !isComplete;
          onStateChanged();
        },
        child: Container(
          decoration: BoxDecoration(
            color: isComplete ? Colors.grey[300] : Colors.yellow[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black),
          ),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(isComplete ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Expanded(child: Text(text)),
            ],
          ),
        ),
      ),
    );
  }
}
