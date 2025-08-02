  let isScrolling = false;
  let scrollTimeout = null;

  document.addEventListener('touchstart', function (e) {
    isScrolling = false;
  });

  document.addEventListener('touchmove', function (e) {
    isScrolling = true;

    // 스크롤 중임을 Flutter에 전달
    window.flutter_inappwebview.callHandler("onScroll");

    clearTimeout(scrollTimeout);
    scrollTimeout = setTimeout(() => {
      // 스크롤 종료 후 약간 지연된 상태 (500ms)
      window.flutter_inappwebview.callHandler("onScrollEnd");
    }, 500);
  });

  document.addEventListener('touchend', function (e) {
    if (!isScrolling) {
      // 터치 후 스크롤 없었으면 → 클릭/탭으로 간주
      window.flutter_inappwebview.callHandler("onTap", {
        x: e.changedTouches[0].clientX,
        y: e.changedTouches[0].clientY
      });
    }
  });

  document.addEventListener('scroll', function (e) {
    window.flutter_inappwebview.callHandler("onScroll");
  });