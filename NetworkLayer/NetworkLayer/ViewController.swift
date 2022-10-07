//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Develop on 07/10/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        login()
        getProductCategory()
     
    }

    //MARK: - Functions
    
    func getProductCategory() {
        let productAPI :ProductAPIProtocol = ProductAPI()
        productAPI.getProductCategory{ result in
            switch result {
            case.success(let products):
                print(products?.data?.data[0].name)
            case.failure(let error):
                print(error)
                
            }
            
        }
    }
    
    
    func login() {
        let userAPI:UserAPIProtocol = UserAPI()
        
        AppLanguage.lang = "ar"
        userAPI.loginUsers(email: "sayed.ah@gmail.com", password: "123456") { result in
            switch result {
            case .success(let response):
                if response?.status ?? true {
                    guard let user = response?.data else {return}
                    print(user.email , user.name)
                    print("\(response?.message)")
                }else {
                    print("\(response?.message)")
                }
            case .failure(let error):
                    print(error)
            }
        }
    }

}

