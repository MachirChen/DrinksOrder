//
//  UIPickerView+Extension.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/11.
//

import Foundation
import UIKit

extension OrderTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //顯示幾列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //各列有多少行資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return Temperature.allCases.count
        case 1:
            return Sweetness.allCases.count
        case 2:
            //熟成檸果只有中杯
            if drinkNameLabel.text == "熟成檸果" {
                return 1
            } else {
                return Size.allCases.count
            }
        default:
            return Toppings.allCases.count
        }
    }
    //每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return Temperature.allCases[row].rawValue
        case 1:
            return Sweetness.allCases[row].rawValue
        case 2:
            if drinkNameLabel.text == "熟成檸果" {
                return Size.allCases[0].rawValue
            } else {
                return Size.allCases[row].rawValue
            }
        default:
            return Toppings.allCases[row].rawValue
        }
    }
    //選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            temp = Temperature.allCases[row].rawValue
        case 1:
            sweetness = Sweetness.allCases[row].rawValue
        case 2:
            if drinkNameLabel.text == "熟成檸果" {
                size = Size.allCases[0].rawValue
                price = menuDatas.fields.medium
                priceLabel.text = String(price)
            } else {
                size = Size.allCases[row].rawValue
                if row == 0 {
                    price = menuDatas.fields.medium
                    priceLabel.text = String(price)
                } else {
                    if let large = menuDatas.fields.large {
                        price = large
                        priceLabel.text = String(price)
                    }
                }
            }
        default:
            toppings = Toppings.allCases[row].rawValue
            if row == 1 {
                price += 10
                priceLabel.text = String(price)
            } else if row == 2 {
                price += 20
                priceLabel.text = String(price)
            } else {
                if drinkSizeTextField.text == "中杯" {
                    price = menuDatas.fields.medium
                    priceLabel.text = String(price)
                } else {
                    if let large = menuDatas.fields.large {
                        price = large
                        priceLabel.text = String(price)
                    }
                }
            }
        }
    }
}
