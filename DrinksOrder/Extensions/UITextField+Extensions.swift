//
//  UITextField+Extensions.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/14.
//

import Foundation
import UIKit

extension OrderTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setPickerView(selectedAt: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}
