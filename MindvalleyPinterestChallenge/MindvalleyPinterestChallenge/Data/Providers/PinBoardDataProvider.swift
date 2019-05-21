//
//  PinBoardDataProvider.swift
//  MindvalleyPinterestChallenge
//
//  Created by Sayooj on 20/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import Foundation
import MAsyncLoad
class PinBoardDataProvider {
        
    private let pinsUrl = "http://pastebin.com/raw/wgkJgazE"
    func getPins(completion : @escaping ([Pin],NetworkError?)->()){
        guard let url = URL(string: pinsUrl) else {
            completion([],NetworkError.invalidURL)
            return
        }
        NetworkClient.shared.fetch(url: url) {[weak self] (resultResponse) in
            switch resultResponse {
            case .Success(let data) :
                guard let loadedData = data, let pins = self?.decode(loadedData) else {
                    completion([],NetworkError.emptyResponse)
                    return 
                }
                completion(pins,nil)
            case .Error(let error) :
                completion([],error)
            }
        }
    }
    
    private func  decode(_ data : Data )->[Pin]?{
        
        do {
            let pins =  try JSONDecoder().decode([Pin].self, from: data)
            return pins
        }catch {
            print("failded to deoced \(error.localizedDescription)")
        }
        return nil
    }
    
}


