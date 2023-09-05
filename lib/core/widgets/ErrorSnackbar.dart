import 'package:flutter/material.dart';

class ErrorSnackbar extends SnackBar {
  ErrorSnackbar(
      {Key? key,
      required String errorMessage,
      required String errorCode,
      required BuildContext context})
      : super(
          key: key,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                errorCode,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            textColor: Colors.white,
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
}
