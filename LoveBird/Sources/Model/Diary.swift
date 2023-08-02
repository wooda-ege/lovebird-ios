//
//  Diary.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/27.
//

import Foundation

struct Diary: Equatable, Identifiable {
  
  enum TimeState {
    case previous
    case current
    case following
  }
  
  let id: Int
  var type: HomeItem.ContentType
  let year: Int
  let month: Int
  let day: Int
  let weekday: String
  let title: String
  let description: String
  let location: String
  let timeState: TimeState
  //    let description: String
  //    let image: Image
  
  static let dummy: [Self] = [
    Diary(id: 0, type: .initial, year: 2021, month: 9, day: 21, weekday: "", title: "", description: "", location: "", timeState: .previous),
    Diary(id: 1, type: .empty, year: 2022, month: 4, day: 44, weekday: "wed", title: "", description: "", location: "", timeState: .previous),
    Diary(id: 2, type: .fold, year: 2022, month: 5, day: 21, weekday: "sun", title: "두껍삼 역삼직영점", description: "오늘은 오랜만에 여의도 한강공원에 갔다. 근처 카페에서 피크닉 세트도 빌렸당! (요즘엔 이런게 참 잘 되어있는 것 같다..굳) 남자친구가 도시락을", location: "여의도 한강공원", timeState: .previous),
    Diary(id: 3, type: .unfold, year: 2022, month: 9, day: 21, weekday: "", title: "한강 간 날!", description: "오늘은 오랜만에 여의도 한강공원에 갔다. 근처 카페에서 피크닉 세트도 빌렸당! (요즘엔 이런게 참 잘 되어있는 것 같다..굳) 남자친구가 도시락을", location: "여의도 한강공원", timeState: .current),
    Diary(id: 4, type: .anniversary, year: 2022, month: 9, day: 15, weekday: "", title: "6주년", description: "", location: "", timeState: .following)
  ]
}
