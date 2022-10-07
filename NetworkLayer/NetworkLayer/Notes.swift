/*
    Alamofire.request(.POST, urlString, parameters: parameters)
                .responseJSON(completionHandler: {response in
                    switch(response.result) {
                    case .Success(let JSON):
                        // Yeah! Hand response
 
 
                    case .Failure(let error):
                       let message : String
                       if let httpStatusCode = response.response?.statusCode {
                          switch(httpStatusCode) {
                          case 400:
                              message = "Username or password not provided."
                          case 401:
                              message = "Incorrect password for user '\(name)'."
                           ...
                          }
                       } else {
                          message = error.localizedDescription
                       }
                       // display alert with error message
                     }

*/
