/*
 Jonathan Nunez
 APL Section 01
 Code Exercise: Debugging
 */

import UIKit

class BowlingLeaderboard: UIViewController {
    
    // MARK: Preparations
    @IBOutlet weak var scoreboardDisplay: UITextView!
    @IBOutlet weak var bowlerID: UITextField!
    @IBOutlet weak var editBowlerButton: UIButton!
    @IBOutlet weak var addBowlerButton: UIButton!
    
    //Initialize some default data to test with
    var bowlerData: [Bowler] = Bowler.createDefaultData()

    override func viewDidLoad() {
        super.viewDidLoad()
        displayBowlerLeaderboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //The below function creates a new array by sorting the elements of the array that holds bowler data based on who has the largest score property. It checks each elements against each other element and places the elements of the array according to where it falls in order.
    func sortData(data: [Bowler]) -> [Bowler] {
        var newData: [Bowler] = []
        for (offset,bowler) in data.enumerated() {
            if offset == 0 {
                newData += [bowler]
            } else {
                for (offset,newBowler) in newData.enumerated() {
                    if bowler.score >= newBowler.score {
                        newData.insert(bowler, at: offset)
                        break
                    } else if offset == (newData.count - 1) {
                        newData.append(bowler)
                    }
                }
            }

        }
        return newData
   }
    
    //Creates a readable string that is used later in a method to display the leaderboard.
    func createLeaderboard(data: [Bowler]) -> String {
        var bowlerString = ""
        for bowler in data {
            bowlerString += "Score: \(bowler.score) by \(bowler.name) from \(bowler.hometown) on \(bowler.date). ID: \(bowler.uniqueID)."
            if !bowler.perfectScore {
                bowlerString += " ** PERFECT GAME **"
            }
            bowlerString += "\n\n"
        }
        return bowlerString
    }
    
    //Checks to see if the editor has been clicked or not and, if it has, sends across the ID that was entered.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editor = segue.destination as! BowlerEditor
        let button = sender as! UIButton?
        editor.bowlerData = bowlerData
        if let clicked = button {
            if clicked.tag == 1 {
                if bowlerID.text?.isEmpty == false {
                    if let textEntry = bowlerID.text {
                        editor.bowlerID = Int(textEntry)
                    }
                }
            }
        }
    }
    
    //Takes the sorted array and displays the text to the leaderboard.
    func displayBowlerLeaderboard() {
        bowlerData = sortData(data: bowlerData)
        let leaderboardString = createLeaderboard(data: bowlerData)
        scoreboardDisplay.text = leaderboardString
    }
    
    //Calls for the segue to the BowlerEditor; validates if a valid ID was entered or not if the Edit button was clicked.
    @IBAction func addOrEditBowler(sender: UIButton?) {
        if let clicked = sender {
            if clicked.tag == 1 {
                if bowlerID.text?.isEmpty == false {
                    if let textEntry = bowlerID.text {
                        if let enteredId = Int(textEntry) {
                            if enteredId < 1 || enteredId > bowlerData.count {
                                let alert = UIAlertController(title: "Invalid Id", message: "This Id was not found in the database. Please try again or add a new bowler.", preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(okButton)
                                present(alert, animated: true)
                            } else {
                                performSegue(withIdentifier: "toEditor", sender: sender)
                            }
                        }
                    }
                }
            } else {
                performSegue(withIdentifier: "toEditor", sender: sender)
            }
        }
    }
    
    //Alternates between the shown/hidden buttons based on whether or not there is anything typed into the ID field.
    @IBAction func unhideEditButton() {
        if bowlerID?.text?.isEmpty == false {
            editBowlerButton.isHidden = false
            addBowlerButton.isHidden = true
        } else {
            editBowlerButton.isHidden = true
            addBowlerButton.isHidden = false
        }
    }
    
    //Unwinds back from the BowlerEditor with whatever new data has been created.
    @IBAction func newBowlerData(segue: UIStoryboardSegue) {
        let editor = segue.source as! BowlerEditor
        if let newData = editor.bowlerData {
            self.bowlerData = newData
        }
        displayBowlerLeaderboard()
    }
    
}

