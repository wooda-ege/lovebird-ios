//
//  CustomPickerView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import UIKit

struct CustomPickerView: UIViewRepresentable {
    
    let fromYear = 1950
    @Binding var year: Int
    @Binding var month: Int
    @Binding var day: Int

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
        uiView.selectRow(self.year - self.fromYear, inComponent: 0, animated: false)
        uiView.selectRow(self.month - 1, inComponent: 1, animated: false)
        uiView.selectRow(self.day - 1, inComponent: 2, animated: false)
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
            case 0: return Calendar.year - self.parent.fromYear + 1 // 1950부터 현재 연도까지
            case 1: return 12
            case 2: return 31
            default: fatalError("Invalid component")
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0: return String(self.parent.fromYear + row)
            case 1: return String(1 + row)
            case 2: return String(1 + row)
            default: fatalError("Invalid component")
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0: self.parent.year = self.parent.fromYear + row
            case 1: self.parent.month = 1 + row
            case 2: self.parent.day = 1 + row
            default: break
            }
        }
    }
}
