import 'package:Okuna/models/updatable_model.dart';
import 'package:dcache/dcache.dart';

import 'link_preview_image.dart';

class LinkPreview extends UpdatableModel<LinkPreview> {
  final int id;
  String url;
  String domain;
  DateTime lastUpdated;
  DateTime nextUpdate;
  String contentType;
  String mimeType;
  bool redirected;
  String redirectionUrl;
  List<String> redirectionTrail;
  String title;
  String description;
  String name;
  bool trackersDetected;
  LinkPreviewImage icon;
  LinkPreviewImage image;

  LinkPreview({
    this.id,
    this.url,
    this.domain,
    this.lastUpdated,
    this.nextUpdate,
    this.contentType,
    this.mimeType,
    this.redirected,
    this.redirectionUrl,
    this.redirectionTrail,
    this.title,
    this.description,
    this.name,
    this.trackersDetected,
    this.icon,
    this.image,
  });

  static final factory = LinkPreviewFactory();

  factory LinkPreview.fromJSON(Map<String, dynamic> json) {
    if (json == null) return null;
    return factory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'domain': domain,
      'lastUpdated': lastUpdated.toString(),
      'nextUpdate': nextUpdate.toString(),
      'contentType': contentType,
      'mimeType': mimeType,
      'redirected': redirected,
      'redirectionUrl': redirectionUrl,
      'redirectionTrail': redirectionTrail,
      'title': title,
      'description': description,
      'name': name,
      'trackersDetected': trackersDetected,
      'icon': icon,
      'image': image,
    };
  }

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('url')) url = json['url'];
    if (json.containsKey('domain')) domain = json['domain'];
    if (json.containsKey('lastUpdated'))
      lastUpdated = factory.parseDate(json['lastUpdated']);
    if (json.containsKey('nextUpdate'))
      nextUpdate = factory.parseDate(json['nextUpdate']);
    if (json.containsKey('contentType')) contentType = json['contentType'];
    if (json.containsKey('mimeType')) mimeType = json['mimeType'];
    if (json.containsKey('redirected')) redirected = json['redirected'];
    if (json.containsKey('redirectionUrl'))
      redirectionUrl = json['redirectionUrl'];
    if (json.containsKey('redirectionTrail'))
      redirectionTrail = json['redirectionTrail'];
    if (json.containsKey('title')) title = json['title'];
    if (json.containsKey('description')) description = json['description'];
    if (json.containsKey('name')) name = json['name'];
    if (json.containsKey('trackersDetected'))
      trackersDetected = json['trackersDetected'];
    if (json.containsKey('icon')) icon = json['icon'];
    if (json.containsKey('image')) image = json['image'];
  }
}

class LinkPreviewFactory extends UpdatableModelFactory<LinkPreview> {
  @override
  SimpleCache<int, LinkPreview> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 100));

  @override
  LinkPreview makeFromJson(Map json) {
    return LinkPreview(
      id: json['id'],
      url: json['url'],
      domain: json['domain'],
      lastUpdated: parseDate(json['lastUpdated']),
      nextUpdate: parseDate(json['nextUpdate']),
      contentType: json['contentType'],
      mimeType: json['mimeType'],
      redirected: json['redirected'],
      redirectionUrl: json['redirectionUrl'],
      redirectionTrail: json['redirectionTrail'],
      title: json['title'],
      description: json['description'],
      name: json['name'],
      trackersDetected: json['trackersDetected'],
      icon: parsePreviewImage(json['icon']),
      image: parsePreviewImage(json['image']),
    );
  }

  LinkPreviewImage parsePreviewImage(Map previewImageData) {
    if (previewImageData == null) return null;
    return LinkPreviewImage.fromJson(previewImageData);
  }

  DateTime parseDate(String created) {
    if (created == null) return null;
    return DateTime.parse(created).toLocal();
  }
}
