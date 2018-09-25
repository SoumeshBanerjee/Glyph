//
//  FlickerCore.swift
//  FlickerCore
//
//  Created by Soumesh Banerjee on 24/09/18.
//  Copyright © 2018 Soumesh Banerjee. All rights reserved.
//

import Foundation

class FlickerCore: NSObject {
    let urlSession = URLSession(configuration: .default)
    
    var endpoint : String
    var apiKey : String
    var task : URLSessionDataTask?
    
    init(endpoint:String, apiKey: String) {
        self.endpoint = endpoint
        self.apiKey = apiKey
        
        super.init()
    }
    
    func photosSearch(keyword: String, fromPage: Int64, completion: @escaping (_ response: FlickerPhotosSearchResponse?) -> ()) {
        //cancel any previous searches to avoid unnecessary
        task?.cancel()
        
        //Expected Endpoint -> https://api.flickr.com/services/rest/
        guard var urlComponent = URLComponents(string: self.endpoint) else {
            print("[Error] : invalid endpoint provided \(self.endpoint)")
            return
        }
        
        //Expected API Query String
        urlComponent.query = "method=flickr.photos.search&api_key=\(self.apiKey)&format=json&nojsoncallback=1&safe_search=1&text=\(keyword)&page=\(String(describing: fromPage))&per_page=99"
        
        
        guard let url = urlComponent.url else {
            print("[Error] : unable to crete url for the given query, might contain unsupported character/s in the query => \(keyword)")
            return
        }
        
        task = urlSession.dataTask(with: url) { (data, resp, err) in
            if let error = err {
                print("[Error] : something went wrong in querying \(error.localizedDescription)")
                return
            }
            else if let _data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let flickerPhotosSearchResponse = try jsonDecoder.decode(FlickerPhotosSearchResponse.self, from: _data)
                    DispatchQueue.main.async {
                        completion(flickerPhotosSearchResponse)
                    }
                    
                } catch let error {
                    print("[Error]: json decoding error for query => \(error.localizedDescription) \(_data.count)")
                }
            }
        }
        
        task?.resume()
        }
    }
