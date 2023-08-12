//
//  ScheduleAddTimePickerView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/02.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct ScheduleAddTimePickerView: UIViewRepresentable {

  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>

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
    uiView.selectRow((self.viewStore.time.hour + 11) % 12, inComponent: 0, animated: false)
    uiView.selectRow(self.viewStore.time.minute, inComponent: 1, animated: false)
    uiView.selectRow(self.viewStore.time.meridiem == .am ? 0 : 1, inComponent: 2, animated: false)
    uiView.reloadAllComponents()
  }

  final class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var parent: ScheduleAddTimePickerView

    init(_ parent: ScheduleAddTimePickerView) {
      self.parent = parent
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch component {
      case 0:
        return 12
      case 1:
        return 60
      case 2:
        return 2
      default:
        fatalError("Invalid component")
      }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      switch component {
      case 0:
        return String(row + 1)
      case 1:
        return row.toAddScheduleMinuteFormat
      case 2:
        return String(row == 0 ? "AM" : "PM")
      default:
        fatalError("Invalid component")
      }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch component {
      case 0:
        self.parent.viewStore.send(.hourSelected(1 + row))
      case 1:
        self.parent.viewStore.send(.minuteSelected(1 + row))
      case 2:
        self.parent.viewStore.send(.meridiemSelected(row == 0 ? .am : .pm))
      default:
        break
      }
    }
  }
}
