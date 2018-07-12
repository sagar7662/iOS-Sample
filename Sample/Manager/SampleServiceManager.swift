//
//  AlphaServiceManager.swift
//  Alpha
//
//  Created by Speedy Singh on 12/26/17.
//  Copyright © 2017 Senzec. All rights reserved.
//

import Foundation
import Alamofire

typealias SuccessBlock = (Any) -> Void
typealias ErrorBlock = (Error) -> Void

class SampleServiceManager {
    
    enum EndPoint: String {
        case baseURL = "http://ws.audioscrobbler.com/2.0/"
    }
    
    static func getTopArtists(parameters: [String : Any], success : @escaping (Any) -> Void, failure : @escaping (Error) -> Void) {
        get(endPoint: EndPoint.baseURL.rawValue, parameters: parameters, headers: [:], success: success, failure: failure)
    }
    
    static func getTopAlbums(parameters: [String : Any], success : @escaping (Any) -> Void, failure : @escaping (Error) -> Void) {
        get(endPoint: EndPoint.baseURL.rawValue, parameters: parameters, headers: [:], success: success, failure: failure)
    }
    
    private static func get(endPoint: String,
                    parameters: [String : Any] = [:],
                    headers: [String : Any] = [:],
                    success : @escaping (Any) -> Void,
                    failure : @escaping (Error) -> Void) {
        request(URLString: endPoint, httpMethod: .get, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    private static func request(URLString: String,
                                httpMethod: HTTPMethod,
                                parameters: [String : Any] = [:],
                                headers: [String : Any] = [:],
                                success : @escaping (Any) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        var additionalHeaders: HTTPHeaders?
        additionalHeaders = headers as? HTTPHeaders
        Alamofire.request(URLString, method: httpMethod,
                          parameters: parameters, encoding: httpMethod == .get ? URLEncoding.default : JSONEncoding.default,
                          headers: additionalHeaders).responseJSON { (response: DataResponse<Any>) in
                            parseResponse(response, success: success, failure: failure)
        }
    }
    
    private static func parseResponse(_ response: DataResponse<Any>,
                                      success : @escaping (Any) -> Void,
                                      failure : @escaping (Error) -> Void) {
        switch response.result {
        case .success(let value): success(value)
        case .failure(let e):
            let err = (e as NSError)
            if err.code == NSURLErrorNotConnectedToInternet || err.code == NSURLErrorInternationalRoamingOff {
                let internetNotAvailableError = NSError(domain: "No Internet connection available. Please connect to internet and try again.", code: NSURLErrorNotConnectedToInternet)
                failure(internetNotAvailableError)
            } else {
                failure(e)
            }
        }
    }
}
