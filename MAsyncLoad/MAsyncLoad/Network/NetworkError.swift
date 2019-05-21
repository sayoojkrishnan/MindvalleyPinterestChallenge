//
//  Error.swift
//  MAsyncLoad
//
//  Created by Sayooj Krishnan  on 17/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import Foundation
public enum NetworkError : Error {
    case failedToFetch(error : String)
    case serviceUnavailable
    case notFound
    case emptyResponse
    case invalidURL
}
