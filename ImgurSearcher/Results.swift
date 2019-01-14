//
//  Photos.swift
//  ImgurSearcher
//
//  Created by Mohamed Ayadi on 1/13/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import Foundation


struct Results: Decodable {
    
    var results: [Result]
    
    private enum CodingKeys: String, CodingKey {
        case results = "data"
    }
    
}

struct Result: Decodable {
    
    let title: String
    var imageURLS: [URL]? {
        return images?.compactMap{$0.imageURL}
    }
    let images: [Images]?
}

struct Images: Decodable {
    let imageURL: URL
    private enum CodingKeys: String, CodingKey {
        case imageURL = "link"
    }
}
