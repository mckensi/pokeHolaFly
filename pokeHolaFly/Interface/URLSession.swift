//
//  URLSession.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import Foundation
import Combine

extension URLSession {
    func getData(from url: URL) -> AnyPublisher<Data, Error>  {        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error -> NetworkError in
                if error.errorCode == -1001 {
                    return .unknown
                } else {
                    return .general(error)
                }
            }
            .retry(3)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.unknown
                }
                if response.statusCode == 200 {
                    return data
                } else {
                    throw NetworkError.status(response.statusCode)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getData(for url: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error -> NetworkError in
                if error.errorCode == -1001 {
                    return .unknown
                } else {
                    return .general(error)
                }
            }
            .retry(3)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.unknown
                }
                if response.statusCode == 200 {
                    return data
                } else {
                    throw NetworkError.status(response.statusCode)
                }
            }
            .eraseToAnyPublisher()
    }
}
