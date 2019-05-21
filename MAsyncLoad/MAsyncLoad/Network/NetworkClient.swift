//
//  Network.swift
//  MAsyncLoad
//
//  Created by Sayooj Krishnan  on 17/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import Foundation
public enum HTTPMethod : String {
    case GET = "get"
    case POST = "post"
    case PUT = "put"
    case DELETE = "delete"
}
public enum NetworkResult<Value> {
    
    case Success(Value)
    case Error(NetworkError)
}
extension NetworkResult {
    func resolve() throws -> Value {
        switch self {
        case NetworkResult.Success(let value): return value
        case NetworkResult.Error(let error): throw error
        }
    }
}
public final class NetworkClient {
    
    public static let shared = NetworkClient()
    
    public typealias closure = (NetworkResult<Data?>)->Void
    
    private let cache = CacheManager.instance.cache
    
    
    private let session : DHURLSession
    
    public init(session : DHURLSession = URLSession(configuration: URLSessionConfiguration.ephemeral) ) {
        self.session = session
    }
    
    /**
     Performs HTTP network requests
     completion hanler : Result<Data?> where Result is an enum with 2 cases
     Success and Error
     
     
     - parameter method: HTTPMethod  (get ,post etc)
     - parameter url: URL  reuqest paramter
     - paramter params : [String:String] quesry parameters
     - parameter then : completetion hanlder
     */
    public func fetch(url : URL ,method : HTTPMethod  = .GET, then callback : @escaping closure ){
        
        // check whether the url is cached or not
        if let isCached = cache?.get(url)  {
            callback(NetworkResult.Success(isCached))
            return
        }
        
        // Build request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        
        let task = session.dataTask(with: request) {[weak self] (data, urlResponse, error) in
            guard error == nil else{
                callback(NetworkResult.Error(NetworkError.failedToFetch(error: error?.localizedDescription ?? "Something went wrong")))
                return
            }
            guard let responseInfo = urlResponse as? HTTPURLResponse else {
                callback(NetworkResult.Error(NetworkError.failedToFetch(error: "Couldn't decode response details ")))
                return
            }
            
            switch responseInfo.statusCode {
            case 200..<300 :
                self?.cache?.set(url, val: data ?? Data())
                callback(NetworkResult.Success(data))
            case 404 :
                callback(NetworkResult.Error(.notFound))
            case 500 :
                callback(NetworkResult.Error(.serviceUnavailable))
            default :
                callback(NetworkResult.Error(.serviceUnavailable))
            }
        }
        task.resume()
    }
}


public protocol DHURLSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession: DHURLSession { }
