//
//  Constants.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import Foundation


struct AppLanguage {
    static var lang = "ar"
}
enum Constants:String {
    case BaseURL = "https://student.valuxapps.com/api"
    case LoginPath = "/login"
    case RegisterPath = "/register"
    case ProductCategory = "/products"
}

enum ErrorMessages:String {
    case decodingError = "Error according to in decoding a data ."
    case unAuthorizedError = "Please Check if you entered the user key or not ."
    case notFoundError = "Error is not found resource error may be in url or Domain ."
    case genericError = "genericError >>>"
}
