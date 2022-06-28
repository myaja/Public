//
//  API.swift
//  MovieCatalog
//
//  Created by wobdeveloper on 24/06/2022.
//

import Foundation


///Movie Discovery Struct

struct movieDiscoveryResults: Decodable {
    var page: Int?
    var results: [arrayOfResults]
    
    var total_pages: Int?
    var total_results: Int?
}

struct arrayOfResults: Decodable, Hashable {
    var adult: Bool?
    var backdrop_path: String?
    var genre_ids: [Int]?
    var id: Int?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Float?
    var poster_path: String?
    var release_date: String?
    var title: String
    var video: Bool?
    var vote_average: Float?
    var vote_count: Int?
}

class API {
    
    func getMovies ( arrayView: [movies], route: String ,completion: @escaping ([movies] , Int) -> Void ){
        
        var array:[movies]?
        var totalPages:Int = 0
        
        if array != [] {
            array = arrayView
        }
        
        
        var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/\(route)")!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //timeout response or any error
            if error != nil {
                
                array?.append(movies(title: String( describing: error ), releaseDate: "", overview: "", posterPath: ""))
                
            } else {
                let jsonResponse = try! JSONDecoder().decode(movieDiscoveryResults.self, from: data!)
                print("data - \(jsonResponse)")
                
                let arrayOfMovies = jsonResponse.results
                
                totalPages = jsonResponse.total_pages!
                
                for movie in arrayOfMovies {
                    //array?.append(movie.original_title)
                    array?.append(movies(title: movie.title , releaseDate: movie.release_date ?? "" , overview: movie.overview ?? "" , posterPath: movie.poster_path ?? "" ))
                    
                }
                
            }
            print(array!)
            completion(array!, totalPages)
        }
        .resume()
    }
    
}
