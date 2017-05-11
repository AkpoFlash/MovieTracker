//
//  MoviesStoryTests.swift
//  MoviesStoryTests
//
//  Created by Кирилл Анисимов on 04.05.17.
//  Copyright © 2017 Кирилл Анисимов. All rights reserved.
//

import XCTest
@testable import MoviesStory

class MoviesStoryTests: XCTestCase {
    
    //MARK: Movie Class Tests
    
    // Confirm that the Movie initializer returns a Movie object when passed valid parameters.
    func testMovieInitializationSucceeds(){
        // Zero rating
        let zeroRatingMovie = Movie.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMovie)
        
        // Highest positive rating
        let highestRatingMovie = Movie.init(name: "Highest", photo: nil, rating: 5)
        XCTAssertNotNil(highestRatingMovie)
    }
    
    // Confirm that the Movie initializer returns nil when passed a negative rating or an empty name.
    func testMovieInitializationFails(){
        // Negative rating
        let negativeRatingMovie = Movie.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMovie)
        
        // Rating exceeds maximum
        let largeRatingMovie = Movie.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMovie)
        
        // Empty string
        let emptyStringMovie = Movie.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMovie)
    }
    
}
