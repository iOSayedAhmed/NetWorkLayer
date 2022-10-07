//
//  UserAPI.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import Foundation

protocol UserAPIProtocol {
    func loginUsers(email:String,password:String,completion: @escaping (Result<BaseResponse<UserModel>?,NSError>) -> Void)
}

class UserAPI:BaseAPI<UsersNetworking>,UserAPIProtocol{
    func loginUsers(email:String,password:String,completion: @escaping (Result<BaseResponse<UserModel>?,NSError>) -> Void) {
        fetchData(target: .loginUsers(email: email, password: password), responseClass: BaseResponse<UserModel>.self) { result in
            completion(result)
        }
    }
    
}
