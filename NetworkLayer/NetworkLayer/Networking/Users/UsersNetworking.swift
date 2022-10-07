//
//  UsersNetworking.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import Foundation
import Alamofire

enum UsersNetworking {
    
    case loginUsers(email:String,password:String)
    case creatUser(name:String,email:String,phone:String,password:String,image:String)
}

extension UsersNetworking :TargetType {
    var baseURL: String {
        switch self {
        default:
            return Constants.BaseURL.rawValue
        }
    }
    
    var path: String{
        switch self {
    case .loginUsers:
            return Constants.LoginPath.rawValue
    case .creatUser:
        return Constants.RegisterPath.rawValue
    }
    }
    var method: HTTPMethod {
        switch self {
            
        case .loginUsers:
            return .post
        case .creatUser:
            return .post
        }
    }
    var task: Task {
        switch self {
            
        case .loginUsers(email: let email, password: let password):
            return .requestParameters(parameters: ["email":email,"password":password], encoding: JSONEncoding.default)
        case .creatUser(name: let name, email: let email, phone: let phone, password: let password, image: let image):
            return .requestParameters(parameters: ["name":name, "email":email,"password":password,"phone":phone,"image":image], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["lang":AppLanguage.lang,"Content-Type":"application/json"]
        }
    }
    
    
}
