//
//  OrderTableViewController.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/6.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    let urlStr = "https://api.airtable.com/v0/applCv7lC3Bj6ZVD1/OrderList"
    var menuDatas: Record!
    var orderDetail = [OrderDetail.Record]()

    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkDescription: UILabel!
    @IBOutlet weak var orderersNameTextField: UITextField!
    @IBOutlet weak var drinksTemperatureTextField: UITextField!
    @IBOutlet weak var drinkSweetnessTextField: UITextField!
    @IBOutlet weak var drinkSizeTextField: UITextField!
    @IBOutlet weak var toppingsTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    let pickerView = UIPickerView()
    var orderName = String()
    var temp = String()
    var sweetness = String()
    var size = String()
    var toppings = String()
    var quantity = 1
    var price = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkNameLabel.text = menuDatas.fields.name
        drinkDescription.text = menuDatas.fields.description
        //抓圖
        let imageUrl = menuDatas.fields.image[0].url
        MenuController.shared.fetchImage(url: imageUrl) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.drinkImage.image = image
            }
        }
        //設定代理人
        orderersNameTextField.delegate = self
        drinksTemperatureTextField.delegate = self
        drinkSweetnessTextField.delegate = self
        drinkSizeTextField.delegate = self
        toppingsTextField.delegate = self
        tapGesture()
        quantityLabel.text = String(quantity)
        priceLabel.text = String(price)
    }
    
    //增加一個觸控事件
    func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    //按空白處會隱藏鍵盤或pickerView
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    //設定PickerView
    func setPickerView(selectedAt sender: UITextField) {
        switch sender {
        case drinksTemperatureTextField:
            pickerView.tag = 0
        case drinkSweetnessTextField:
            pickerView.tag = 1
        case drinkSizeTextField:
            pickerView.tag = 2
        case toppingsTextField:
            pickerView.tag = 3
        default:
            break
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        //設定PickView的Toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "確認", style: .plain, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        drinksTemperatureTextField.inputView = pickerView
        drinksTemperatureTextField.inputAccessoryView = toolBar
        drinkSweetnessTextField.inputView = pickerView
        drinkSweetnessTextField.inputAccessoryView = toolBar
        drinkSizeTextField.inputView = pickerView
        if drinkNameLabel.text == "熟成檸檬" {
            drinkSizeTextField.text = Size.allCases[0].rawValue
        }
        drinkSizeTextField.inputAccessoryView = toolBar
        toppingsTextField.inputView = pickerView
        toppingsTextField.inputAccessoryView = toolBar
    }
    //確認鍵動作
    @objc func done() {
        if let orderName = orderersNameTextField.text {
            self.orderName = orderName
        }
        
        switch pickerView.tag {
        case 0:
            drinksTemperatureTextField.text = temp
            if temp.isEmpty == true {
                temp = Temperature.allCases[0].rawValue
                drinksTemperatureTextField.text = temp
            }
            drinksTemperatureTextField.resignFirstResponder()
        case 1:
            drinkSweetnessTextField.text = sweetness
            if sweetness.isEmpty == true {
                sweetness = Sweetness.allCases[0].rawValue
                drinkSweetnessTextField.text = sweetness
            }
            drinkSweetnessTextField.resignFirstResponder()
        case 2:
            drinkSizeTextField.text = size
            if size.isEmpty == true {
                size = Size.allCases[0].rawValue
                drinkSizeTextField.text = size
                price = menuDatas.fields.medium
                priceLabel.text = String(price)
            }
            drinkSizeTextField.resignFirstResponder()
        default:
            toppingsTextField.text = toppings
            if toppings.isEmpty == true {
                toppings = Toppings.allCases[0].rawValue
                toppingsTextField.text = toppings
            }
            toppingsTextField.resignFirstResponder()
        }
    }
    //取消健動作
    @objc func cancel() {
        drinksTemperatureTextField.resignFirstResponder()
        drinkSweetnessTextField.resignFirstResponder()
        drinkSizeTextField.resignFirstResponder()
        toppingsTextField.resignFirstResponder()
    }
    //減少杯數，低於1杯跳警告
    @IBAction func minusButton(_ sender: Any) {
        if quantity <= 1 {
            showAlert(title: "錯誤數量", message: "請輸入1杯以上")
        } else {
            quantity -= 1
            quantityLabel.text = String(quantity)
            priceLabel.text = String(price * quantity)
        }
    }
    //增加杯數
    @IBAction func plusButton(_ sender: Any) {
        quantity += 1
        quantityLabel.text = String(quantity)
        priceLabel.text = String(price * quantity)
    }
    //加入購物清單健
    @IBAction func submetButton(_ sender: Any) {
        let fieldData = OrderDetail.Field(drink: menuDatas.fields.name, size: size, sweetness: sweetness, quantity: quantity, price: price, toppings: toppings, name: orderName, temperature: temp, image: menuDatas.fields.image[0].url)
        let recordData = OrderDetail.Record(fields: fieldData)
        let orderDetailData = OrderDetail(records: [recordData])
        //檢查是否有沒輸入的項目
        if orderersNameTextField.text?.isEmpty == true {
            showAlert(title: "警告！", message: "請輸入訂購人名字")
        } else if drinksTemperatureTextField.text?.isEmpty == true {
            showAlert(title: "警告！", message: "請選擇飲品溫度")
        } else if drinkSweetnessTextField.text?.isEmpty == true {
            showAlert(title: "警告！", message: "請選擇飲品甜度")
        } else if drinkSizeTextField.text?.isEmpty == true {
            showAlert(title: "警告！", message: "請選擇飲品大小")
        } else if toppingsTextField.text?.isEmpty == true {
            showAlert(title: "警告！", message: "請選擇是否加料")
        } else {
            confirmOrder { _ in
                MenuController.shared.uploadData(urlStr: self.urlStr, data: orderDetailData)
                MenuController.shared.order.orders.append(recordData)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateUI(with orderDetail: [OrderDetail.Record]) {
        DispatchQueue.main.async {
            self.orderDetail = orderDetail
        }
    }
    
    //錯誤跳警告視窗
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //飲料加入訂單確認視窗
    func confirmOrder(action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "確認加入訂購清單嗎？", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: action))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */

    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
