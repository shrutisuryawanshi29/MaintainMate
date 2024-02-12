//
//  ViewController.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/12/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "DashboardViewController") as! DashboardViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }

}

