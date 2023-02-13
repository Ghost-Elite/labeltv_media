class APIItems {
  List<Allitems>? allitems;

  APIItems({this.allitems});

  APIItems.fromJson(Map<String, dynamic> json) {
    if (json['allitems'] != null) {
      allitems = <Allitems>[];
      json['allitems'].forEach((v) {
        allitems!.add(new Allitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allitems != null) {
      data['allitems'] = this.allitems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Allitems {
  String? id;
  String? title;
  String? desc;
  String? logo;
  String? logoUrl;
  String? type;
  String? feedUrl;
  String? alauneFeed;
  String? vodFeed;
  String? slug;
  String? guidetvnow;
  String? streamUrl;
  String? afficheUrl;
  String? listChannelsByCategory;
  String? listPubs;
  bool isSelected=false;

  Allitems(
      {this.id,
        this.title,
        this.desc,
        this.logo,
        this.logoUrl,
        this.type,
        this.feedUrl,
        this.alauneFeed,
        this.vodFeed,
        this.slug,
        this.guidetvnow,
        this.streamUrl,
        this.afficheUrl,
        this.listChannelsByCategory,
        this.listPubs,
        required this.isSelected
      });

  Allitems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    logo = json['logo'];
    logoUrl = json['logo_url'];
    type = json['type'];
    feedUrl = json['feed_url'];
    alauneFeed = json['alaune_feed'];
    vodFeed = json['vod_feed'];
    slug = json['slug'];
    guidetvnow = json['guidetvnow'];
    streamUrl = json['stream_url'];
    afficheUrl = json['affiche_url'];
    listChannelsByCategory = json['list_channels_by_category'];
    listPubs = json['list_pubs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['logo'] = this.logo;
    data['logo_url'] = this.logoUrl;
    data['type'] = this.type;
    data['feed_url'] = this.feedUrl;
    data['alaune_feed'] = this.alauneFeed;
    data['vod_feed'] = this.vodFeed;
    data['slug'] = this.slug;
    data['guidetvnow'] = this.guidetvnow;
    data['stream_url'] = this.streamUrl;
    data['affiche_url'] = this.afficheUrl;
    data['list_channels_by_category'] = this.listChannelsByCategory;
    data['list_pubs'] = this.listPubs;
    return data;
  }
}
