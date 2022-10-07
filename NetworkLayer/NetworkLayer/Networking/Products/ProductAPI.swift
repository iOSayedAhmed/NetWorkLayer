//
//  ProductAPI.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import Foundation

protocol ProductAPIProtocol {
    func getProductCategory(Completion: @escaping (Result<BaseResponse<ProductModel>?,NSError>) -> Void)
}


class ProductAPI : BaseAPI<ProductsNetworking>, ProductAPIProtocol {
    func getProductCategory(Completion: @escaping (Result<BaseResponse<ProductModel>?,NSError>) -> Void) {
        fetchData(target: .getCategoryProducts ,responseClass:BaseResponse<ProductModel>.self) { result in
            Completion(result)
        }
    }
    
}
