//
//  HomeCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import Foundation
import ComposableArchitecture

struct HomeCore: ReducerProtocol {
  
  struct State: Equatable {
    var diarys: [Diary] = Diary.dummy
    var offsetY: CGFloat = 0.0
  }
  
  enum Action: Equatable {
    case diaryTitleTapped(Diary)
    case diaryTapped(Diary)
    case emptyDiaryTapped
    case searchTapped
    case listTapped
    case notificationTapped
    case offsetYChanged(CGFloat)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .diaryTitleTapped(let diary):
        if let idx = state.diarys.firstIndex(where: { $0.id == diary.id }) {
          state.diarys[idx].type.toggle()
        }
      case .diaryTapped(let diary):
        return .none //TODO: 득연 - Navigation
      case .offsetYChanged(let y):
        state.offsetY = y
      default:
        break
      }
      return .none
    }
  }
}

