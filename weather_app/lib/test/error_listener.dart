import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorListener<T extends ErrorNotifierMixin> extends StatelessWidget {
  final Widget? child;

  const ErrorListener({Key? key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
        builder: (context, model, child) {
          //here we listen for errors
          if (model.error != null) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              _handleError(context, model);
            });
          }

          // here we return child!
          return child!;
        },
        child: child);
  }

  // this method will be called anytime an error occurs
  // it shows a snackbar but it could do anything you want
  void _handleError(BuildContext context, T model) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content:
              Text(model.error!, style: const TextStyle(color: Colors.black)),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          duration: const Duration(seconds: 1),
        ),
      );

    // this will clear the error on model because it has been handled
    model.clearError();
  }
}

mixin ErrorNotifierMixin on ChangeNotifier {
  String? _error;
  String? get error => _error;

  void notifyError(dynamic error) {
    _error = error.toString();
    notifyListeners();
  }

  void clearError() {
    _error = null;
  }
}
