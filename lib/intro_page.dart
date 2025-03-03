import 'package:echoes_of_expanse/player/character_creation_manager.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      titleSection(context, constraints),
                      SizedBox(height: 40),
                      choosePathSection(context),
                      SizedBox(height: 100),
                      whatIsThisSection(context, constraints),
                      whereDidThisComeFromSection(context),
                      howIsThisDifferent(context),
                      whatsNext(context),
                      getStartedSection(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
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
        "Dive into an epic tabletop roleplay adventure that anyone can learn and play with 5 minutes of setup.",
        textAlign: isDesktopLayout ? TextAlign.left : TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isDesktopLayout ? 1000 : 600),
        child: isDesktopLayout
            ? titleSectionDesktopLayout(logoImage, brandImage, introText)
            : titleSectionMobileLayout(logoImage, brandImage, introText),
      ),
    );
  }

  Widget titleSectionDesktopLayout(Widget logoImage, Widget brandImage, Widget introText) {
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

  Widget titleSectionMobileLayout(Widget logoImage, Widget brandImage, Widget introText) {
    return SingleChildScrollView(
      child: Column(
        children: [
          logoImage,
          introText,
          brandImage,
        ],
      ),
    );
  }

  Widget choosePathSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobileLayout = constraints.maxWidth < 600;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Choose Your Path",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 24),
              // Use Column instead of Row for mobile layout
              isMobileLayout
                  ? Column(
                      children: [
                        _buildPathOption(
                          context,
                          "Gamemaster",
                          "Are you a holder of secrets and arbiter of justice?",
                          "CREATE A GAME",
                          () => Navigator.pushNamed(context, '/gamemaster'),
                        ),
                        SizedBox(height: 24), // Add spacing between options
                        _buildPathOption(
                          context,
                          "Character",
                          "Are you a treasure seeker and problem solver?",
                          "CREATE A CHARACTER",
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CharacterCreationManager()),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _buildPathOption(
                              context,
                              "Gamemaster",
                              "Are you a holder of secrets and arbiter of justice?",
                              "CREATE A GAME",
                              () => Navigator.pushNamed(context, '/gamemaster'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: _buildPathOption(
                              context,
                              "Character",
                              "Are you a treasure seeker and problem solver?",
                              "CREATE A CHARACTER",
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CharacterCreationManager()),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to reduce code duplication
  Widget _buildPathOption(
    BuildContext context,
    String title,
    String description,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ],
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
          'All-in-one',
          "You dont need any other vtts to play. Our virtual tabletop is built right into the app. Gamemaster adds Location, Character, Threat, and Items cards to a shared screen. Players can read and interact with the cards and move character tokens around the space.",
          'assets/images/vtt.png',
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
            "For the past 8 years, I have been passionate about making tabletop role-playing games more accessible. My first attempt was a mobile app that radically simplified roleplay into \"say what you try and roll\". Then I made a card game where cards had prompts for story ideas. Both of these failed to strike the right balance between storytelling and game mechanics. Then I discovered Dungeon World… I was so impressed by its design that I was inspired to try again taking a cue from their approach.",
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
            "Coming soon are more character classes, new tools for Gamemasters, and multiple adventure decks. Join us on our Discord (coming soon) to stay up to date and contribute to the evolution of Echoes of Expanse!",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]));
  }

  Widget getStartedSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
        SizedBox(height: 80),
        Text(
          "Echoes of Expanse is a creation of Augustin Bralley, 2025. \nLicensed under the Creative Commons Attribution-ShareAlike 3.0 United States (CC BY-SA 3.0 US).",
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 100),
      ],
    );
  }
}
