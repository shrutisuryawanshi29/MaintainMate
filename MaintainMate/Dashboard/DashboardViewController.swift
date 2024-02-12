//
//  DashboardViewController.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/2/24.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var topViw: UIView!
    @IBOutlet weak var allHighlightedViw: UIView!
    @IBOutlet weak var openHighlightedViw: UIView!
    @IBOutlet weak var closeHighlightedViw: UIView!
    @IBOutlet weak var dbTblViw: UITableView!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    func initialSetup() {
        dbTblViw.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardTableViewCell")
        
        self.view.backgroundColor = Colors.shared.background
        Utils.shared.cornerRadius(view: topViw)
        
        Utils.shared.cornerRadius(view: closeHighlightedViw,radius: 3.0)
        Utils.shared.cornerRadius(view: allHighlightedViw,radius: 3.0)
        Utils.shared.cornerRadius(view: openHighlightedViw,radius: 3.0)
        
        addBtn.backgroundColor = Colors.shared.primaryDark
        Utils.shared.cornerRadius(view: addBtn, radius: 40.0)
    
        addBtn.setTitle(" ADD ISSUE", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
    }
    
    
    @IBAction func navigateToAddIssue(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddIssue", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "AddIssueViewController") as! AddIssueViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    @IBAction func handleTopCategoryClick(_ sender: UIButton) {
        if sender.tag == 10 {
            allHighlightedViw.isHidden = false
            closeHighlightedViw.isHidden = true
            openHighlightedViw.isHidden = true
        }
        else if sender.tag == 20 {
            allHighlightedViw.isHidden = true
            closeHighlightedViw.isHidden = true
            openHighlightedViw.isHidden = false
        }
        else if sender.tag == 30 {
            allHighlightedViw.isHidden = true
            closeHighlightedViw.isHidden = false
            openHighlightedViw.isHidden = true
        }
    }
    
    
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell", for: indexPath) as! DashboardTableViewCell
        cell.selectionStyle = .none
        Utils.shared.cornerRadius(view: cell.statusViw,radius: 8.0)
        Utils.shared.cornerRadius( view: cell.viewBtn)
        cell.viewBtn.backgroundColor = Colors.shared.primaryLight
        cell.statusViw.backgroundColor = indexPath.row % 2 == 0 ? .green : .red
        return cell
    }
    
    
}
