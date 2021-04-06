//
//  likedPageCollectionViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//

import UIKit

class likedPageCollectionViewController: UICollectionViewController {

    //dummy data for now
    let postTitle =  ["Tomato Egg", "Egg Tomato"]
    let postImage = #imageLiteral(resourceName: "egg_tomato.jpeg")
    let postDescript = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. "


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        navigationItem.title = "Your liked Recipes"
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showLiked"{
            let detail = segue.destination as! likedDetailViewController
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
        if let content = collectionView.dequeueReusableCell(withReuseIdentifier: "likedCell", for: indexPath) as? likedCollectionViewCell{
            content.configure(title, postImage)
            cell = content
        }

        return cell
    }


}
