//
//  ViewController.swift
//  iQuiz
//
//  Created by Anthony  Wen on 5/5/25.
//

import UIKit

class ViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let quizSections = [
            "Mathematics",
            "Marvel Super Heroes",
            "Science"
        ]
    let quizDescriptions = [
        "1 + 1",
        "Avengers",
        "E = MC^2"
    ]
    let quizImages = [
        "math",
        "avengers",
        "science"]
    
    @IBAction func settingButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var quizTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return quizSections.count
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizTable.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as! quizTableTableViewCell
        
        cell.title1.text = quizSections[indexPath.row]
        cell.description1.text = quizDescriptions[indexPath.row]
        cell.image1.image = UIImage(named: quizImages[indexPath.row])
        cell.layoutIfNeeded()
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizTable.delegate = self
        quizTable.dataSource = self
        // Do any additional setup after loading the view.
    }
}

