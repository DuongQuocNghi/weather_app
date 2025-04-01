import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/constants/local.dart';
import 'package:weather_app/core/utils/alert.dart';
import 'package:weather_app/core/widgets/navigation_bar_view.dart';
import 'package:weather_app/features/demo/demo_page.dart';
import 'package:weather_app/features/home/bloc/home_bloc.dart';
import 'package:weather_app/features/home/bloc/home_event.dart';
import 'package:weather_app/features/home/bloc/home_state.dart';
import 'package:weather_app/i18n/app_localizations.dart';

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (context) => const HomePage());
  }

  const HomePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Local.dataLocal.getLanguage().then((v) {
      if (v != null && appLanguage != v) {
        setState(() {
          appLanguage = v;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: Locale(appLanguage),
      child: BlocProvider(
        create: (_) => HomeBloc()..add(HomeInitial()),
        child: Scaffold(
            backgroundColor: appColors.background,
            body: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildHeader(context, state),
                    _buildBody(context, state)
                  ],
                );
              },
            )),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeState state) {
    return Column(
      children: [
        NavigationBarView(
          titleText: AppLocalizations.of(context)?.hello,
          actionLeft: const [],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildItem(
              title: 'Demo Page',
              onTap: () {
                Navigator.of(context).push(DemoPage.route());
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({required String title, Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: GestureDetector(
        onTap: onTap ??
            () => AppAlert.showWarningToast(
                AppLocalizations.of(context)?.coming_soon ?? ''),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: appColors.onBackground_2,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(color: appColors.onBackground_9),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: appColors.onBackground_9),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
