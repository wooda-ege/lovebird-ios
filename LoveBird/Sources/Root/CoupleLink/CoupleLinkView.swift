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
  @FocusState private var isTextFieldFocused: Bool
  @StateObject private var keyboard = KeyboardResponder()

  init(store: StoreOf<CoupleLinkCore>) {
    self.store = store
  }

  var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        CommonToolBar() {
          Button { viewStore.send(.skipTapped) } label: {
            Text("건너뛰기")
              .font(.pretendard(size: 16, weight: .bold))
              .foregroundColor(Color(asset: LoveBirdAsset.primary))
          }
        }

        VStack(alignment: .leading, spacing: 0) {
          Text(LoveBirdStrings.onboardingInvitationTitle)
            .font(.pretendard(size: 20, weight: .bold))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 24)

          Spacer().frame(height: 12)

          Text(LoveBirdStrings.onboardingInvitationDescription)
            .font(.pretendard(size: 16))
            .foregroundColor(Color(asset: LoveBirdAsset.gray07))
            .frame(maxWidth: .infinity, alignment: .leading)

          Spacer().frame(height: 48)

          HStack(alignment: .center) {
            Text(viewStore.invitationCode)
              .font(.pretendard(size: 16, weight: .semiBold))
              .foregroundColor(.black)
              .lineLimit(1)

            Spacer()

            Button { viewStore.send(.shareTapped(true)) } label: {
              Text("공유")
                .font(.pretendard(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
          }
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .frame(height: 56)
          .background(Color(asset: LoveBirdAsset.gray02))
          .clipShape(RoundedRectangle(cornerRadius: 12))

          Spacer()
            .frame(height: 24)

          VStack(alignment: .leading) {
            Text(LoveBirdStrings.onboardingInvitationQuestion)
              .font(.pretendard(size: 14, weight: .regular))

            let textBinding = viewStore.binding(get: \.invitationInputCode, send: CoupleLinkAction.invitationCodeEdited)
            CommonTextField(
              text: textBinding,
              placeholder: "초대코드 입력",
              borderColor: isTextFieldFocused ? .black : Color(asset: LoveBirdAsset.gray06),
              isFocused: self.$isTextFieldFocused
            )
          }

          Spacer()

          Button {
            viewStore.send(.confirmButtonTapped)
            hideKeyboard()
          } label: {
            CenterAlignedHStack {
              Text(LoveBirdStrings.onboardingInvitationConnect)
                .font(.pretendard(size: 16, weight: .semiBold))
                .foregroundColor(.white)
            }
          }
          .frame(height: 56)
          .background(.black)
          .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
      }
      .background(.white)
      .sheet(isPresented: viewStore.binding(get: \.isShareSheetShown, send: CoupleLinkAction.shareTapped)) {
        ActivityViewController(activityItems: [viewStore.invitationCode])
      }
      .onAppear {
        viewStore.send(.viewAppear)
      }
      .onTapGesture {
        isTextFieldFocused = false
      }
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

