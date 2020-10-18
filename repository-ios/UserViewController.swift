//
//  ViewController.swift
//  repository-ios
//
//  Created by Zhaolong Zhong on 10/17/20.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var names = ["hello 0", "hello 1", "hello 2", "hello 3", "hello 4", "hello 5"]
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = 64
        view.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        view.separatorStyle = .none
        view.sectionIndexColor = .blue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // For each UIViewController, there's a root "view".
        view.backgroundColor = UIColor.white
        
        setUpTableView()
        
        fetchUserData()
    }
    
    private func setUpTableView() {
        // Add tableView to root "view"
        view.addSubview(tableView)
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set table view layout margin
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(indexPath.row)")
        showToast(message: "selected: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        
        cell.title = names[indexPath.row]
        
        return cell
    }

    struct UserResponse: Codable {
        var login: String
        var avatar_url: String
    }
    
    func fetchUserData() {
        let url = URL(string: "https://api.github.com/users/eclipsegst/followers")!
        let request = URLRequest(url: url)
        
        // An async task that execute a job in a background thread
        let session = URLSession(configuration: .default)
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main) // This session will be on main thread
        
        let getUsersTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("error: \(error)")
            } else if let data = data {
                // Decode raw data to an array of UserResponse
                let dataDictionary = try! JSONDecoder().decode([UserResponse].self, from: data)
                print("URLSessionDataTask thread: \(Thread.current), dataDictionary[0]:\(dataDictionary[0])")
                
                let logins = dataDictionary.map { $0.login }
                
                DispatchQueue.main.async {
                    self.names = logins
                    self.tableView.reloadData()
                }
            }
        }
        
        getUsersTask.resume()
    }
    
    func showToast(message : String, font: UIFont = .systemFont(ofSize: 12.0)) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

