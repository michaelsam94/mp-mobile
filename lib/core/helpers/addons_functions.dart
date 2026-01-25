import 'package:flutter/material.dart';

extension AddonsFunctions on BuildContext {
  double width() => MediaQuery.sizeOf(this).width;
  double height() => MediaQuery.sizeOf(this).height;

  Future<dynamic> goTo(Widget screen) async {
    return await Navigator.push(this, _build(screen));
  }

  Future<dynamic> goOff(Widget screen) async {
    return await Navigator.pushReplacement(this, _build(screen));
  }

  Future<dynamic> goOffAll(Widget screen) async {
    return await Navigator.pushAndRemoveUntil(
      this,
      _build(screen),
      (route) => false,
    );
  }

  PageRoute _build(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(animation),
          child: child,
        );
      },
    );
  }

  // Show error snackbar message
  void showErrorMessage(String message) {
    final mediaQuery = MediaQuery.of(this);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final topPadding = mediaQuery.padding.top;
    
    // Position above keyboard if keyboard is open, otherwise at top
    EdgeInsets margin;
    if (keyboardHeight > 0) {
      // When keyboard is open, position at bottom (above keyboard)
      // Use only bottom constraint
      margin = EdgeInsets.only(
        left: 20,
        right: 20,
        top: 0,
        bottom: keyboardHeight + 20,
      );
    } else {
      // When keyboard is closed, position at top (original position)
      final topMargin = topPadding + 130;
      final screenHeight = mediaQuery.size.height;
      
      // Ensure available space is sufficient for snackbar
      // Available space = screenHeight - topMargin - bottomMargin
      // Must be at least 150px for snackbar + padding (be conservative)
      const requiredSpace = 150.0;
      final maxBottomMargin = screenHeight - topMargin - requiredSpace;
      
      // Use bottom margin that ensures top positioning and fits on screen
      // Use 50% of screen height as preferred, but never exceed maxBottomMargin
      final preferredBottom = screenHeight * 0.5;
      var bottomMargin = preferredBottom;
      
      // Ensure it doesn't exceed maximum allowed
      if (maxBottomMargin > 0 && bottomMargin > maxBottomMargin) {
        bottomMargin = maxBottomMargin;
      }
      
      // Final safety check: ensure bottom margin is at least 100 to position from top
      if (bottomMargin < 100) {
        bottomMargin = 100;
      }
      
      // Verify available space one more time
      final availableSpace = screenHeight - topMargin - bottomMargin;
      if (availableSpace < requiredSpace) {
        // Adjust bottom margin to ensure enough space
        bottomMargin = screenHeight - topMargin - requiredSpace;
        if (bottomMargin < 0) {
          // If still not enough, reduce top margin
          final adjustedTop = screenHeight - requiredSpace - 100;
          margin = EdgeInsets.only(
            left: 20,
            right: 20,
            top: adjustedTop > 0 ? adjustedTop : topPadding + 20,
            bottom: 100,
          );
        } else {
          margin = EdgeInsets.only(
            left: 20,
            right: 20,
            top: topMargin,
            bottom: bottomMargin,
          );
        }
      } else {
        margin = EdgeInsets.only(
          left: 20,
          right: 20,
          top: topMargin,
          bottom: bottomMargin,
        );
      }
    }
    
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: margin,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Show success snackbar message
  void showSuccessMessage(String message) {
    final mediaQuery = MediaQuery.of(this);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final topPadding = mediaQuery.padding.top;
    
    // Position above keyboard if keyboard is open, otherwise at top
    EdgeInsets margin;
    if (keyboardHeight > 0) {
      // When keyboard is open, position at bottom (above keyboard)
      // Use only bottom constraint
      margin = EdgeInsets.only(
        left: 20,
        right: 20,
        top: 0,
        bottom: keyboardHeight + 20,
      );
    } else {
      // When keyboard is closed, position at top (original position)
      final topMargin = topPadding + 130;
      final screenHeight = mediaQuery.size.height;
      
      // Ensure available space is sufficient for snackbar
      // Available space = screenHeight - topMargin - bottomMargin
      // Must be at least 150px for snackbar + padding (be conservative)
      const requiredSpace = 150.0;
      final maxBottomMargin = screenHeight - topMargin - requiredSpace;
      
      // Use bottom margin that ensures top positioning and fits on screen
      // Use 50% of screen height as preferred, but never exceed maxBottomMargin
      final preferredBottom = screenHeight * 0.5;
      var bottomMargin = preferredBottom;
      
      // Ensure it doesn't exceed maximum allowed
      if (maxBottomMargin > 0 && bottomMargin > maxBottomMargin) {
        bottomMargin = maxBottomMargin;
      }
      
      // Final safety check: ensure bottom margin is at least 100 to position from top
      if (bottomMargin < 100) {
        bottomMargin = 100;
      }
      
      // Verify available space one more time
      final availableSpace = screenHeight - topMargin - bottomMargin;
      if (availableSpace < requiredSpace) {
        // Adjust bottom margin to ensure enough space
        bottomMargin = screenHeight - topMargin - requiredSpace;
        if (bottomMargin < 0) {
          // If still not enough, reduce top margin
          final adjustedTop = screenHeight - requiredSpace - 100;
          margin = EdgeInsets.only(
            left: 20,
            right: 20,
            top: adjustedTop > 0 ? adjustedTop : topPadding + 20,
            bottom: 100,
          );
        } else {
          margin = EdgeInsets.only(
            left: 20,
            right: 20,
            top: topMargin,
            bottom: bottomMargin,
          );
        }
      } else {
        margin = EdgeInsets.only(
          left: 20,
          right: 20,
          top: topMargin,
          bottom: bottomMargin,
        );
      }
    }
    
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: margin,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
