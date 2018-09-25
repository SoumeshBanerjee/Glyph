//
//  CollectionViewController.swift
//  Glyph
//
//  Created by Soumesh Banerjee on 24/09/18.
//  Copyright © 2018 Soumesh Banerjee. All rights reserved.
//

import UIKit
class CollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "Cell"
    let flickerCore = FlickerCore(endpoint: "https://api.flickr.com/services/rest", apiKey: "3e7cc266ae2b0e0d78e279ce8e361736")
    let downloadManager = DownloadManager()
    var searchResults : [FlickerPhotosSearchResponse.Photos.Photo] = []
    var searchController : UISearchController = UISearchController()
    var searchKeyword = ""
    var nextPage : Int64 = 1
    var totalPage : Int64 = 1
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //download manager setup
        let config = URLSessionConfiguration.background(withIdentifier: "com.soumesh.glyph.bgDonwloadManager")
        let session = URLSession(configuration: config, delegate: self as URLSessionDelegate, delegateQueue: nil)
        downloadManager.session = session
        
        
        self.collectionView.allowsMultipleSelection = false
        
        //set large title and search bar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        searchController = UISearchController(searchResultsController: nil)
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self as UISearchBarDelegate
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        
    }
}


// MARK: UICollectionViewDataSource
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        let photo = searchResults[indexPath.row]
        
        cell.image.image = nil
        cell.imageID = photo.id
        
        downloadManager.loadImage(photo: photo) { (image) in
            DispatchQueue.main.async {
                if cell.imageID == photo.id {
                    cell.image.image = image
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row >= self.searchResults.count else {
            return
        }
        self.activityIndicator.startAnimating()
        guard totalPage >= nextPage else {
            print("[INFO] : reached end")
            return
        }
        flickerCore.photosSearch(keyword: searchKeyword, fromPage: nextPage) { (resp) in
            if let resp = resp {
                self.searchResults.append(contentsOf: resp.photos.photo)
                self.nextPage += 1
                collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

//MARK: - Collection View Layout delegate
extension CollectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


//MARK: - Search Box Delegate
extension CollectionViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, query != "" {
            searchKeyword = query
            nextPage = 1
            self.activityIndicator.startAnimating()
            flickerCore.photosSearch(keyword: query, fromPage: nextPage) { resp in
                if let resp = resp {
                    self.searchResults = resp.photos.photo
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.totalPage = resp.photos.pages
                    self.nextPage += 1
                }
            }
        }
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
    
}
