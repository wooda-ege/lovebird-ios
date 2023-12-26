//
//  DiaryCore.swift
//  JsonPractice
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI
import Kingfisher

struct DiaryCore: Reducer {
  struct State: Equatable {
    enum `Type` {
      case add
      case edit
    }

    init() {
      self.type = .add
    }
    
    init(diary: Diary) {
      self.type = .edit
      self.id = diary.diaryId
      self.title = diary.title
      self.content = diary.content
      self.place = diary.place ?? ""
      self.date = diary.memoryDate.toDate()
    }

    let type: `Type`
    var id: Int = 0
    var focusedType: DiaryFocusedType = .none
    var title: String = ""
    var content: String = ""
    var place: String = ""
    var date = Date()

    var isPresented = false

    var selectedImage: Data? = nil
    var isImagePickerPresented: Bool = false
    var showCalendarPreview: Bool = false
  }
  
  enum Action: Equatable {
    case dateTapped(Date)
    case titleEdited(String)
    case contentEdited(String)
    case focusedTypeChanged(DiaryFocusedType)
    case placeTapped
    case previewFollowingTapped
    case previewNextTapped
    case previewDayTapped(Date)

    case placeUpdated(String)
    case changeTextEmpty
    case completeTapped
    case addDiaryResponse(TaskResult<StatusCode>)
    case editDiaryResponse(TaskResult<StatusCode>)
    case hideDateView
    case viewInitialized
    case selectImage(Data?)
    case setImagePickerPresented(Bool)
    case backTapped

    //delegate
    case delegate(Delegate)
    enum Delegate: Equatable {
      case reloadDiary
    }
  }
  
  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData
  @Dependency(\.loadingController) var loadingController
  @Dependency(\.toastController) var toastController

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.continuousClock) var clock

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .titleEdited(let title):
        state.title = title
        return .none
        
      case .contentEdited(let content):
        state.content = content
        return .none
        
      case .changeTextEmpty:
        state.content = ""
        return .none
        
      case .focusedTypeChanged(let type):
        state.focusedType = type
        state.showCalendarPreview = type == .date
        return .none
        
      case .previewFollowingTapped:
        state.date = state.date.addMonths(by: -1)
        return .none
        
      case .previewNextTapped:
        state.date = state.date.addMonths(by: 1)
        return .none
        
      case .previewDayTapped(let date):
        state.date = date
        state.focusedType = .none
        state.showCalendarPreview = false
        return .none
        
      case .dateTapped:
        state.showCalendarPreview = true
        state.focusedType = .date
        return .none
        
      case .completeTapped:
        if state.title.isEmpty || state.content.isEmpty { return .none }
        return .run { [state] send in
          loadingController.isLoading = true
          if state.type == .add {
            await send(
              .addDiaryResponse(
                await TaskResult {
                  try await self.lovebirdApi.addDiary(
                    image: state.selectedImage,
                    diary: .init(
                      title: state.title,
                      memoryDate: state.date.to(dateFormat: Date.Format.YMDDivided),
                      place: state.place.isEmpty ? nil : state.place,
                      content: state.content
                    )
                  )
                }
              )
            )
          } else {
            await send(
              .editDiaryResponse(
                await TaskResult {
                  try await self.lovebirdApi.editDiary(
                    id: state.id,
                    image: state.selectedImage,
                    diary: .init(
                      title: state.title,
                      memoryDate: state.date.to(dateFormat: Date.Format.YMDDivided),
                      place: state.place.isEmpty ? nil : state.place,
                      content: state.content
                    )
                  )
                }
              )
            )
          }
          loadingController.isLoading = false
        }

      case let .placeUpdated(place):
        state.place = place
        return .none

      case .selectImage(let image):
        state.selectedImage = image
        return .none

      case .setImagePickerPresented(let isPresented):
        state.isImagePickerPresented = isPresented
        return .none

      case .addDiaryResponse(.success):
        state.title = ""
        state.date = Date()
        state.place = ""
        state.content = ""
        state.selectedImage = nil
        return .run { _ in
          loadingController.isLoading = false
          await toastController.showToast(message: "일기가 작성됐어요!")
        }

      case .editDiaryResponse(.success):
        return .run { send in
          await toastController.showToast(message: "일기가 수정됐어요!")
          await send(.delegate(.reloadDiary))
          await dismiss()
        }

      case .backTapped:
        return .run { _ in await dismiss()}

      default:
        return .none
      }
    }
  }
}

typealias DiaryState = DiaryCore.State
typealias DiaryAction = DiaryCore.Action
