/*
 Jonathan Nunez
 APL Section 01
 Code Exercise: Debugging
 */

import UIKit

class BowlerEditor: UIViewController {

    // MARK: Preparations
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var hometownField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var scoreField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    var bowlerData: [Bowler]?
    var bowlerID: Int?
    var largestID = 0 //This allows us to know what the new UniqueID should be for any elements that get added to the array. For instance, if this is 4, the next unique ID generated will be 5.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Sets the values of the text fields to that of the object being edited, if the user has chosen to edit rather than create a new object.
        if let id = bowlerID, let data = bowlerData {
            for bowler in data {
                if id == bowler.uniqueID {
                    nameField.text = bowler.name
                    hometownField.text = bowler.town
                    stateField.text = bowler.state
                    scoreField.text = "\(bowler.score)"
                    dateField.text = bowler.date
                    break
                }
            }
        } else {
            //Loops through each bowler to determine what the largest unique ID currently being used is, so that we know what to set the new bowler to.
            if let data = bowlerData {
                for bowler in data {
                    if bowler.uniqueID >= largestID {
                        largestID = bowler.uniqueID
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Dismisses the current view controller without saving anything. Used for the 'Back' button.
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    /*Checks to verify that each of the fields has valid data in it.
    If so, also checks to verify if the bowling score is a valid score between 0-300.
    If editing, this will find and overwrite the appropriate element in the array.
    If adding, this will append a new element to the existing array.
    If everything checks out, it will trigger an unwind segue to the first ViewController.*/
    @IBAction func saveNewScore() {
        if let name = nameField.text, let hometown = hometownField.text, let state = stateField.text, let score = scoreField.text, let date = dateField.text {
            if name.isEmpty == false && hometown.isEmpty == false && state.isEmpty == false && score.isEmpty == false && date.isEmpty == false {
                let thisScore = Int(score) ?? 301
                if thisScore > 300 || thisScore < 0 {
                    let alert = UIAlertController(title: "Invalid Score", message: "A bowling score must between the values of 0 and 300.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okButton)
                    present(alert, animated: true)
                } else if let savedBowler = bowlerID, let savedData = bowlerData {
                    for (offset,bowler) in savedData.enumerated() {
                        if bowler.uniqueID == savedBowler {
                            bowler.name = name
                            bowler.town = hometown
                            bowler.state = state
                            bowler.score = thisScore
                            bowler.date = date
                            bowlerData?[offset] = bowler
                        }
                    }
                    performSegue(withIdentifier: "backToFirst", sender: nil)
                } else {
                    let newBowler = Bowler(name: name, town: hometown, state: state, score: thisScore, date: date, uniqueID: largestID+1)
                    bowlerData?.append(newBowler)
                    performSegue(withIdentifier: "backToFirst", sender: nil)
                }
            } else {
                let alert = UIAlertController(title: "Invalid Data", message: "Ensure that all text fields have data in them before proceeding.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                present(alert, animated: true)
            }
        }
    }
    
    //Functions for creating a date picker when the date text field is selected.
    @IBAction func dateTextField(_ sender: UITextField) {        let
        //Gets today's date to set the default text of that field to today.
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateField.text = dateFormatter.string(from: Date())
        
        //Converts the keyboard to a datepicker instead.
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(BowlerEditor.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    //Formats the date properly anytime the date in the date picker changes.
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateField.text = dateFormatter.string(from: sender.date)
    }
    
    //Dismisses the keyboard/date picker when the view is tapped.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }

}
