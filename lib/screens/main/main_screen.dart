import 'package:desktop/desktop.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Tab(
      itemPadding: const EdgeInsets.symmetric(horizontal: 8),
      backgroundColor: Theme.of(context).colorScheme.background[12],
      items: [
        TabItem(
          itemBuilder: (context, index) =>
              _createCustomTab(loc.decoderTitle, Icons.find_in_page),
          builder: (context, _) => Center(
            child: Text(
              loc.decoderTitle,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
        TabItem(
          itemBuilder: (context, index) =>
              _createCustomTab(loc.settingsTitle, Icons.settings),
          builder: (context, _) => Center(
            child: Text(
              loc.settingsTitle,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createCustomTab(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}
