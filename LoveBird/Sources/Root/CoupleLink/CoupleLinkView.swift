//
//  CoupleLinkView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/07/04.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct CoupleLinkView: View {
  
  let store: StoreOf<CoupleLinkCore>
  @FocusState private var isEmailFieldFocused: Bool
  @StateObject private var keyboard = KeyboardResponder()
  @State var showShare: Bool = false
  var invitationCode: String = ""

  init(store: StoreOf<CoupleLinkCore>) {
    self.store = store
  }

  var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        Spacer().frame(height: 24)
        
        Text(LoveBirdStrings.onboardingInvitationTitle)
          .font(.pretendard(size: 20, weight: .bold))
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 16)

        Text(LoveBirdStrings.onboardingInvitationDescription)
          .font(.pretendard(size: 16, weight: .regular))
          .foregroundColor(Color(asset: LoveBirdAsset.gray07))
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 12)
          .padding(.leading, 16)
        
        Spacer().frame(height: 48)
    
        HStack {
          Text(viewStore.invitationCode)
            .font(.pretendard(size: 16, weight: .semiBold))
            .foregroundColor(.black)
            .lineLimit(1)
          
          Spacer()
          
          TouchableStack {
            Text("공유")
              .font(.pretendard(size: 14, weight: .bold))
              .foregroundColor(.white)
          }
          .frame(width: 48, height: 32)
          .roundedBackground(cornerRadius: 8, color: .black)
          .background(.black)
          .cornerRadius(8)
          .padding(.trailing, 32)
          .onTapGesture {
            showShare = true
          }
          .sheet(isPresented: $showShare) {
            ActivityViewController(activityItems: [viewStore.invitationCode])
          }
        }
        .cornerRadius(12)
        .padding(.leading, 16)
        .frame(height: 56)
        .frame(width: UIScreen.width - 32)
        .roundedBackground(cornerRadius: 12, color: Color(asset: LoveBirdAsset.gray07))
        
        
        Spacer()
          .frame(height: 53)
        
        VStack(alignment: .leading) {
          Text(LoveBirdStrings.onboardingInvitationQuestion)
            .font(.pretendard(size: 14, weight: .regular))

          let textBinding = viewStore.binding(get: \.invitationInputCode, send: CoupleLinkAction.invitationCodeEdited)
          TextField("초대코드 입력", text: textBinding)
            .font(.pretendard(size: 18, weight: .regular))
            .foregroundColor(Color(asset: LoveBirdAsset.gray07))
            .padding(.vertical, 15)
            .padding(.leading, 16)
            .padding(.trailing, 48)
            .focused($isEmailFieldFocused)
            .showClearButton(textBinding)
            .frame(width: UIScreen.width - 32)
            .roundedBackground(cornerRadius: 12, color: viewStore.textFieldState.color)
        }
        
        Spacer()
        
        Button {
          viewStore.send(.confirmButtonTapped)
          hideKeyboard()
        } label: {
          TouchableStack {
            Text(LoveBirdStrings.onboardingInvitationConnect)
              .font(.pretendard(size: 16, weight: .semiBold))
              .foregroundColor(.white)
          }
        }
        .frame(height: 56)
        .background(.black)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
      }
      .onAppear {
        viewStore.send(.viewAppear)
      }
      .background(.white)
      .onTapGesture {
        isEmailFieldFocused = false
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.white)
    }
  }
}

#Preview {
  CoupleLinkView(
    store: Store(
      initialState: CoupleLinkState(),
      reducer: { CoupleLinkCore() }
    )
  )
}

struct ActivityViewController: UIViewControllerRepresentable {
  var activityItems: [Any]
  var applicationActivities: [UIActivity]? = nil
  @Environment(\.presentationMode) var presentationMode
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>
  ) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities
    )
    controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
      presentationMode.wrappedValue.dismiss()
    }
    return controller
  }
  
  func updateUIViewController(
    _ uiViewController: UIActivityViewController,
    context: UIViewControllerRepresentableContext<ActivityViewController>
  ) {}
}

