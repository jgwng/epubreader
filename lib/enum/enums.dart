Navigation decodeNavigation(String code) {
  int index = Navigation.values.indexWhere((element) => element.value == code);
  if(index <0){
    return Navigation.scroll;
  }
  return Navigation.values[index];
}

enum Navigation {
  scroll('scrolled', '스크롤'),
  page('paginated', '페이지');

  final String title;
  final String value;

  const Navigation(this.value, this.title);
}

CurlAnimation decodeCurlAnimation(String code) {
  int index = CurlAnimation.values.indexWhere((element) => element.value == code);
  if(index <0){
    return CurlAnimation.slide;
  }
  return CurlAnimation.values[index];
}

enum CurlAnimation {
  slide('slide', '슬라이드'),
  fade('fade', '페이드'),
  none('none', '효과없음');

  final String title;
  final String value;

  const CurlAnimation(this.value, this.title);
}

FontFamily decodeFontFamily(String code) {
  int index = FontFamily.values.indexWhere((element) => element.value == code);
  if(index <0){
    return FontFamily.batang;
  }
  return FontFamily.values[index];
}

enum FontFamily {
  batang('batang', '바탕체'),
  myeongjo('myeongjo', '명조체'),
  pretendard('pretendard', '프리텐다드');

  final String title;
  final String value;

  const FontFamily(this.value, this.title);
}
