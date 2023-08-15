//
//  DiaryDetailView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/08/12.
//

import SwiftUI

struct DiaryDetailView: View {
  let diary: Diary
  
  var body: some View {
    NavigationView {
      VStack {
        ZStack(alignment: .bottomLeading) {
          Image(uiImage: UIImage(named: diary.imgUrls.first ?? "") ?? UIImage())
            .resizable()
            .frame(width: 340, height: 200)
            .foregroundColor(.black)
            .background(.black)
            .opacity(0.7)
            .overlay(.black, in: Rectangle())
            .cornerRadius(10)
          
          Image(uiImage: UIImage(named: diary.imgUrls.first ?? "") ?? UIImage())
            .resizable()
            .frame(width: 340, height: 200)
            .opacity(0.7)
            .saturation(0.9)
          
      //        Text(diary.title)
      //          .padding(.leading, 30)
      //          .padding(.bottom, 30)
      //          .foregroundColor(.white)
      //          .font(.system(size: 20, weight: .bold))
        }
        .padding(.bottom, 10)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(diary.title))
        .navigationBarItems(trailing: Button(action: {
           
        }, label: {
          Image(R.image.ic_edit)
        }))
        
        Divider()
          .background(Color(R.color.gray04))
          .padding(.horizontal)
          .padding(.vertical, 5)
        
        HStack {
          Label {
            Text(diary.place ?? "")
          } icon : {
            Image(R.image.ic_map)
              .resizable()
              .scaledToFit()
              .frame(
                width: 15,
                height: 15)
          }
          Spacer()
        }
        .padding(.leading, 15)
        
        Divider()
          .background(Color(R.color.gray04))
          .padding(.horizontal)
          .padding(.vertical, 5)
        
        HStack {
          Text(diary.content)
          Spacer()
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        
        Spacer()
      }
      .padding(.top, 30)
    }
    
  }
}

//struct DiaryDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//
//    DiaryDetailView(diary: diaryMock)
//  }
//}

//
//let diaryMock = Diary(type: .empty, image: UIImage(systemName: "circle"), year: 6, month: 6, day: 6, weekday: "Dd", title: "300일 여행 기록", description: "남자친구와 여행을 가ㄸzzㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ", location: "제주도 목련숲", timeState: .current)
