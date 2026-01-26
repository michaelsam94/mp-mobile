import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/helpers/network/dio_helper.dart';
import '../../../core/helpers/network/end_points.dart';
import '../models/notification_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  static NotificationsCubit get(context) => BlocProvider.of(context);

  List<NotificationModel> notifications = [];

  Future<void> getNotifications() async {
    emit(LoadingNotificationsState());

    try {
      var response = await DioHelper.getData(url: EndPoints.notifications);

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        notifications = data
            .map((e) => NotificationModel.fromJson(e))
            .toList();

        // Sort by sent_at date (newest first)
        notifications.sort((a, b) {
          if (a.sentAt == null || b.sentAt == null) return 0;
          return b.sentAt!.compareTo(a.sentAt!);
        });

        emit(SuccessNotificationsState(notifications));
      } else {
        emit(ErrorNotificationsState(
          message: response.data["message"] ?? 'Failed to load notifications',
        ));
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error getting notifications: ${e.toString()}');
      }
      emit(ErrorNotificationsState(
        message: 'Failed to load notifications. Please try again.',
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error getting notifications: ${e.toString()}');
      }
      emit(ErrorNotificationsState(
        message: 'An error occurred. Please try again.',
      ));
    }
  }
}
