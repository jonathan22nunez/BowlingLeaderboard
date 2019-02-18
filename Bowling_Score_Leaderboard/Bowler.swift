/*
 Jonathan Nunez
 APL Section 01
 Code Exercise: Debugging
 */

import Foundation

class Bowler {
    
    var name: String
    var town: String
    var state: String
    var score: Int
    var date: String
    var uniqueID: Int
    
    var hometown: String {
        get {
            return "\(town), \(state)"
        }
    }
    
    //A quick way to validate whether a perfect score was achieved.
    var perfectScore: Bool {
        get {
            return score == 200
        }
    }
    
    init(name: String, town: String, state: String, score: Int, date: String, uniqueID: Int) {
        self.name = name
        self.town = town
        self.state = state
        self.score = score
        self.date = date
        self.uniqueID = uniqueID
    }
    
    //A Class function that allows the user to quickly generate a large amount of data for testing purposes.
    class func createDefaultData() -> [Bowler] {
        let bowlerOne = Bowler(name: "Gene Smith", town: "Hoboken", state: "New Jersey", score: 206, date: "6/11/17", uniqueID: 1)
        let bowlerTwo = Bowler(name: "Dan Douglas", town: "Dallas", state: "Texas", score: 253, date: "7/11/16", uniqueID: 2)
        let bowlerThree = Bowler(name: "Michael Hickenbottom", town: "San Antonio", state: "Texas", score: 300, date: "3/12/17", uniqueID: 3)
        let bowlerFour = Bowler(name: "Diana McGill", town: "Los Angeles", state: "California", score: 291, date: "4/7/17", uniqueID: 4)
        return [bowlerOne, bowlerTwo, bowlerThree, bowlerFour]
    }
    
}
