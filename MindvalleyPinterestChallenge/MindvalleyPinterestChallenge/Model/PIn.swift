//
//  Pin.swift
//  MindvalleyPinterestChallenge
//
//  Created by Sayooj on 18/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import Foundation

struct Pin : Codable{
    
    struct PinURL : Codable {
        let raw : String?
        let full : String?
        let regular : String?
        let small : String?
        let thumb : String?
    }
    struct Category : Codable{
        let title : String?
    }
    
    let color : String?
    let width : Int?
    let height : Int?
    let urls : PinURL?
    let categories : [Category]?
    let user : User?
}


