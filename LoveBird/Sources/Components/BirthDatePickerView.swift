//
//  BirthDatePickerView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct BirthDatePickerView: UIViewRepresentable {
  
  @ObservedObject var viewStore: ViewStore<OnboardingState, OnboardingCore.Action>
  let fromYear = 1950
  let today = Date()
  
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
    uiView.selectRow(self.viewStore.birthdateYear - self.fromYear, inComponent: 0, animated: false)
      uiView.selectRow(self.viewStore.birthdateMonth - 1, inComponent: 1, animated: false)
      uiView.selectRow(self.viewStore.birthdateDay - 1, inComponent: 2, animated: false)
      uiView.reloadAllComponents()
  }
  
  final class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var parent: BirthDatePickerView
    
    init(_ parent: BirthDatePickerView) {
      self.parent = parent
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch component {
      case 0:
        return self.parent.today.year - self.parent.fromYear + 1 // 1950부터 현재 연도까지
      case 1:
        let months = Date.with(year: self.parent.viewStore.birthdateMonth).calculateMonths
        // Ex) 2022년 12월인 상태에서 연도를 2023년으로 바꿀 때 현재가 6월인 경우 month값이 변화한다.
        if months < self.parent.viewStore.birthdateMonth {
          self.parent.viewStore.send(.birthdateMonthSelected(months))
        }
        return months
      case 2:
        let days = Date.with(year: self.parent.viewStore.birthdateYear, month: self.parent.viewStore.birthdateMonth).calculateDaysInOnBoarding
        // Ex) 12월 31일인 상태에서 월을 11월으로 바꿀 때 days가 30으로 변화하기 때문에
        // 자연스럽게 선택 일이 30일로 맞춰진다.
        if days < self.parent.viewStore.birthdateDay {
          self.parent.viewStore.send(.birthdateDaySelected(days))
        }
        return days
      default:
        fatalError("Invalid component")
      }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      switch component {
      case 0:
        return String(self.parent.fromYear + row)
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
        self.parent.viewStore.send(.birthdateYearSelected(self.parent.fromYear + row))
      case 1:
        self.parent.viewStore.send(.birthdateMonthSelected(1 + row))
      case 2:
        self.parent.viewStore.send(.birthdateDaySelected(1 + row))
      default:
        break
      }
    }
  }
}

