//
//  OrderListTableViewController.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/6.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    
    var orderList = [OrderList.Record]()
    let urlStr = "https://api.airtable.com/v0/applCv7lC3Bj6ZVD1/OrderList?sort[][field]=createdtime"

    override func viewDidLoad() {
        super.viewDidLoad()
        //加入Observer坐監聽，查看是否有新增飲料訂單
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdateNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MenuController.shared.fetchOrderData(urlStr: urlStr) { (result) in
            switch result {
            case .success(let orderLists):
                self.updateUI(with: orderLists)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateUI(with orderList: [OrderList.Record]) {
        DispatchQueue.main.async {
            self.orderList = orderList
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return MenuController.shared.order.orders.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderListTableViewCell", for: indexPath) as! OrderListTableViewCell
        let orderDetail = MenuController.shared.order.orders[indexPath.section]
        MenuController.shared.fetchImage(url: orderDetail.fields.image) { (Image) in
            guard let image = Image else { return }
            DispatchQueue.main.async {
                cell.drinkImageView.image = image
            }
        }
        cell.orderNameLabel.text = orderDetail.fields.name
        cell.drinkNameLabel.text = orderDetail.fields.drink
        cell.tempLabel.text = orderDetail.fields.temperature
        cell.sweetnessLabel.text = orderDetail.fields.temperature
        cell.countLabel.text = "\(orderDetail.fields.quantity)杯"
        cell.drinkPriceLabel.text = String(orderDetail.fields.price)
        if orderDetail.fields.toppings == "無" {
            cell.toppingsLabel.text = ""
        } else {
            cell.toppingsLabel.text = "+\(orderDetail.fields.toppings)"
        }

        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let orderList = orderList[indexPath.section]
            MenuController.shared.deleteOrderData(urlStr: "https://api.airtable.com/v0/applCv7lC3Bj6ZVD1/OrderList/" + orderList.id)
            MenuController.shared.order.orders.remove(at: indexPath.section)
        }
    }

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
