import 'package:echoes_of_expanse/character_creation_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
            child: Center(
                // Wrap Column with Center
                child: ConstrainedBox(
          // Apply ConstrainedBox here
          constraints: BoxConstraints(maxWidth: 1000), // Set maxWidth to 1000 for all content

          child: Column(
            children: [
              titleSection(context, constraints),
              SizedBox(height: 100),
              whatIsThisSection(context, constraints),
              whereDidThisComeFromSection(context),
              howIsThisDifferent(context),
              whatsNext(context),
              getStartedSection(context),
              SizedBox(height: 100),
            ],
          ),
        )));
      },
    );
  }

  Widget titleSection(BuildContext context, dynamic constraints) {
    bool isDesktopLayout = constraints.maxWidth > 600;
    Widget logoImage = Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Image.asset('assets/images/eoe-logo.webp'),
    );
    Widget brandImage = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Image.asset('assets/images/intro_page_logo.webp'),
    );
    Widget introText = Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
      child: Text(
        // "Dive into an epic tabletop roleplay adventure where fast, easy setup meets rich character development. Whether you're a newcomer or an experienced player, this game is designed to get you started quickly while offering a deep, narrative-driven experience.",
        "The tabletop roleplay game without all the fuss...",
        // "Build an epic character in 5 minutes.",
        textAlign: isDesktopLayout ? TextAlign.left : TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
    Widget startButton = Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CharacterCreationManager()),
          );
        },
        child: const Text("Make a character in 1 min"),
      ),
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isDesktopLayout ? 1000 : 600),
        child: isDesktopLayout
            ? titleSectionDesktopLayout(logoImage, brandImage, introText, startButton)
            : titleSectionMobileLayout(logoImage, brandImage, introText, startButton),
      ),
    );
  }

  Widget titleSectionDesktopLayout(
      Widget logoImage, Widget brandImage, Widget introText, Widget startButton) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              logoImage,
              introText,
              startButton,
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: brandImage,
        )
      ],
    );
  }

  Widget titleSectionMobileLayout(
      Widget logoImage, Widget brandImage, Widget introText, Widget startButton) {
    return SingleChildScrollView(
      child: Column(
        children: [
          logoImage,
          introText,
          brandImage,
          startButton,
        ],
      ),
    );
  }

  Widget whatIsThisSection(BuildContext context, BoxConstraints constraints) {
    bool isMobileLayout = constraints.maxWidth < 600;
    List<Widget> benefitItems = [
      benefitItem(
          context,
          'Easy to learn',
          "The initial instructions can be read in a minute. More rules are introduced as you need them. No session zero required, 10 minutes of explanation and you're off!",
          'assets/images/benefit-rules.webp',
          isMobileLayout,
          0),
      benefitItem(
          context,
          'Effortless character development',
          "Pick some cards. Every choice you make helps tell your character's story. As you play, see only the cards that are relevant to your character.",
          'assets/images/benefit-cards.webp',
          isMobileLayout,
          1),
      benefitItem(
          context,
          'No pencils or paper',
          "Everything is included here. Your character sheet is auto-generated based on your card selections. Just click to change stats, add items, and spend coin.",
          'assets/images/benefit-sheet.webp',
          isMobileLayout,
          2),
      benefitItem(
          context,
          'Compatible with Dungeon World',
          "While optimized for shorter-term play, you can run Echoes of Expanse with any Dungeon World dungeon starter. Just map Wisdom, Intelligence to Smarts; Dexterity, Strength to Power; and Constitution to Grit.",
          'assets/images/dw-use-logo.jpeg',
          isMobileLayout,
          3),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What is this?",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 10.0), // Add some spacing between headline and body text
          Text(
            "Echoes of Expanse is a rules-light tabletop roleplay game designed to be easy to learn, teach others, and play. This app gives you all the tools you need to play a character in a oneshot or short campaign adventure.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 20.0),
          ...benefitItems,
        ],
      ),
    );
  }

  Widget benefitItem(BuildContext context, String title, String description, String imagePath,
      bool isMobileLayout, int index) {
    Widget image = Image.asset(imagePath, width: 300);
    Widget textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyLarge),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 40.0), // Add some spacing between text items
      ],
    );

    if (isMobileLayout) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [image, textContent],
        ),
      );
    } else {
      List<Widget> rowChildren = index.isEven
          ? [
              image,
              Expanded(child: Padding(padding: EdgeInsets.only(left: 16.0), child: textContent))
            ]
          : [
              Expanded(child: Padding(padding: EdgeInsets.only(right: 16.0), child: textContent)),
              image
            ];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );
    }
  }

  Widget whereDidThisComeFromSection(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Where did this come from?",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 8.0), // Add some spacing between headline and body text
          Text(
            "Echoes of Expanse is a creation of Augustin Bralley, 2024. " +
                "Licensed under the Creative Commons Attribution-ShareAlike 3.0 United States (CC BY-SA 3.0 US). " +
                "Echoes of Expanse is based on Homebrew World, which was built for Dungeon World, and is Powered by the Apocalypse.",
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ]));
  }

  Widget howIsThisDifferent(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "How is this different?",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 8.0), // Add some spacing between headline and body text
          Text(
            "Echoes of Expanse is a more streamlined version of Homebrew World and is adapted to a card format."
            " Most of the changes are designed to make the game easier to learn and play.\n\n"
            "• There are only 4 core stats: Power, Smarts, Charm, and Grit\n\n"
            "• XP and inventory systems merged into a coin-based system.\n\n"
            "• Damage dice are not tied to a class, but rather to a weapon.\n\n"
            "• Many moves have been streamlined e.g. Spellbook also contains the rules for Cast a Spell.\n\n"
            "• Bonds are separate from Backgrounds.\n\n"
            "• Ancestry cards provide additional flavor and abilities.\n\n"
            "• Many more tweaks and modifications...",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]));
  }

  Widget whatsNext(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "What's Next?",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 8.0), // Add some spacing between headline and body text
          Text(
            "Coming soon are more character classes, new tools for Gamemasters, and starter adventure decks. Join us on our Discord (coming soon) to stay up to date and contribute to the evolution of Echoes of Expanse!",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]));
  }

  Widget getStartedSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          "What are you waiting for?",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CharacterCreationManager()),
            );
          },
          child: Text("Build your character for free"),
        ),
      ],
    );
  }
}
