import '../../../core/widgets/status_tag.dart';

enum ProjectStatus { inProgress, paused, critical }

class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.address,
    required this.zone,
    required this.status,
    required this.checklistCount,
    required this.updatedAgo,
    required this.mapGradientStart,
    required this.mapGradientEnd,
  });

  final String id;
  final String name;
  final String address;
  final String zone;
  final ProjectStatus status;
  final int checklistCount;
  final String updatedAgo;
  final int mapGradientStart; // color int
  final int mapGradientEnd;   // color int

  TagType get tagType => switch (status) {
        ProjectStatus.inProgress => TagType.green,
        ProjectStatus.paused => TagType.yellow,
        ProjectStatus.critical => TagType.red,
      };

  String get statusLabel => switch (status) {
        ProjectStatus.inProgress => 'IN PROGRESS',
        ProjectStatus.paused => 'PAUSED',
        ProjectStatus.critical => 'CRITICAL',
      };
}
