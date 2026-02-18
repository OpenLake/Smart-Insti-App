class Club {
  final String id;
  final String name;
  final String description;
  final String type;
  final String domain;
  final String? logo;
  final String? banner;
  final Map<String, String> socialLinks;
  final String? email;
  final List<ClubMember>? members; // Optional, populated on detail view

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.domain,
    this.logo,
    this.banner,
    required this.socialLinks,
    this.email,
    this.members,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    Map<String, String> links = {};
    if (json['socialLinks'] != null) {
      json['socialLinks'].forEach((key, value) {
        if (value != null) links[key] = value.toString();
      });
    }

    var memberList = <ClubMember>[];
    if (json['members'] != null) {
      memberList = (json['members'] as List).map((m) => ClubMember.fromJson(m)).toList();
    }

    return Club(
      id: json['_id'],
      name: json['name'],
      description: json['description'] ?? '',
      type: json['type'] ?? 'Club',
      domain: json['domain'] ?? 'Other',
      logo: json['logo'],
      banner: json['banner'],
      socialLinks: links,
      email: json['email'],
      members: json['members'] != null ? memberList : null,
    );
  }
}

class ClubMember {
  final String id;
  final String userId;
  final String name;
  final String? profilePicURI;
  final String role;
  final bool isCore;
  final bool isAdmin;
  final String session;

  ClubMember({
    required this.id,
    required this.userId,
    required this.name,
    this.profilePicURI,
    required this.role,
    required this.isCore,
    required this.isAdmin,
    required this.session,
  });

  factory ClubMember.fromJson(Map<String, dynamic> json) {
    return ClubMember(
      id: json['_id'],
      userId: json['user']['_id'],
      name: json['user']['name'],
      profilePicURI: json['user']['profilePicURI'],
      role: json['role'],
      isCore: json['isCore'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      session: json['session'] ?? '',
    );
  }
}
