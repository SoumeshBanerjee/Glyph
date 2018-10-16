//
//  GlyphTests.swift
//  GlyphTests
//
//  Created by Soumesh Banerjee on 16/10/18.
//  Copyright © 2018 Soumesh Banerjee. All rights reserved.
//

import XCTest
@testable import Glyph

class GlyphTests: XCTestCase {
    func testDownloadManager() {
        let exp = expectation(description: "DonwloadFinish")
        
        let flickerCore = FlickerCore(endpoint: "https://api.flickr.com/services/rest", apiKey: "3e7cc266ae2b0e0d78e279ce8e361736")
        let downloadManager = DownloadManager()
        
        let testSession = URLSession(configuration: .background(withIdentifier: "com.soumesh.testGlyph"))
        
        downloadManager.session = testSession
        
        
        flickerCore.photosSearch(keyword: "Apple", fromPage: 1) { (_FlickerPhotosSearchResponse) in
            if let resp = _FlickerPhotosSearchResponse {
                XCTAssert(resp.photos.photo.count >= 1, "not even one image is retrived")
                exp.fulfill()
            }
        }
        
        // Wait for the async request to complete
        waitForExpectations(timeout: 40, handler: nil)
        
    }
    
    func testnegative() {
        let flickerCore = FlickerCore(endpoint: "https://api.flickr.com/services/rest", apiKey: "WRONG_KEY")
        let downloadManager = DownloadManager()
        let testSession = URLSession(configuration: .background(withIdentifier: "com.soumesh.testGlyph"))
        downloadManager.session = testSession
        flickerCore.photosSearch(keyword: "Apple", fromPage: 2) { (resp) in
            XCTAssert(false, "Failed something is wrong")
        }
    }
}
