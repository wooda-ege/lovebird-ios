//
//  ContentView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

struct ContentView: View {
  @State var hourSelect = 0
  @State var minuteSelect = 0
  
  var hours = [Int](0..<24)
  var minutes = [Int](0..<60)
  
  var body: some View {
    ZStack {
      Color.black
        .opacity(0.5)
        .ignoresSafeArea()
        .preferredColorScheme(.light)
      Rectangle()
        .fill(.white.opacity(1))
        .cornerRadius(30)
        .frame(width: 300, height: 350)
      VStack {
        Text("Header")
        HStack(spacing: 0) {
          Picker(selection: $hourSelect, label: Text("")) {
            ForEach(0..<self.hours.count) { index in
              Text("\(self.hours[index])").tag(index)
            }
          }
          .pickerStyle(.wheel)
          .frame(minWidth: 0)
          .compositingGroup()
          .clipped()
          
          Picker(selection: $minuteSelect, label: Text("")) {
            ForEach(0..<self.minutes.count) { index in
              Text("\(self.minutes[index])").tag(index)
            }
          }
          .pickerStyle(.wheel)
          .frame(minWidth: 0)
          .compositingGroup()
          .clipped()
        }
      }
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
