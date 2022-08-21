//
//  JsonObject.swift
//  Sample 2
//
//  Created by TechUnity IOS Developer on 20/08/22.
//

import Foundation

// MARK:- MovieResult

struct MovieResult:Decodable {
    let results : [MovieDetails]
}

struct MovieDetails:Decodable {
    let backdrop_path :String?
    let genre_ids :[Int]
    let id :Int?
    let poster_path :String?
    let release_date :String?
    var title = String()
    let overview :String?
    let vote_average :Double?
    let vote_count :Int?
    let original_language :String?
}

struct MovieInfo:Decodable {
    let genres : [Genre]
    let spoken_languages : [Launguage]
    let runtime : Int?
}

struct Genre:Decodable {
    let id :  Int?
    let name : String?
}
struct Launguage:Decodable {
    let english_name :  String?
}
