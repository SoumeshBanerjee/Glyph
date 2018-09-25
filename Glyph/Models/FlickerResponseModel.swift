//
//  FlickerResponseModel.swift
//  FlickerCore
//
//  Created by Soumesh Banerjee on 24/09/18.
//  Copyright © 2018 Soumesh Banerjee. All rights reserved.
//

enum FlickerCoreAPIResponseCodes {
    case Success, Failure, InvalidAPIKeyOrSecret, UnknownError
}


struct FlickerPhotosSearchResponse : Decodable {
    struct Photos : Decodable {
        struct Photo : Decodable {
            var id : String
            var owner : String
            var secret : String
            var server : String
            var farm : Int
            var title : String
            var ispublic : Int
            var isfriend : Int
            var isfamily : Int
        }
        
        var page : Int64
        var pages : Int64
        var perpage : Int64
        var total : String
        var photo : [Photo]
    }
    
    var photos : Photos
    var stat : String
}
