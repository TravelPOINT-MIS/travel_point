import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/widgets/drawer_bar.dart';
import 'package:travel_point/core/widgets/error_snackbar.dart';
import 'package:travel_point/injection_container.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';
import 'package:travel_point/core/widgets/bottom_bar.dart';
import 'package:travel_point/core/widgets/top_bar.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_bloc.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';
import 'package:travel_point/src/features/map/presentation/views/map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapPageType _activeMapPageTab = MapPageType.ExploreMap;

  void handleItemTapped(MapPageType mapPageType, context, MapState state) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final mapEvent =
        ClearMarkersEvent(keepSameCameraPosition: state.cameraPosition);
    mapBloc.add(mapEvent);

    setState(() {
      _activeMapPageTab = mapPageType;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget defaultScreen(AuthState state) {
      return BlocProvider<MapBloc>(
          create: (context) => sl(),
          child: BlocBuilder<MapBloc, MapState>(builder: (mapContext, state) {
            void onItemTap(MapPageType mapPageType) {
              return handleItemTapped(mapPageType, mapContext, state);
            }

            return Scaffold(
              appBar: const TopBarApp(),
              endDrawer: const DrawerMenu(),
              body: MapPage(activeMapPageTab: _activeMapPageTab),
              bottomNavigationBar: BottomNavigationBarApp(
                onItemTapped: onItemTap,
                activeMapTab: _activeMapPageTab,
              ),
            );
          }));
    }

    return BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
      return Stack(
        children: [
          AbsorbPointer(
            absorbing:
                state is LoadingAuthState || state is LoggingOutAuthState,
            child: defaultScreen(state),
          ),
          if (state is LoadingAuthState || state is LoggingOutAuthState)
            AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text((state is LoadingAuthState)
                      ? "Loading..."
                      : "Logging out..."),
                ],
              ),
            ),
          if (state is ErrorAuthState)
            ErrorSnackbarWidget(
              errorCode: state.errorCode,
              errorMessage: state.errorMessage,
              context: context,
            )
        ],
      );
    });
  }
}
