//
//  CustomPickerView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import UIKit

struct CustomPickerView: UIViewRepresentable {
    @Binding var selectedDate: DateComponents

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
        uiView.selectRow(selectedDate.year! - 2000, inComponent: 0, animated: false)
        uiView.selectRow(selectedDate.month! - 1, inComponent: 1, animated: false)
        uiView.selectRow(selectedDate.day! - 1, inComponent: 2, animated: false)
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomPickerView

        init(_ parent: CustomPickerView) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0: return 100 // Years from 2000 to 2099
            case 1: return 12 // Months
            case 2: return 31 // Days
            default: fatalError("Invalid component")
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0: return String(2000 + row)
            case 1: return String(1 + row)
            case 2: return String(1 + row)
            default: fatalError("Invalid component")
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0: parent.selectedDate.year = 2000 + row
            case 1: parent.selectedDate.month = 1 + row
            case 2: parent.selectedDate.day = 1 + row
            default: break
            }
        }
    }
}
