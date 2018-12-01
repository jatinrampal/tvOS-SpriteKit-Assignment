//
//  DetailsViewController.swift
//  tvOS-SpriteKit-Assignment
//
//  Created by Jatin Rampal on 2018-11-28.
//  Copyright © 2018 Jatin Rampal. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblHighScore : UILabel!
    
    func updatePerson(getData : GetData, select : Int){
        let rowData = (getData.dbData?[select])! as NSDictionary
        self.lblName.text = rowData["Name"] as? String
        self.lblHighScore.text = rowData["High Scores"] as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
