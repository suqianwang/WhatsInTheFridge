//
//  explorePageCollectionViewController.swift
//  whats-in-the-fridge
//
//  Created by Qintian Wu on 3/25/21.
//

import UIKit
class explorePageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    //dummy data for now
    let postTitle =  ["Tomato Egg", "Egg Tomato", "Potato beef", "Beff Potato"]
    let postImage = #imageLiteral(resourceName: "egg_tomato.jpeg")
    let postDescript = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add custom background
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
        navigationItem.title = "Recipes For You"
    }


    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let detail = segue.destination as! explorePageDetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell){
                
                detail.name = postTitle[indexPath.row]
                detail.picture = postImage
                detail.descript = postDescript
            }
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return postTitle.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        let index = indexPath.row
        let title = postTitle[index]
        if let content = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? exploreItemCollectionViewCell{
            content.configure(title, postImage)
            cell = content
        }
        
        return cell
    }

    //attempt to configure the cell size to accomodate different deviced, not done yet
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

           let screenSize : CGRect = UIScreen.main.bounds

           var widthCell = 0
           var heightCell = 0
           
           //iPhone x, 6,7,8
           if screenSize.width == 375 && screenSize.height == 667{
               widthCell = 172
               heightCell = 150
           }
            
           //iPhone 6+,6s+, 7+,8+
           if screenSize.width == 414 && screenSize.width == 736{
               widthCell = 191
               heightCell = 160
           }
        
            //iPhone 11 Pro, X, Xs
            if screenSize.width == 375 && heightCell == 812 {
                widthCell = 172
                heightCell = 170
            }

            
            //iPhone 11 Pro Max, Xs Max
            if screenSize.width == 414 && screenSize.height == 896{
            widthCell = 191
            heightCell = 190
            }
        
           //every other iphone
           if screenSize.width == 320 {
               widthCell = 144
               heightCell = 125

           }

           return CGSize(width: widthCell, height: heightCell)
       }
    

}
