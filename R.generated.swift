//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import RswiftResources

private class BundleFinder {}
let R = _R(bundle: Bundle(for: BundleFinder.self))

struct _R {
  let bundle: Foundation.Bundle
  var string: string { .init(bundle: bundle, preferredLanguages: nil, locale: nil) }
  var color: color { .init(bundle: bundle) }
  var image: image { .init(bundle: bundle) }
  var font: font { .init(bundle: bundle) }
  var file: file { .init(bundle: bundle) }

  func string(bundle: Foundation.Bundle) -> string {
    .init(bundle: bundle, preferredLanguages: nil, locale: nil)
  }
  func string(locale: Foundation.Locale) -> string {
    .init(bundle: bundle, preferredLanguages: nil, locale: locale)
  }
  func string(preferredLanguages: [String], locale: Locale? = nil) -> string {
    .init(bundle: bundle, preferredLanguages: preferredLanguages, locale: locale)
  }
  func color(bundle: Foundation.Bundle) -> color {
    .init(bundle: bundle)
  }
  func image(bundle: Foundation.Bundle) -> image {
    .init(bundle: bundle)
  }
  func font(bundle: Foundation.Bundle) -> font {
    .init(bundle: bundle)
  }
  func file(bundle: Foundation.Bundle) -> file {
    .init(bundle: bundle)
  }
  func validate() throws {
    try self.font.validate()
  }

  struct project {
    let developmentRegion = "en"
  }

  /// This `_R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    let bundle: Foundation.Bundle
    let preferredLanguages: [String]?
    let locale: Locale?
    var localizable: localizable { .init(source: .init(bundle: bundle, tableName: "Localizable", preferredLanguages: preferredLanguages, locale: locale)) }

    func localizable(preferredLanguages: [String]) -> localizable {
      .init(source: .init(bundle: bundle, tableName: "Localizable", preferredLanguages: preferredLanguages, locale: locale))
    }


    /// This `_R.string.localizable` struct is generated, and contains static references to 33 localization keys.
    struct localizable {
      let source: RswiftResources.StringResource.Source

      /// en translation: 알림 설정
      ///
      /// Key: add_schedule_alarm
      ///
      /// Locales: en
      var add_schedule_alarm: RswiftResources.StringResource { .init(key: "add_schedule_alarm", tableName: "Localizable", source: source, developmentValue: "알림 설정", comment: nil) }

      /// en translation: 일정 컬러
      ///
      /// Key: add_schedule_color
      ///
      /// Locales: en
      var add_schedule_color: RswiftResources.StringResource { .init(key: "add_schedule_color", tableName: "Localizable", source: source, developmentValue: "일정 컬러", comment: nil) }

      /// en translation: 종료일 설정
      ///
      /// Key: add_schedule_end_date
      ///
      /// Locales: en
      var add_schedule_end_date: RswiftResources.StringResource { .init(key: "add_schedule_end_date", tableName: "Localizable", source: source, developmentValue: "종료일 설정", comment: nil) }

      /// en translation: 종료 시간
      ///
      /// Key: add_schedule_end_time
      ///
      /// Locales: en
      var add_schedule_end_time: RswiftResources.StringResource { .init(key: "add_schedule_end_time", tableName: "Localizable", source: source, developmentValue: "종료 시간", comment: nil) }

      /// en translation: 메모
      ///
      /// Key: add_schedule_memo
      ///
      /// Locales: en
      var add_schedule_memo: RswiftResources.StringResource { .init(key: "add_schedule_memo", tableName: "Localizable", source: source, developmentValue: "메모", comment: nil) }

      /// en translation: 시작 시간
      ///
      /// Key: add_schedule_start_time
      ///
      /// Locales: en
      var add_schedule_start_time: RswiftResources.StringResource { .init(key: "add_schedule_start_time", tableName: "Localizable", source: source, developmentValue: "시작 시간", comment: nil) }

      /// en translation: 시간 설정
      ///
      /// Key: add_schedule_time
      ///
      /// Locales: en
      var add_schedule_time: RswiftResources.StringResource { .init(key: "add_schedule_time", tableName: "Localizable", source: source, developmentValue: "시간 설정", comment: nil) }

      /// en translation: 일정 추가
      ///
      /// Key: add_schedule_title
      ///
      /// Locales: en
      var add_schedule_title: RswiftResources.StringResource { .init(key: "add_schedule_title", tableName: "Localizable", source: source, developmentValue: "일정 추가", comment: nil) }

      /// en translation: 일정 제목을 입력해 주세요
      ///
      /// Key: add_schedule_title_placeholder
      ///
      /// Locales: en
      var add_schedule_title_placeholder: RswiftResources.StringResource { .init(key: "add_schedule_title_placeholder", tableName: "Localizable", source: source, developmentValue: "일정 제목을 입력해 주세요", comment: nil) }

      /// en translation: 그레이
      ///
      /// Key: color_gray
      ///
      /// Locales: en
      var color_gray: RswiftResources.StringResource { .init(key: "color_gray", tableName: "Localizable", source: source, developmentValue: "그레이", comment: nil) }

      /// en translation: 그린
      ///
      /// Key: color_primary
      ///
      /// Locales: en
      var color_primary: RswiftResources.StringResource { .init(key: "color_primary", tableName: "Localizable", source: source, developmentValue: "그린", comment: nil) }

      /// en translation: 핑크
      ///
      /// Key: color_secondary
      ///
      /// Locales: en
      var color_secondary: RswiftResources.StringResource { .init(key: "color_secondary", tableName: "Localizable", source: source, developmentValue: "핑크", comment: nil) }

      /// en translation: 완료
      ///
      /// Key: common_complete
      ///
      /// Locales: en
      var common_complete: RswiftResources.StringResource { .init(key: "common_complete", tableName: "Localizable", source: source, developmentValue: "완료", comment: nil) }

      /// en translation: 확인
      ///
      /// Key: common_confirm
      ///
      /// Locales: en
      var common_confirm: RswiftResources.StringResource { .init(key: "common_confirm", tableName: "Localizable", source: source, developmentValue: "확인", comment: nil) }

      /// en translation: 다음
      ///
      /// Key: common_next
      ///
      /// Locales: en
      var common_next: RswiftResources.StringResource { .init(key: "common_next", tableName: "Localizable", source: source, developmentValue: "다음", comment: nil) }

      /// en translation: 완료
      ///
      /// Key: complete_text
      ///
      /// Locales: en
      var complete_text: RswiftResources.StringResource { .init(key: "complete_text", tableName: "Localizable", source: source, developmentValue: "완료", comment: nil) }

      /// en translation: 내용을 입력하세요
      ///
      /// Key: diary_edit_text
      ///
      /// Locales: en
      var diary_edit_text: RswiftResources.StringResource { .init(key: "diary_edit_text", tableName: "Localizable", source: source, developmentValue: "내용을 입력하세요", comment: nil) }

      /// en translation: 일기 쓰기
      ///
      /// Key: diary_note
      ///
      /// Locales: en
      var diary_note: RswiftResources.StringResource { .init(key: "diary_note", tableName: "Localizable", source: source, developmentValue: "일기 쓰기", comment: nil) }

      /// en translation:  장소, 주소를 입력해주세요
      ///
      /// Key: diary_place_address_title
      ///
      /// Locales: en
      var diary_place_address_title: RswiftResources.StringResource { .init(key: "diary_place_address_title", tableName: "Localizable", source: source, developmentValue: " 장소, 주소를 입력해주세요", comment: nil) }

      /// en translation: 장소 선택
      ///
      /// Key: diary_select_place
      ///
      /// Locales: en
      var diary_select_place: RswiftResources.StringResource { .init(key: "diary_select_place", tableName: "Localizable", source: source, developmentValue: "장소 선택", comment: nil) }

      /// en translation: 제목
      ///
      /// Key: diary_title
      ///
      /// Locales: en
      var diary_title: RswiftResources.StringResource { .init(key: "diary_title", tableName: "Localizable", source: source, developmentValue: "제목", comment: nil) }

      /// en translation: 캘린더
      ///
      /// Key: main_tab_calendar
      ///
      /// Locales: en
      var main_tab_calendar: RswiftResources.StringResource { .init(key: "main_tab_calendar", tableName: "Localizable", source: source, developmentValue: "캘린더", comment: nil) }

      /// en translation: 홈
      ///
      /// Key: main_tab_home
      ///
      /// Locales: en
      var main_tab_home: RswiftResources.StringResource { .init(key: "main_tab_home", tableName: "Localizable", source: source, developmentValue: "홈", comment: nil) }

      /// en translation: 마이페이지
      ///
      /// Key: main_tab_my_page
      ///
      /// Locales: en
      var main_tab_my_page: RswiftResources.StringResource { .init(key: "main_tab_my_page", tableName: "Localizable", source: source, developmentValue: "마이페이지", comment: nil) }

      /// en translation: 일기 작성
      ///
      /// Key: main_tab_note
      ///
      /// Locales: en
      var main_tab_note: RswiftResources.StringResource { .init(key: "main_tab_note", tableName: "Localizable", source: source, developmentValue: "일기 작성", comment: nil) }

      /// en translation: 러브버드가 기념일을 계산해서 알려드릴게요
      ///
      /// Key: onboarding_date_description
      ///
      /// Locales: en
      var onboarding_date_description: RswiftResources.StringResource { .init(key: "onboarding_date_description", tableName: "Localizable", source: source, developmentValue: "러브버드가 기념일을 계산해서 알려드릴게요", comment: nil) }

      /// en translation: 초기화
      ///
      /// Key: onboarding_date_initial
      ///
      /// Locales: en
      var onboarding_date_initial: RswiftResources.StringResource { .init(key: "onboarding_date_initial", tableName: "Localizable", source: source, developmentValue: "초기화", comment: nil) }

      /// en translation: 연인과 사랑을 시작한 날짜를 알려주세요
      ///
      /// Key: onboarding_date_title
      ///
      /// Locales: en
      var onboarding_date_title: RswiftResources.StringResource { .init(key: "onboarding_date_title", tableName: "Localizable", source: source, developmentValue: "연인과 사랑을 시작한 날짜를 알려주세요", comment: nil) }

      /// en translation: 사용 가능한 애칭이에요
      ///
      /// Key: onboarding_nickname_correct
      ///
      /// Locales: en
      var onboarding_nickname_correct: RswiftResources.StringResource { .init(key: "onboarding_nickname_correct", tableName: "Localizable", source: source, developmentValue: "사용 가능한 애칭이에요", comment: nil) }

      /// en translation: 애칭이 없다면 이름 또는 별명을 알려주셔도 좋아요
      ///
      /// Key: onboarding_nickname_description
      ///
      /// Locales: en
      var onboarding_nickname_description: RswiftResources.StringResource { .init(key: "onboarding_nickname_description", tableName: "Localizable", source: source, developmentValue: "애칭이 없다면 이름 또는 별명을 알려주셔도 좋아요", comment: nil) }

      /// en translation: 한글 또는 영어 2-20글자 이내로 입력해 주세요
      ///
      /// Key: onboarding_nickname_edit
      ///
      /// Locales: en
      var onboarding_nickname_edit: RswiftResources.StringResource { .init(key: "onboarding_nickname_edit", tableName: "Localizable", source: source, developmentValue: "한글 또는 영어 2-20글자 이내로 입력해 주세요", comment: nil) }

      /// en translation: 잘못된 형식의 애칭이에요
      ///
      /// Key: onboarding_nickname_error
      ///
      /// Locales: en
      var onboarding_nickname_error: RswiftResources.StringResource { .init(key: "onboarding_nickname_error", tableName: "Localizable", source: source, developmentValue: "잘못된 형식의 애칭이에요", comment: nil) }

      /// en translation: 당신의 애칭을 알려주세요
      ///
      /// Key: onboarding_nickname_title
      ///
      /// Locales: en
      var onboarding_nickname_title: RswiftResources.StringResource { .init(key: "onboarding_nickname_title", tableName: "Localizable", source: source, developmentValue: "당신의 애칭을 알려주세요", comment: nil) }
    }
  }

  /// This `_R.color` struct is generated, and contains static references to 25 colors.
  struct color {
    let bundle: Foundation.Bundle

    /// Color `AccentColor`.
    var accentColor: RswiftResources.ColorResource { .init(name: "AccentColor", path: [], bundle: bundle) }

    /// Color `Error`.
    var error: RswiftResources.ColorResource { .init(name: "Error", path: [], bundle: bundle) }

    /// Color `Gray01`.
    var gray01: RswiftResources.ColorResource { .init(name: "Gray01", path: [], bundle: bundle) }

    /// Color `Gray02`.
    var gray02: RswiftResources.ColorResource { .init(name: "Gray02", path: [], bundle: bundle) }

    /// Color `Gray03`.
    var gray03: RswiftResources.ColorResource { .init(name: "Gray03", path: [], bundle: bundle) }

    /// Color `Gray04`.
    var gray04: RswiftResources.ColorResource { .init(name: "Gray04", path: [], bundle: bundle) }

    /// Color `Gray05`.
    var gray05: RswiftResources.ColorResource { .init(name: "Gray05", path: [], bundle: bundle) }

    /// Color `Gray06`.
    var gray06: RswiftResources.ColorResource { .init(name: "Gray06", path: [], bundle: bundle) }

    /// Color `Gray07`.
    var gray07: RswiftResources.ColorResource { .init(name: "Gray07", path: [], bundle: bundle) }

    /// Color `Gray08`.
    var gray08: RswiftResources.ColorResource { .init(name: "Gray08", path: [], bundle: bundle) }

    /// Color `Gray09`.
    var gray09: RswiftResources.ColorResource { .init(name: "Gray09", path: [], bundle: bundle) }

    /// Color `Gray10`.
    var gray10: RswiftResources.ColorResource { .init(name: "Gray10", path: [], bundle: bundle) }

    /// Color `Gray11`.
    var gray11: RswiftResources.ColorResource { .init(name: "Gray11", path: [], bundle: bundle) }

    /// Color `Gray115`.
    var gray115: RswiftResources.ColorResource { .init(name: "Gray115", path: [], bundle: bundle) }

    /// Color `Gray12`.
    var gray12: RswiftResources.ColorResource { .init(name: "Gray12", path: [], bundle: bundle) }

    /// Color `Gray122`.
    var gray122: RswiftResources.ColorResource { .init(name: "Gray122", path: [], bundle: bundle) }

    /// Color `Gray231`.
    var gray231: RswiftResources.ColorResource { .init(name: "Gray231", path: [], bundle: bundle) }

    /// Color `Gray251`.
    var gray251: RswiftResources.ColorResource { .init(name: "Gray251", path: [], bundle: bundle) }

    /// Color `Green164`.
    var green164: RswiftResources.ColorResource { .init(name: "Green164", path: [], bundle: bundle) }

    /// Color `Green193`.
    var green193: RswiftResources.ColorResource { .init(name: "Green193", path: [], bundle: bundle) }

    /// Color `Green218`.
    var green218: RswiftResources.ColorResource { .init(name: "Green218", path: [], bundle: bundle) }

    /// Color `Green234`.
    var green234: RswiftResources.ColorResource { .init(name: "Green234", path: [], bundle: bundle) }

    /// Color `Green246`.
    var green246: RswiftResources.ColorResource { .init(name: "Green246", path: [], bundle: bundle) }

    /// Color `Primary`.
    var primary: RswiftResources.ColorResource { .init(name: "Primary", path: [], bundle: bundle) }

    /// Color `Secondary`.
    var secondary: RswiftResources.ColorResource { .init(name: "Secondary", path: [], bundle: bundle) }
  }

  /// This `_R.image` struct is generated, and contains static references to 20 images.
  struct image {
    let bundle: Foundation.Bundle

    /// Image `ic_arrow_drop_down`.
    var ic_arrow_drop_down: RswiftResources.ImageResource { .init(name: "ic_arrow_drop_down", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_back`.
    var ic_back: RswiftResources.ImageResource { .init(name: "ic_back", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_calendar`.
    var ic_calendar: RswiftResources.ImageResource { .init(name: "ic_calendar", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_check_circle`.
    var ic_check_circle: RswiftResources.ImageResource { .init(name: "ic_check_circle", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_filter_list`.
    var ic_filter_list: RswiftResources.ImageResource { .init(name: "ic_filter_list", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_list_bulleted`.
    var ic_list_bulleted: RswiftResources.ImageResource { .init(name: "ic_list_bulleted", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_map`.
    var ic_map: RswiftResources.ImageResource { .init(name: "ic_map", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_navigate_next`.
    var ic_navigate_next: RswiftResources.ImageResource { .init(name: "ic_navigate_next", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_navigate_next_active`.
    var ic_navigate_next_active: RswiftResources.ImageResource { .init(name: "ic_navigate_next_active", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_navigate_next_inactive`.
    var ic_navigate_next_inactive: RswiftResources.ImageResource { .init(name: "ic_navigate_next_inactive", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_navigate_previous_active`.
    var ic_navigate_previous_active: RswiftResources.ImageResource { .init(name: "ic_navigate_previous_active", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_navigate_previous_inactive`.
    var ic_navigate_previous_inactive: RswiftResources.ImageResource { .init(name: "ic_navigate_previous_inactive", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_note`.
    var ic_note: RswiftResources.ImageResource { .init(name: "ic_note", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_notification`.
    var ic_notification: RswiftResources.ImageResource { .init(name: "ic_notification", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_person`.
    var ic_person: RswiftResources.ImageResource { .init(name: "ic_person", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_place`.
    var ic_place: RswiftResources.ImageResource { .init(name: "ic_place", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_plus`.
    var ic_plus: RswiftResources.ImageResource { .init(name: "ic_plus", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_search`.
    var ic_search: RswiftResources.ImageResource { .init(name: "ic_search", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_search_primary`.
    var ic_search_primary: RswiftResources.ImageResource { .init(name: "ic_search_primary", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_timeline`.
    var ic_timeline: RswiftResources.ImageResource { .init(name: "ic_timeline", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }
  }

  /// This `_R.font` struct is generated, and contains static references to 3 fonts.
  struct font: Sequence {
    let bundle: Foundation.Bundle

    /// Font `Pretendard-Bold`.
    var pretendardBold: RswiftResources.FontResource { .init(name: "Pretendard-Bold", bundle: bundle, filename: "Pretendard-Bold.otf") }

    /// Font `Pretendard-Regular`.
    var pretendardRegular: RswiftResources.FontResource { .init(name: "Pretendard-Regular", bundle: bundle, filename: "Pretendard-Regular.otf") }

    /// Font `Pretendard-SemiBold`.
    var pretendardSemiBold: RswiftResources.FontResource { .init(name: "Pretendard-SemiBold", bundle: bundle, filename: "Pretendard-SemiBold.otf") }

    func makeIterator() -> IndexingIterator<[RswiftResources.FontResource]> {
      [pretendardBold, pretendardRegular, pretendardSemiBold].makeIterator()
    }
    func validate() throws {
      for font in self {
        if !font.canBeLoaded() { throw RswiftResources.ValidationError("[R.swift] Font '\(font.name)' could not be loaded, is '\(font.filename)' added to the UIAppFonts array in this targets Info.plist?") }
      }
    }
  }

  /// This `_R.file` struct is generated, and contains static references to 3 resource files.
  struct file {
    let bundle: Foundation.Bundle

    /// Resource file `Pretendard-Bold.otf`.
    var pretendardBoldOtf: RswiftResources.FileResource { .init(name: "Pretendard-Bold", pathExtension: "otf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Pretendard-Regular.otf`.
    var pretendardRegularOtf: RswiftResources.FileResource { .init(name: "Pretendard-Regular", pathExtension: "otf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Pretendard-SemiBold.otf`.
    var pretendardSemiBoldOtf: RswiftResources.FileResource { .init(name: "Pretendard-SemiBold", pathExtension: "otf", bundle: bundle, locale: LocaleReference.none) }
  }
}