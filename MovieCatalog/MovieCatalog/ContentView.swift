//
//  ContentView.swift
//  MovieCatalog
//
//  Created by wobdeveloper on 23/06/2022.
//

import SwiftUI

struct movies : Hashable {
    var title: String
    var releaseDate: String
    var overview: String
    var posterPath: String
}

struct ContentView: View {
    
    
    @State var arrayOfMovies: [movies] = []
    @State var lastItemOfArray: String = ""
    @State var page: Int = 1
    @State var route: String = ""
    @State var totalPages: Int = 0
    
    //Search
    @State var searchText: String = ""
    
    //Get an API KEY https://www.themoviedb.org/settings/api
    let apiKey: String = ""
    
    
    var body: some View {
        
        VStack{
            
            NavigationView{
            
                List(arrayOfMovies, id: \.self){ movie in
                    Text(movie.title)
                        .font(.body)
                        .onAppear{
                        
                            if movie.title == lastItemOfArray {
                                page += 1
                                print("page -\(page)")
                            
                                if page <= totalPages {
                                
                                    if searchText != "" {
                                    
                                        let query = searchText.replacingOccurrences(of: " ", with: "+")
                                        print("query - \(query)")
                                    
                                        route = "search/movie?api_key=\(apiKey)&language=en-US&query=\(query)&page=\(String(page))&include_adult=false"
                                    
                                    
                                    } else {
                                    
                                        route = "discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(String(page))&with_watch_monetization_types=flatrate"
                                    }
                            
                                    API().getMovies( arrayView: arrayOfMovies, route: route){ ( arrayOfMoviesClass , totalPagesClass ) in
                                
                                        self.arrayOfMovies = arrayOfMoviesClass
                                        lastItemOfArray = arrayOfMoviesClass.last!.title
                                        totalPages = totalPagesClass
                                    
                                        print("last item - \(lastItemOfArray)")
                                        print("totalPages - \(totalPages)")
                                    
                                
                                    }
                                    
                                }
                                
                            }
                        }
                    Text(movie.releaseDate)
                    Text(movie.overview)
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath)"))
                    
                }
                .listStyle(PlainListStyle())
                //.navigationBarHidden(true)
                //.navigationBarBackButtonHidden(true)
                //.navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
                
            }
            .navigationViewStyle(.stack)
            /*.onSubmit (of: .search) {
                print("searchText - \(searchText)")
            }*/
            .onChange(of: searchText) { _ in
                
                print("searchText - \(searchText)")
                
                arrayOfMovies = []
                
                
                if searchText == " " {
                    searchText = ""
                }
                
                if searchText != "" {
                    
                    if searchText.isValid(.alphabetNumWithSpace) {
                    
                        let query = searchText.replacingOccurrences(of: " ", with: "+")
                        print("query - \(query)")
                
                        route = "search/movie?api_key=\(apiKey)&language=en-US&query=\(query)&page=1&include_adult=false"
                
                        API().getMovies(arrayView: arrayOfMovies, route: route){ (arrayOfMoviesClass , totalPagesClass) in
                    
                            self.arrayOfMovies = arrayOfMoviesClass
                            lastItemOfArray = arrayOfMoviesClass.last?.title ?? ""
                            
                            page = 1
                            totalPages = totalPagesClass
                            
                            print("lastItemOfArray -\(lastItemOfArray)")
                            print("page - \(page)")
                            print("totalPages - \(totalPages)")
                            
                        }
                        
                    } else {
                        
                        arrayOfMovies.append(movies(title: "The search text contains a invalid character", releaseDate: "", overview: "", posterPath: ""))
                    }
                        
                } else {
                    
                    page = 1
                    route = "discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(String(page))&with_watch_monetization_types=flatrate"
                    
                    API().getMovies( arrayView: arrayOfMovies, route: route){ ( arrayOfMoviesClass , totalPagesClass ) in
                        
                        self.arrayOfMovies = arrayOfMoviesClass
                        lastItemOfArray = arrayOfMoviesClass.last!.title
                        totalPages = totalPagesClass
                        
                        print("lastItemOfArray - \(lastItemOfArray)")
                        print("totalPages - \(totalPages)")
                        
                    }
                    
                
                }
                
            }
            
        }
        .padding()
        .onAppear{
            //Ao entrar no app
            route = "discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(String(page))&with_watch_monetization_types=flatrate"
            
            API().getMovies( arrayView: arrayOfMovies, route: route){ ( arrayOfMoviesClass , totalPagesClass ) in
                
                self.arrayOfMovies = arrayOfMoviesClass
                lastItemOfArray = arrayOfMoviesClass.last!.title
                totalPages = totalPagesClass
                
                print("lastItemOfArray - \(lastItemOfArray)")
                print("totalPages - \(totalPages)")
                
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
