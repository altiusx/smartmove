///todo: refactor into chinese under zh.json

class Strings {
  static String get allFavoritesTitle => "Favorites";
  static String get searchTitle => "Search";
  static String get moreTitle => "More";

  static String get timingsNotAvailableInfo =>
      "Either these buses are not currently in operation, or the API is under maintenance. Please contact LTA for further information";
  static String get noFavorites =>
      "Choose a bus stop, **swipe a bus number to the left and tap the heart**.";
  static String get renameFavoritesPrompt =>
      "Tap any of the bus stop names below to change their display name:";
  static String get renameFavoritesPrompt2 =>
      "Note that you can rename any favorites. Search for them, then press the **Rename** button.";

  // confirmation bottom sheets
  static String confirmAddToFavorites(service, code) =>
      "Are you sure you want to **_ADD_** Bus **$service** from stop **$code** to your favorites?";
  static String confirmRemoveFromFavorites(service, code) =>
      "Are you sure you want to **_REMOVE_** Bus **$service** from stop **$code** from your favorites?";

  // bus stops list
  static String get noStopsNearby =>
      "There are no bus stops near you at the moment.";

  // search
  static String get noStopsFound => "No stops found. Please revise your query.";

  // location permissions
  static String get locationPermissionNotGiven =>
      "Location permissions required to see bus stops nearby.";
  static String get locationPermissionDenied =>
      "Please open the settings to enable location permission.";
  static String get cannotShowNearByStops =>
      "Please enable location permissions to see bus stops near by.";
  static String get afterEnablePermision =>
      'After enabling location permissions in the settings, tap the "Grant location access" button again.';

  static String get faqTitle => "Frequently asked questions";
  static String get faqText => """
# 1. How do I add or remove favorites?
- **Double tap** or **Long press** on any bus service tile, 
- The prompt to add/remove should appear

# 2. Why aren't all my favorites showing?
on the home page, only favorites that are **near** will be shown. To see all your favorites, click on the **"See all"** button.

# 3. How do I rename a bus stop?
There are two ways:
  1. Add the stop to your favorites, then go the "More" page (the third tab on the bottom bar), then tap **"Rename favorites"**
  2. Search for the bus stop in the search page (second tab), and press the **"Rename"** button.

# 4. How do I see more information on a particular bus stop?
There are two ways:
  - Either tap the bus service tile's 5-digit code (ex: 84009), or
  - Search for the bus stop in the search page, tap on the results to see more information
  """;

  static List<String> get messages => [
        "What do you call a group of pandas? A pandemic.",
        "How do you react to a lockdown in Singapore? CB!",
        "Hope you're enjoying the app!",
        "This shouldn't take more than 5 seconds...",
        "At your service in 5 seconds...",
      ];

  ///todo: shift strings to firebase
  static List<String> get tipsEn => [
        "Do remember to check for stagnant water under your flower pots",
        "Spray insecticide in dark corners around the house",
        "Clear the roof gutter and place BTI insecticide",
        "Cover bamboo pole holders after use",
        "If you live within a red dengue cluster, apply insect repellent regularly",
        "Please ensure that you observe good personal hygiene by washing or sanitizing your hands regularly",
        "Wear a mask and continue to observe safe distancing when out and about",
        "Avoid talking in public transport to minimize the spread of droplets",
        "Please keep social gatherings to a limit of just 2 per day",
        "Please ensure that you observe social distancing rules",
        "Please avoid social gatherings as much as possible",
        "Those with general anxiety or stress may call the National CARE Hotline (Tel: 6202-6868) for support.",
        "Please use the TraceTogether app or token to check-in to venues",
        "Do see a doctor if you are feeling unwell",
        "Refer to the Ministry of Health's website for accurate, up-to-date health and safety information",
        "Be wary of fake news that gets commonly shared in group chats",
        "Be on the lookout for scams such as messages asking for codes or an unbelievable online sale",
        "Apply for vaccination at your nearest community centre",
      ];

  static List<String> get tipsZh => [
        "切记检查花盆下是否有积水",
        "在房屋周围的黑暗角落喷洒杀虫剂",
        "如果您住在有地住宅，请清除屋顶排水沟并放置BTI杀虫剂",
        "如果您住在红色登革热病区，请定期涂驱虫剂",
        "即使已经进入第三阶段，也请留在家中，除非有必要离开",
        "请确保定期洗手或消毒以保持良好的个人卫生",
        "出门时戴上口罩并继续观察安全距离",
        "避免在公共交通工具上交谈以最大程度地减少飞沫传播",
        "请保持社交聚会每天最多2次",
        "请确保您遵守社会隔离规则",
        "请尽量避免参加社交聚会",
        "患有一般性焦虑或压力的人可以拨打国家护理热线（电话：6202-6868）寻求支持",
        "请使用 TraceTogether 应用或令牌登录到场地",
        "如果您感到不适，请去看医生",
        "请参阅卫生部的网站以获取准确，最新的健康和安全信息",
        "提防通常在群聊中共享的虚假新闻",
        "警惕欺诈行为，例如要求输入代码的消息或令人难以置信的在线销售",
        "在最近的社区中心申请疫苗接种",
      ];
}
