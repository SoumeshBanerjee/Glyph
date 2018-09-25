//
//  DownloadManager.swift
//  Glyph
//
//  Created by Soumesh Banerjee on 24/09/18.
//  Copyright © 2018 Soumesh Banerjee. All rights reserved.
//

import UIKit

class DownloadManager: NSObject, URLSessionDelegate {
    typealias imageDownloadedCompletionBlock = (UIImage) -> ()
    var session : URLSession!
    
    var activeDownloadList : [String : imageDownloadedCompletionBlock] = [:]
    let cache = NSCache<NSString, UIImage>()
    
    func loadImage(photo: FlickerPhotosSearchResponse.Photos.Photo , completion: @escaping imageDownloadedCompletionBlock) {
        
        if let image = loadImageFromCache(id: photo.id) {
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        
        activeDownloadList[photo.id] = completion
        
        //http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
        
        let url = URL(string: "https://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg")
        
        guard url != nil else {
            print("[Error] : Unable to unwrap url")
            return
        }
        
        let task = session.downloadTask(with: url!)
        task.resume()
    }
    
    private func loadImageFromCache(id: String) -> UIImage? {
        return cache.object(forKey: id as NSString)
    }
}
