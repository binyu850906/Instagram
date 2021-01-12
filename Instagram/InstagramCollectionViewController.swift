//
//  InstagramCollectionViewController.swift
//  Instagram
//
//  Created by binyu on 2021/1/6.
//

import UIKit

private let reuseIdentifier = "InstagramCollectionViewCell"

class InstagramCollectionViewController: UICollectionViewController {
    var instagramData: IGUser?
    var instagramPostPicture =  [IGUser.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fetchInstagram()
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return instagramPostPicture.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? InstragramCollectionViewCell
        else{return UICollectionViewCell()
        }
    
        
        let item = instagramPostPicture[indexPath.item]
        
        URLSession.shared.dataTask(with: item.node.display_url) { (data, urlresponse, error) in
            if let data = data{
                DispatchQueue.main.async {
                    cell.showImagesView.image = UIImage(data: data)
                }
            }
        }.resume()
    
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
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let resuableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InstagramHeaderCollectionViewReusableView", for: indexPath) as? InstagramCollectionReusableView else {return UICollectionReusableView()}
        //Fetch Profile Image
        if let profilPicUrl = self.instagramData?.graphql.user.profile_pic_url_hd {
            URLSession.shared.dataTask(with: profilPicUrl) { (data, response, error) in
                if let data = data{
                    do {
                        DispatchQueue.main.async {
                            resuableView.userPhotoImageView.layer.cornerRadius = resuableView.userPhotoImageView.frame.width / 2
                            resuableView.userPhotoImageView.image = UIImage(data: data)
                        }
                    } catch  {
                        print("error")
                    }
                }
            }.resume()
        }
        
        if let postsCount = self.instagramData?.graphql.user.edge_owner_to_timeline_media.count,
            let followCount = self.instagramData?.graphql.user.edge_followed_by.count,
            let followingCount = self.instagramData?.graphql.user.edge_follow.count,
            let fullName = self.instagramData?.graphql.user.full_name,
            let biography = self.instagramData?.graphql.user.biography
        {
            resuableView.postsLabel.text = NumCoverter(postsCount)

            resuableView.fansLabel.text = NumCoverter(followCount)
            
            resuableView.followingLabel.text = NumCoverter(followingCount)

            resuableView.nameLabel.text = "\(fullName)"
            
            resuableView.blogintroductionTextView.isEditable = false
            resuableView.blogintroductionTextView.text = "\(biography)"
            
        }
        
        return resuableView
    }
    
    func fetchInstagram() {
        let urlStr =  "https://www.instagram.com/hsin0126/?__a=1"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                if let data = data{
                    do {
                        let searchResponse = try decoder.decode(IGUser.self, from: data)
                        self.instagramData = searchResponse
                        DispatchQueue.main.async {
                            self.collatingOfData()
                            self.navigationItem.title = self.instagramData?.graphql.user.username
                            self.navigationItem.backButtonTitle = "Profile"
                            self.collectionView.reloadData()
                        }
                    } catch  {
                        print("error")
                    }
                    
                }
                else{
                    print("error")
                }
            }.resume()
        }
    }
    
    
    func collatingOfData(){
        self.instagramPostPicture = (self.instagramData?.graphql.user.edge_owner_to_timeline_media.edges)!
    }
}

