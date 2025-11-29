import 'package:casseed/api/api_client.dart';
import 'package:casseed/ui/core/alerts/app_notification.dart';
import 'package:casseed/ui/core/alerts/notification_severity.dart';

class ActivitiesService {
  static Future<MutationStatus<CampaignActivity>> update(
    CampaignActivity activity,
  ) async {
    try {
      final response = await ApiClient.put(
        "${ApiClient.dataApiVersion}/admin/marketing-planning/campaign-activities/${activity.activityId}",
        body: [activity.toJson()],
        fromJsonT: (json) =>
            CampaignActivity.fromJson(json as Map<String, dynamic>),
      );
      if (response.isSuccessful && response.payload.isNotEmpty) {
        return MutationStatus(
          message: "Updated activity successfully!",
          severity: NotificationSeverity.success,
          resource: response.payload.first,
        );
      } else {
        return MutationStatus(
          message: "Failed update activity!",
          severity: NotificationSeverity.error,
          resource: null,
        );
      }
    } catch (e) {
      return MutationStatus(
        message: "Failed to update activity!",
        severity: NotificationSeverity.error,
        resource: null,
      );
    }
  }

  static Future<MutationStatus<CampaignActivity>> delete(
    CampaignActivity activity,
  ) async {
    try {
      final response = await ApiClient.delete(
        "${ApiClient.dataApiVersion}/admin/marketing-planning/campaign-activities/${activity.activityId}",
        fromJsonT: (json) =>
            CampaignActivity.fromJson(json as Map<String, dynamic>),
      );

      if (response.isSuccessful) {
        return MutationStatus(
          message: "Deleted activity successfully!",
          severity: NotificationSeverity.success,
          resource: response.payload.first,
        );
      } else {
        return MutationStatus(
          message: "Failed delete activity!",
          severity: NotificationSeverity.error,
          resource: null,
        );
      }
    } catch (e) {
      return MutationStatus(
        message: "Failed to delete activity!",
        severity: NotificationSeverity.error,
        resource: null,
      );
    }
  }

  static Future<CampaignActivity?> show(String activityId) async {
    try {
      final response = await ApiClient.get(
        "${ApiClient.dataApiVersion}/admin/marketing-planning/campaign-activities/$activityId",
        fromJsonT: (json) =>
            CampaignActivity.fromJson(json as Map<String, dynamic>),
      );

      if (response.isSuccessful && response.payload.isNotEmpty) {
        return response.payload.first;
      }
    } catch (e) {
      //
    }
    return null;
  }

  static Future<MutationStatus<CampaignActivity>> create(
    CampaignActivity activity,
  ) async {
    try {
      final response = await ApiClient.post(
        "${ApiClient.dataApiVersion}/admin/marketing-planning/campaign-activities",
        body: [activity.toJson()],
        fromJsonT: (json) =>
            CampaignActivity.fromJson(json as Map<String, dynamic>),
      );
      if (response.isSuccessful && response.payload.isNotEmpty) {
        return MutationStatus(
          message: "Created activity successfully!",
          severity: NotificationSeverity.success,
          resource: response.payload.first,
        );
      } else {
        return MutationStatus(
          message: "Failed to create activity!",
          severity: NotificationSeverity.error,
          resource: null,
        );
      }
    } catch (e) {
      return MutationStatus(
        message: "Failed to create activity!",
        severity: NotificationSeverity.error,
        resource: null,
      );
    }
  }

  static Future<List<CampaignActivity>> index() async {
    try {
      final response = await ApiClient.get(
        "${ApiClient.dataApiVersion}/admin/marketing-planning/campaign-activities",
        fromJsonT: (json) =>
            CampaignActivity.fromJson(json as Map<String, dynamic>),
      );

      return response.payload;
    } catch (e) {
      return [];
    }
  }
}
