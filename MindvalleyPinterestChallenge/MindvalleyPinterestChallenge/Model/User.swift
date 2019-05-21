//
//  User.swift
//  MindvalleyPinterestChallenge
//
//  Created by Sayooj on 18/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import Foundation
struct User  : Codable{
    
    struct ProfileImage : Codable {
        let small : String?
        let medium : String?
        let large : String?
    }
    let name : String?
    let profileImage : ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
        case name = "name"
    }
    
}
