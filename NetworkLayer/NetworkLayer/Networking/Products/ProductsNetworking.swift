//
//  ProductsNetworking.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import Foundation
import Alamofire

enum ProductsNetworking {
    //Type of requests that we want to implement in products
    
    case getCategoryProducts
    case getProductDetails
}

extension ProductsNetworking:TargetType{
    var baseURL: String {
        switch self {
        default:
            return Constants.BaseURL.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .getCategoryProducts:
            return Constants.ProductCategory.rawValue
        case .getProductDetails:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCategoryProducts:
            return .get
        case .getProductDetails:
            return .get
        }
    }
    
    var task: Task {
        switch self {
       
        case .getCategoryProducts:
            return .requestPlain
        case .getProductDetails:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        switch self {
        default:
            return ["lang":AppLanguage.lang,"Content-Type":"application/json"]
        }
    }
    
    
}

