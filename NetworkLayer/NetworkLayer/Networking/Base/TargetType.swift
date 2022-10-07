//
//  TargetType.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import Foundation
import Alamofire


//HTTPMethod specify what is type of request {get|post|delete}
enum HTTPMethod:String {
    case get  = "GET"
    case post = "POST"
    case put  = "PUT"
    case delete = "DELETE"
}
//Task specify what is type of request have parameters or Not
enum Task{
    case requestPlain
    case requestParameters(parameters: [String:Any],encoding:ParameterEncoding)
}

// define the informations of any request
protocol TargetType {
    var baseURL:String {get}
    var path:String {get}
    var method:HTTPMethod {get}
    var task:Task {get}
    var headers: [String:String]? {get}
}
