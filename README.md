# NetWorkLayer
NetWorkLayer Useing ALamofire , Codable &amp; Generic 


First of all I'll thank Eng: Ahmed-Masoud
--- 
OK 
we need to implement some of classes and enums like below : 

## 1- create file with name >> TargetType 
  - create inside this file 2 enums and one protocol like below :
      ```swift
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
        
## 2- create file with name >> BaseAPI in this File we will implement the main function for fetch data 
   
   ```swift
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

```

## 3- create file with name BaseResponse in this file we can map any response from back end by passing the Model of Data 
```swift
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
```
 
 > ## Now we can use our Network layer to fetch some of data 
 >> #### create userNetwork 
 
 ```swift
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
 ```
 >> ### Create UserAPI the main function that we use it to login user 
 
 ```swift
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
 ```
 > ## Now we can call our function in viewController to login user .
 ```swift
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
 ```
> # :key: Note 
>> ### you can find BaseURL & endpoints inside the constants File 

> # GoodLuck :heart:
