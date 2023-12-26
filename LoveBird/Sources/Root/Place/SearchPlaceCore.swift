//
//  SearchPlaceCore.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI

typealias SearchPlaceState = SearchPlaceCore.State
typealias SearchPlaceAction = SearchPlaceCore.Action

struct SearchPlaceCore: Reducer {
  struct State: Equatable {
    var places: [Place] = []
    var searchTerm: String = ""
    var select: String = ""
  }
  
  enum Action: Equatable {
    case termEdited(String)
    case selectPlace(String)
    case changePlaceInfo([Place])
    case backTapped
    case completeTapped(String)
    case fetchPlacesResponse(TaskResult<[Place]>)

    case delegate(Delegate)
    enum Delegate: Equatable {
      case updatePlace(String)
    }
  }
  
  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.dismiss) private var dismiss

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .termEdited(searchTerm):
        state.searchTerm = searchTerm
        return .run { send in
          await send(
            .fetchPlacesResponse(
              await TaskResult {
                try await lovebirdApi.fetchPlaces(places: .init(query: searchTerm))
              }
            )
          )
        }

      case let .fetchPlacesResponse(.success(places)):
        state.places = places
        return .none

      case let .fetchPlacesResponse(.failure(error)):
        print("SearchPlace Error: \(error)")
        return .none

      case let .selectPlace(place), let .completeTapped(place):
        Task { await dismiss() }
        return .send(.delegate(.updatePlace(place)))

      case .backTapped:
        return .run { _ in await dismiss() }

      default:
        return .none
      }
    }
  }
}



