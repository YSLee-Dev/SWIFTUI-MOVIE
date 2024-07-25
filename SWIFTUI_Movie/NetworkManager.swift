//
//  NetworkManager.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/25/24.
//

import Foundation

struct NetworkManager {
    let urlSession = URLSession.shared
    
    func reqeustData<T: Decodable>(decodingType: T.Type, url: URL?) async throws -> T {
        guard let url = url else {throw URLError.init(.badURL)}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let response = try await self.urlSession.data(for: request)
        guard let code = (response.1 as? HTTPURLResponse)?.statusCode else {throw URLError.init(.unknown)}
        
        switch code {
        case 200...299:
            do {
                let data = try JSONDecoder().decode(decodingType, from: response.0)
                return data
            } catch {
                throw URLError.init(.cannotDecodeContentData)
            }
        case 300...399:
            throw URLError.init(.badServerResponse)
        default:
            throw URLError.init(.unknown)
        }
    }
}
