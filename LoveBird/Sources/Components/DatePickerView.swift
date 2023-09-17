//
//  CustomPickerView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import Combine
import UIKit
import ComposableArchitecture

struct DatePickerView: UIViewRepresentable {

  private enum Constant {
    static let fromYear = 1950
  }

  @Binding var date: SimpleDate

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIView(context: Context) -> UIPickerView {
    let picker = UIPickerView()
    picker.dataSource = context.coordinator
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIView(_ uiView: UIPickerView, context: Context) {
    uiView.selectRow(self.date.year - Constant.fromYear, inComponent: 0, animated: false)
    uiView.selectRow(self.date.month - 1, inComponent: 1, animated: false)
    uiView.selectRow(self.date.day - 1, inComponent: 2, animated: false)
    // TODO: 원인 정확히 파악해보기
    DispatchQueue.main.async {
      uiView.reloadAllComponents()
    }
  }
  
  final class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var parent: DatePickerView
    
    init(_ parent: DatePickerView) {
      self.parent = parent
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch component {
      case 0:
        return Date().year - Constant.fromYear + 1 // 1950부터 현재 연도까지

      case 1:
        let months = Date.with(year: self.parent.date.year).calculateMonths
//        // Ex) 2022년 12월인 상태에서 연도를 2023년으로 바꿀 때 현재가 6월인 경우 month값이 변화한다.
        if months < self.parent.date.month {
          self.parent.date.month = months
        }
        return months

      case 2:
        let days = Date.with(
          year: self.parent.date.year,
          month: self.parent.date.month
        ).calculateDaysInOnBoarding
        // Ex) 12월 31일인 상태에서 월을 11월으로 바꿀 때 days가 30으로 변화하기 때문에
        // 자연스럽게 선택 일이 30일로 맞춰진다.
        if days < self.parent.date.day {
          self.parent.date.day = days
        }
        return days

      default:
        fatalError("Invalid component")
      }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      switch component {
      case 0:
        return String(Constant.fromYear + row)

      case 1:
        return String(1 + row)

      case 2:
        return String(1 + row)

      default:
        fatalError("Invalid component")
      }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch component {
      case 0:
        let year = Constant.fromYear + row
        self.parent.date.year = year

      case 1:
        let month = 1 + row
        self.parent.date.month = month

      case 2:
        let day = 1 + row
        self.parent.date.day = day

      default:
        break
      }
    }
  }
}
