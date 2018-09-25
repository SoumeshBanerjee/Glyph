//
//  CollectionViewURLSessionDelegate.swift
//  Glyph
//
//  Created by Soumesh Banerjee on 25/09/18.
//  Copyright © 2018 Soumesh Banerjee. All rights reserved.
//

import UIKit

//MARK - URLSessionDelegate
extension CollectionViewController : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        let id = getIdFromURL(url: downloadTask.originalRequest?.url)
    
        guard id != nil else {
            print("[Error] : unable to parse id from the URL")
            return
        }
        
        let completion = downloadManager.activeDownloadList[id!]
        
        guard completion != nil else{
            print("[Error]: Completion handler is nil")
            return
        }
        
        do {
            let _data = try Data(contentsOf: location)
            let image = UIImage(data: _data)
            
            if let image = image {
                downloadManager.cache.setObject(image, forKey: id! as NSString)
                completion!(image)
            }
            
        } catch let error {
            print("[Error] : Content corrupted \(error.localizedDescription)")
        }
        
        
        
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("[Error] : Something went wrong for downloading image \(String(describing: error?.localizedDescription))")
        }
    }
    
    //Mark - Util
    fileprivate func getIdFromURL(url: URL?) -> String?{
        guard let url = url else {
            return nil
        }
        let component = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        guard let _component = component else {
            return nil
        }
        
        var idSplit = _component.path.split(separator: "_")
        
        if idSplit.count > 0 {
            idSplit = idSplit[0].split(separator: "/")
            if idSplit.count > 0 {
                return String(idSplit[1])
            }
        }
        
        
        return nil
    }
}


