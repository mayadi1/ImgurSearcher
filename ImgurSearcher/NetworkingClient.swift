//
//  ImgurServiceClient.swift
//  ImgurSearcher
//
//  Created by Mohamed Ayadi on 1/12/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import Foundation

public class NetworkingClient {
    
    static let shared = NetworkingClient()
    private let baseURL = "https://api.imgur.com/3/gallery/search/time/"

    func fetchResults(with searchText: String, atPage: Int, completion: @escaping (_ success: Results?)->Void){
        
        guard let baseURL = URL(string: baseURL) else {completion(nil);return}
        let pageNumber = String(atPage)
        var components = URLComponents(url: baseURL.appendingPathComponent(pageNumber), resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "q", value: searchText.lowercased())
        let typeQuery = URLQueryItem(name: "q_type", value: "jpg")
        components?.queryItems = [queryItem, typeQuery]
        guard let url = components?.url else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let clientID = "126701cd8332f32"
        urlRequest.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 300
        if #available(iOS 11, *) {
            configuration.waitsForConnectivity = true
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        URLSession(configuration: sessionConfig)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard let data = data else {completion(nil);return}
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                var filteredResults = results
                filteredResults.results.removeAll()

                for result in results.results{
                    if (result.imageURLS?.first?.pathExtension == "jpg" || result.imageURLS?.first?.pathExtension == "png" ){
                        filteredResults.results.append(result)
                    }
                }
                
                completion(filteredResults)
                if error != nil {
                    if error?._code ==  NSURLErrorTimedOut {
                        print("Time Out")
                    }else{
                        print(error.debugDescription)
                    }
                }
            } catch {
                print("Error fetching results \(error.localizedDescription), \(error)")
                completion(nil)
                return
            }
            }.resume()
    }
 
}


