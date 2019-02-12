class Badge {
  final BadgeKeyword keyword;
  final String keywordDescription;

  Badge(
      {this.keyword,
       this.keywordDescription,
      });

  factory Badge.fromJson(Map<String, dynamic> parsedJson) {

    return Badge(
        keyword: _getBadgeKeywordEnum(parsedJson['keyword']),
        keywordDescription: parsedJson['keyword_description']
    );
  }

  static BadgeKeyword _getBadgeKeywordEnum(keyword) {

    switch(keyword) {
      case 'VERIFIED': return BadgeKeyword.verified; break;
      case 'FOUNDER': return BadgeKeyword.founder; break;
      case 'GOLDEN_FOUNDER': return BadgeKeyword.golden_founder; break;
      case 'DIAMOND_FOUNDER': return BadgeKeyword.diamond_founder; break;
      case 'SUPER_FOUNDER': return BadgeKeyword.super_founder; break;
      default: return BadgeKeyword.none; break;
    }


  }

  BadgeKeyword getKeyword() {
    return this.keyword;
  }

  String getKeywordDescription() {
    return this.keywordDescription;
  }
}

enum BadgeKeyword { verified, founder, golden_founder, diamond_founder, super_founder, none }