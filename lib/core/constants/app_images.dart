/// アプリで使用する画像パスを管理するクラス
///
/// 使用例: Image.asset(AppImages.lobbyLogo)
class AppImages {
  AppImages._();

  // ベースパス
  static const String _basePath = 'assets/images';

  // ロゴ
  static const String lobbyLogo = '$_basePath/logos/lobby_logo.png';
  static const String lobbyLogoWhite = '$_basePath/logos/lobby_logo_white.png';
  static const String lobbyIcon = '$_basePath/logos/lobby_icon.png';

  // 背景画像
  static const String authBackground =
      '$_basePath/backgrounds/house.jpeg'; // 実際のファイル
  static const String homeBackground =
      '$_basePath/backgrounds/home_background.jpg';
  static const String callBackground =
      '$_basePath/backgrounds/call_background.jpeg';
  static const String gradientOverlay =
      '$_basePath/backgrounds/gradient_overlay.png';

  // アイコン
  static const String serviceIcon1 = '$_basePath/icons/service_icon_1.png';
  static const String serviceIcon2 = '$_basePath/icons/service_icon_2.png';

  // カスタムアイコン
  static const String emailIcon =
      '$_basePath/icons/custom_icons/email_icon.png';
  static const String passwordIcon =
      '$_basePath/icons/custom_icons/password_icon.png';

  // アバター
  static const String defaultAvatar = '$_basePath/avatars/default_avatar.png';
  static const String staffSample = '$_basePath/avatars/staff_sample.png';
  static const String placeholderAvatar =
      '$_basePath/avatars/placeholder_avatar.png';

  // イラスト
  static const String onboarding1 = '$_basePath/illustrations/onboarding_1.png';
  static const String onboarding2 = '$_basePath/illustrations/onboarding_2.png';
  static const String emptyState = '$_basePath/illustrations/empty_state.png';

  // 共通画像
  static const String errorImage = '$_basePath/common/error_image.png';
  static const String loadingPlaceholder =
      '$_basePath/common/loading_placeholder.png';
  static const String noImage = '$_basePath/common/no_image.png';
  static const String lobbyCompany = '$_basePath/common/lobby_company.jpg';

  /// 画像ファイルが存在するかチェック（デバッグ用）
  static List<String> getAllImagePaths() {
    return [
      lobbyLogo,
      lobbyLogoWhite,
      lobbyIcon,
      authBackground,
      homeBackground,
      callBackground,
      gradientOverlay,
      serviceIcon1,
      serviceIcon2,
      emailIcon,
      passwordIcon,
      defaultAvatar,
      placeholderAvatar,
      onboarding1,
      onboarding2,
      emptyState,
      errorImage,
      loadingPlaceholder,
      noImage,
      lobbyCompany,
      staffSample,
    ];
  }
}
