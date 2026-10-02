class PersonalInfo {
  String name;
  String email;
  String phone;
  String location;
  String linkedin;
  String github;
  String website;
  String jobTitle;
  String summary;

  PersonalInfo({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.location = '',
    this.linkedin = '',
    this.github = '',
    this.website = '',
    this.jobTitle = '',
    this.summary = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'linkedin': linkedin,
        'github': github,
        'website': website,
        'jobTitle': jobTitle,
        'summary': summary,
      };

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      website: json['website'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      summary: json['summary'] ?? '',
    );
  }
}

class Experience {
  String jobTitle;
  String company;
  String location;
  String startDate;
  String endDate;
  bool isCurrent;
  String description;

  Experience({
    this.jobTitle = '',
    this.company = '',
    this.location = '',
    this.startDate = '',
    this.endDate = '',
    this.isCurrent = false,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'jobTitle': jobTitle,
        'company': company,
        'location': location,
        'startDate': startDate,
        'endDate': endDate,
        'isCurrent': isCurrent,
        'description': description,
      };

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      jobTitle: json['jobTitle'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      isCurrent: json['isCurrent'] ?? false,
      description: json['description'] ?? '',
    );
  }
}

class Education {
  String degree;
  String institution;
  String location;
  String startYear;
  String endYear;
  String grade;
  String description;

  Education({
    this.degree = '',
    this.institution = '',
    this.location = '',
    this.startYear = '',
    this.endYear = '',
    this.grade = '',
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'degree': degree,
        'institution': institution,
        'location': location,
        'startYear': startYear,
        'endYear': endYear,
        'grade': grade,
        'description': description,
      };

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      location: json['location'] ?? '',
      startYear: json['startYear'] ?? '',
      endYear: json['endYear'] ?? '',
      grade: json['grade'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Project {
  String name;
  String technologies;
  String description;
  String githubUrl;
  String liveUrl;

  Project({
    this.name = '',
    this.technologies = '',
    this.description = '',
    this.githubUrl = '',
    this.liveUrl = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'technologies': technologies,
        'description': description,
        'githubUrl': githubUrl,
        'liveUrl': liveUrl,
      };

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] ?? '',
      technologies: json['technologies'] ?? '',
      description: json['description'] ?? '',
      githubUrl: json['githubUrl'] ?? '',
      liveUrl: json['liveUrl'] ?? '',
    );
  }
}

class Certification {
  String name;
  String organization;
  String date;
  String credentialId;
  String url;

  Certification({
    this.name = '',
    this.organization = '',
    this.date = '',
    this.credentialId = '',
    this.url = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'organization': organization,
        'date': date,
        'credentialId': credentialId,
        'url': url,
      };

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'] ?? '',
      organization: json['organization'] ?? '',
      date: json['date'] ?? '',
      credentialId: json['credentialId'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class Resume {
  String id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  String templateId;

  PersonalInfo personalInfo;
  List<Experience> experience;
  List<Education> education;
  List<String> skills;
  List<Project> projects;
  List<Certification> certifications;

  Resume({
    String? id,
    this.title = 'My Resume',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.templateId = 'classic',
    PersonalInfo? personalInfo,
    List<Experience>? experience,
    List<Education>? education,
    List<String>? skills,
    List<Project>? projects,
    List<Certification>? certifications,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        personalInfo = personalInfo ?? PersonalInfo(),
        experience = experience ?? <Experience>[],
        education = education ?? <Education>[],
        skills = skills ?? <String>[],
        projects = projects ?? <Project>[],
        certifications = certifications ?? <Certification>[];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'templateId': templateId,
        'personalInfo': personalInfo.toJson(),
        'experience': experience.map((item) => item.toJson()).toList(),
        'education': education.map((item) => item.toJson()).toList(),
        'skills': skills,
        'projects': projects.map((item) => item.toJson()).toList(),
        'certifications': certifications.map((item) => item.toJson()).toList(),
      };

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id']?.toString(),
      title: json['title'] ?? 'My Resume',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      templateId: json['templateId'] ?? 'classic',
      personalInfo: json['personalInfo'] != null
          ? PersonalInfo.fromJson(
              Map<String, dynamic>.from(json['personalInfo']),
            )
          : PersonalInfo(),
      experience: json['experience'] != null
          ? (json['experience'] as List)
              .map(
                (item) => Experience.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : <Experience>[],
      education: json['education'] != null
          ? (json['education'] as List)
              .map(
                (item) => Education.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : <Education>[],
      skills: json['skills'] != null
          ? List<String>.from(json['skills'])
          : <String>[],
      projects: json['projects'] != null
          ? (json['projects'] as List)
              .map(
                (item) => Project.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : <Project>[],
      certifications: json['certifications'] != null
          ? (json['certifications'] as List)
              .map(
                (item) => Certification.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : <Certification>[],
    );
  }
}
