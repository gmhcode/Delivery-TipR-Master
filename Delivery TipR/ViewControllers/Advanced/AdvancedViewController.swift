//
//  AdvancedViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/13/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class AdvancedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
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
extension AdvancedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension AdvancedViewController {
    func setupViews(){
        
        navigationItem.title = "Advanced"
        navigationController?.navigationBar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.layer.borderWidth = 1
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.layer.cornerRadius = 10
        navigationController?.navigationBar.clipsToBounds = true
        
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = #colorLiteral(red: 0.1456923485, green: 0.1448334754, blue: 0.1463571787, alpha: 1)
        tableView.layer.masksToBounds = true
    }
}
