//
//  UserModel.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import Foundation

struct UserModel:Codable {
 let id: Int?
 let name, email, phone: String?
 let image: String?
 let points, credit: Int?
 let token: String?
    
    enum CodingKeys:String,CodingKey {
        case id , name , phone
        case email = "email"
        case image , points , credit , token
        
        
    }
    
}
