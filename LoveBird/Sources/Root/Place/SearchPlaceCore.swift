//
//  SearchPlaceCore.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI

struct SearchPlaceCore: ReducerProtocol {
    struct State: Equatable {
        var placeName: String = ""
        var placeList: [PlaceInfo] = []
        var searchTerm: String = ""
    }
    
    enum SearchPlaceAction: Equatable {
        case textFieldDidEditting(String)
        case selectPlace
        case changePlaceInfo([PlaceInfo])
        case completeButtonTapped(String)
        case placeNameEdited(String)
    }
    
    var body: some ReducerProtocol<State, SearchPlaceAction> {
        Reduce { state, action in
            switch action {
            case .textFieldDidEditting(let searchTerm):
                state.searchTerm = searchTerm
            case .completeButtonTapped:
                state.placeList = []
                state.searchTerm = ""
            case .changePlaceInfo(let placeInfo):
                state.placeList = placeInfo
            case .placeNameEdited(let placeName):
                state.placeName = placeName
            default:
                break
            }
            
            return .none
        }
    }
}



