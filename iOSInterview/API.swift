//
//  API.swift
//  iOSInterview
//
//  Created by Ariel on 11/05/2023.
//

import Foundation

enum Chain: String, CaseIterable, Decodable {
    case ethereum
    case solana
    case polygon
}

struct NFT: Decodable {
    let imageUrl: String
    let name: String
    let floorPrice: String
    let floorPriceChange: String
    let chain: Chain
}

struct RankingResponse: Decodable {
    let page: Int
    let total: Int
    let collections: [NFT]
}

class API {
    let baseURL = URL(string: "https://api.opensea.app")!
    
    let jsonResponse = """
    {
      "page": 1,
      "total": 1,
      "collections": [
        {
          "imageUrl": "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg",
          "name": "PEPE",
          "floorPrice": "1.5 eth",
          "floorPriceChange": "150.40%",
          "chain": "ethereum",
        },
        {
          "imageUrl": "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg",
          "name": "PEPE_SOL",
          "floorPrice": "1 SOL",
          "floorPriceChange": "10%",
          "chain": "solana",
        },
        {
          "imageUrl": "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg",
          "name": "PEPE_2",
          "floorPrice": "2.5 eth",
          "floorPriceChange": "20%",
          "chain": "ethereum",
        },
        {
          "imageUrl": "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg",
          "name": "MONKEY",
          "floorPrice": "30 weth",
          "floorPriceChange": "1000%",
          "chain": "polygon",
        },
        {
          "imageUrl": "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg",
          "name": "PEPE",
          "floorPrice": "1.5 eth",
          "floorPriceChange": "150.40%",
          "chain": "ethereum",
        },
        {
          "imageUrl": "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg",
          "name": "PEPE_SOL",
          "floorPrice": "1 SOL",
          "floorPriceChange": "10%",
          "chain": "solana",
        },
        {
          "imageUrl": "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg",
          "name": "PEPE_2",
          "floorPrice": "2.5 eth",
          "floorPriceChange": "20%",
          "chain": "ethereum",
        },
        {
          "imageUrl": "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg",
          "name": "MONKEY",
          "floorPrice": "30 weth",
          "floorPriceChange": "1000%",
          "chain": "polygon",
        }
      ]
    }
    """
    
    func getRankings(page: Int = 0, chain: Chain? = nil) -> [NFT] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.path = "/ranking"
        
        var queryItems = [URLQueryItem(name: "page", value: String(describing: page))]
        
        if let chain = chain {
            queryItems.append(URLQueryItem(name: "chain", value: chain.rawValue))
        }
        
        components.queryItems = queryItems
        print("URL \(components.url!.absoluteString)")
        
        let dataResponse = makeRequest(to: components.url!)
        
        guard let data = dataResponse else {
            return []
        }
        
        do {
            let response = try JSONDecoder().decode(RankingResponse.self, from: data)
            
            if let chain = chain {
                return response.collections.filter { $0.chain == chain }
            }
            
            return response.collections
        } catch {
            print(error)
        }
        
        return []
    }
    
    private func makeRequest(to url: URL) -> Data? {
        return jsonResponse.data(using: .utf8)
    }
}
