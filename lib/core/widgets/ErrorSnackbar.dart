import 'package:flutter/material.dart';

class ErrorSnackbar extends SnackBar {
  ErrorSnackbar({Key? key,
    required String errorMessage,
    required String errorCode,
    required BuildContext context})
      : super(
    key: key,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
    backgroundColor: Theme
        .of(context)
        .primaryColor,
    action: SnackBarAction(
      textColor: Colors.white,
      label: 'Close',
      onPressed: () {
        ScaffoldMessenger.of(context).clearSnackBars();
      },
    ),
  );
}

class ErrorSnackbarWidget extends StatelessWidget {
  final String errorCode;
  final String errorMessage;
  final BuildContext context;

  const ErrorSnackbarWidget({super.key,
    required this.errorCode,
    required this.errorMessage,
    required this.context});

  @override
  Widget build(context) {
    return Builder(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackbar(
              errorCode: errorCode,
              errorMessage: errorMessage,
              context: context,
            ),
          );
        });

        return Container();
      },
    );
  }
}
