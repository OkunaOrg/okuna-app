class LinkPreview {
  String title;
  String siteName;
  String description;
  String imageUrl;
  String faviconUrl;
  String domainUrl;
  String url;
  List<int> image;

  LinkPreview(
      {this.title,
      this.siteName,
      this.description,
      this.url,
      this.imageUrl,
      this.faviconUrl,
      this.image,
      this.domainUrl});

  @override
  String toString() {
    return 'LinkPreview:Title:$title:SiteName:$siteName:Description:$description:FaviconUrl:$faviconUrl:DomainUrl:$domainUrl:Url:$url';
  }
}
