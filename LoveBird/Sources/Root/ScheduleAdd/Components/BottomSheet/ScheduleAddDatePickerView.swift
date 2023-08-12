//
//  AddScheduleDatePickerView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct ScheduleAddDatePickerView: UIViewRepresentable {

  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>
  let fromYear = 1950
  let toYear = 2099

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
    uiView.selectRow(self.viewStore.year - self.fromYear, inComponent: 0, animated: false)
    uiView.selectRow(self.viewStore.month - 1, inComponent: 1, animated: false)
    uiView.selectRow(self.viewStore.day - 1, inComponent: 2, animated: false)
    uiView.reloadAllComponents()
  }

  final class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var parent: ScheduleAddDatePickerView

    init(_ parent: ScheduleAddDatePickerView) {
      self.parent = parent
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch component {
      case 0:
        return self.parent.toYear - self.parent.fromYear + 1 // 1950부터 현재 연도까지
      case 1:
        return 12
      case 2:
        let days = Date.with(year: self.parent.viewStore.year, month: self.parent.viewStore.month).calculateDays
        // Ex) 12월 31일인 상태에서 월을 11월으로 바꿀 때 days가 30으로 변화하기 때문에
        // 자연스럽게 선택 일이 30일로 맞춰진다.
        if days < self.parent.viewStore.day {
          self.parent.viewStore.send(.daySelected(days))
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
        self.parent.viewStore.send(.yearSelected(self.parent.fromYear + row))
      case 1:
        self.parent.viewStore.send(.monthSelected(1 + row))
      case 2:
        self.parent.viewStore.send(.daySelected(1 + row))
      default:
        break
      }
    }
  }
}
