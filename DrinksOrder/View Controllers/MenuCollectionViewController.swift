//
//  MenuCollectionViewController.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/6.
//

import UIKit

private let reuseIdentifier = "MenuCollectionViewCell"

class MenuCollectionViewController: UICollectionViewController {
    
    var menuDatas = [Record]()
    let urlStr = "https://api.airtable.com/v0/applCv7lC3Bj6ZVD1/Menu?sort[][field]=createdtime"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuController.shared.fetchData(urlStr: urlStr) { (result) in
            switch result {
            case .success(let menuDatas):
                self.updateUI(with: menuDatas)
                print("Fetch data success")
            case .failure(let error):
                self.displayError(error, title: "Failed to fetch the data!")
            }
        }
        
        let barButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        let image = UIImage(systemName: "arrow.backward")
        let barAppearance = UINavigationBarAppearance()
        barAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
    }
    
    func updateUI(with menuData: [Record]) {
        DispatchQueue.main.async {
            self.menuDatas = menuData
            self.collectionView.reloadData()
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let selectedItem = collectionView.indexPath(for: cell)?.row,
           let controller = segue.destination as? OrderTableViewController {
            let menuData = menuDatas[selectedItem]
            controller.menuDatas = menuData
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuDatas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MenuCollectionViewCell
        let menuData = menuDatas[indexPath.row]
        cell.drinkLabel.text = menuData.fields.name
        let imageUrl = menuData.fields.image[0].url
        MenuController.shared.fetchImage(url: imageUrl) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                cell.drinkImageView.image = image
            }
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
