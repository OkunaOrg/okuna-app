class Badge {
  final BadgeKeyword keyword;
  final String keywordDescription;

  Badge(
      {this.keyword,
       this.keywordDescription,
      });

  factory Badge.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson == null) return null;

    return Badge(
        keyword: _getBadgeKeywordEnum(parsedJson['keyword']),
        keywordDescription: parsedJson['keyword_description']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyword': _getBadgeKeywordFromEnum(keyword),
      'keyword_description': keywordDescription
    };
  }

  static BadgeKeyword _getBadgeKeywordEnum(keyword) {

    switch(keyword) {
      case 'ANGEL': return BadgeKeyword.angel; break;
      case 'VERIFIED': return BadgeKeyword.verified; break;
      case 'FOUNDER': return BadgeKeyword.founder; break;
      case 'GOLDEN_FOUNDER': return BadgeKeyword.golden_founder; break;
      case 'DIAMOND_FOUNDER': return BadgeKeyword.diamond_founder; break;
      case 'SUPER_FOUNDER': return BadgeKeyword.super_founder; break;
      default: return BadgeKeyword.none; break;
    }
  }

  static String _getBadgeKeywordFromEnum(enumKeyword) {

    switch(enumKeyword) {
      case  BadgeKeyword.angel: return 'ANGEL'; break;
      case BadgeKeyword.verified: return 'VERIFIED'; break;
      case BadgeKeyword.founder: return 'FOUNDER'; break;
      case BadgeKeyword.golden_founder: return 'GOLDEN_FOUNDER'; break;
      case BadgeKeyword.diamond_founder: return 'DIAMOND_FOUNDER'; break;
      case BadgeKeyword.super_founder: return 'SUPER_FOUNDER'; break;
      default: return ''; break;
    }
  }

  BadgeKeyword getKeyword() {
    return this.keyword;
  }

  String getKeywordDescription() {
    return this.keywordDescription;
  }
}

enum BadgeKeyword { angel, verified, founder, golden_founder, diamond_founder, super_founder, none }