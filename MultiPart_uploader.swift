import UIKit
import Foundation

//https://newfivefour.com/swift-form-data-multipart-upload-URLRequest.html



class Multi_part_Uploader{
    func request(stringUrl:String, parameters: [String:String]?,imageNames : [String], images:[Data], completion: @escaping(Any?, Error?, Bool)->Void) {
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        //print("\n\ncomplete Url :-------------- ",stringUrl," \n\n-------------: complete Url")
        guard let url = URL(string: stringUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        if parameters != nil{
            for(key, value) in parameters!{
                // Add the reqtype field and its value to the raw http request data
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)".data(using: .utf8)!)
            }
        }
        for (index,imageData) in images.enumerated() {
            // Add the image data to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\(index)\"; filename=\"\(imageNames[index])\"\r\n")
            data.append("Content-Type: image/png\r\n\r\n")
            data.append(imageData)
        }
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: request, from: data, completionHandler: { data, response, error in

            if let checkResponse = response as? HTTPURLResponse{
        
                print(checkResponse.statusCode)
                
                if checkResponse.statusCode == 200{
                    guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments]) else {
                        completion(nil, error, false)
                        return
                    }
                    let jsonString = String(data: data, encoding: .utf8)!
                    print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                    print(json)
                    completion(json, nil, true)
                }else{
                    guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                        completion(nil, error, false)
                        return
                    }
                    let jsonString = String(data: data, encoding: .utf8)!
                    print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                    print(json)
                    completion(json, nil, false)
                }
            }else{
                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    completion(nil, error, false)
                    return
                }
                completion(json, nil, false)
            }

        }).resume()

    }

 
}
extension Data {

     /// Append string to Data
     ///
     /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
     ///
     /// - parameter string:       The string to be added to the `Data`.

     mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
         if let data = string.data(using: encoding) {
             append(data)
         }
     }
 }


let url = Bundle.main.path(forResource: "pic", ofType: "png")
let img = UIImage(contentsOfFile: url!)

let url2 = Bundle.main.path(forResource: "pic2", ofType: "png")
let img2 = UIImage(contentsOfFile: url2!)


let rec = Multi_part_Uploader()
rec.request(stringUrl: "http://127.0.0.1:5000/uploader", parameters: ["name":"omid"], imageNames: ["pic.png","pic2.png"], images: [img!.jpegData(compressionQuality: 1.0)!,img2!.jpegData(compressionQuality: 1.0)!]) { an, err , bl in
    
    print(bl)
    print("----")
    print(err)
}
