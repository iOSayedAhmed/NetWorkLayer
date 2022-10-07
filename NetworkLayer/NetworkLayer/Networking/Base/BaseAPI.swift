//
//  BaseAPI.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import Foundation
import Alamofire

class BaseAPI<T:TargetType> {
    
    func fetchData<M:Decodable>(target:T,responseClass:M.Type,completion: @escaping (Result<M?,NSError>) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue:target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParameters(task: target.task)
        
        AF.request(target.baseURL + target.path , method: method,parameters:params.0 , encoding: params.1,headers: headers).responseJSON { response in
            guard let statusCode = response.response?.statusCode else {
                //ADD Custom error
                let error = NSError(domain: target.baseURL, code:response.response?.statusCode ?? 0 , userInfo: [NSLocalizedDescriptionKey:ErrorMessages.genericError])
                completion(.failure(error))
                return
            }
            if statusCode == 200 {
                //SuccessFul request
                guard let jsonResponse = try? response.result.get() else {
                    //ADD Custom Error
                    let error = NSError(domain: target.baseURL, code:response.response?.statusCode ?? 0 , userInfo: [NSLocalizedDescriptionKey:ErrorMessages.genericError])
                    completion(.failure(error))
                    return
                }
                guard let theJsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    //ADD Custom Error
                    let error = NSError(domain: target.baseURL, code:response.response?.statusCode ?? 200 , userInfo: [NSLocalizedDescriptionKey:ErrorMessages.genericError])
                    completion(.failure(error))
                    return
                }
                
                guard let responseObj = try? JSONDecoder().decode(M.self, from: theJsonData) else {
                    //ADD Custom Error
                    let error = NSError(domain: target.baseURL, code:response.response?.statusCode ?? 200 , userInfo: [NSLocalizedDescriptionKey:ErrorMessages.decodingError])
                    completion(.failure(error))
                    return
                }
                //Successful Decode Data
                completion(.success(responseObj))
            }else if statusCode == 404 {
                //ADD Custom Error
                let error = NSError(domain: target.baseURL, code:response.response?.statusCode ?? 200 , userInfo: [NSLocalizedDescriptionKey:ErrorMessages.notFoundError])
                completion(.failure(error))
            }else if statusCode == 401 {
                //ADD Custom Error
                let error = NSError(domain: target.baseURL, code:response.response?.statusCode ?? 200 , userInfo: [NSLocalizedDescriptionKey:ErrorMessages.unAuthorizedError])
                completion(.failure(error))
            }
        }
      
    }
    
    
    private func buildParameters(task:Task) -> ([String:Any],ParameterEncoding){
        switch task {
        case .requestPlain:
            return ([:],URLEncoding.default)
        case .requestParameters(let parameters, let encoding):
            return (parameters,encoding)
        }
        
    }
    
}
