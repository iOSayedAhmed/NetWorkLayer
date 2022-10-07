//
//  BaseResponse.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import Foundation

class BaseResponse<T:Codable>:Codable {
    let status:Bool?
    let message:String?
    let data:T?
    
    enum CodingKeys:String,CodingKey {
        case data = "data"
        case message
        case status 
    }
}
