//
//  SearchViewController.swift
//  location search
//
//  Created by Admin on 24/12/22.
//

import UIKit
import CoreLocation

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ vc: SearchViewController, didSelectLocationwith coordinate: CLLocationCoordinate2D?)
}
class SearchViewController: UIViewController, UITextFieldDelegate{
    
    weak var delegate: SearchViewControllerDelegate?

    private let lable: UILabel = {
        let lable = UILabel()
        lable.text = "Where to?"
        lable.font = .systemFont(ofSize: 24, weight: .semibold)
        return lable
    }()
    
    private let field: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter destination"
        field.layer.cornerRadius = 9
        field.backgroundColor = .tertiarySystemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        return field
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    var location = [Location]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(lable)
        view.addSubview(field)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .blue
        field.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lable.sizeToFit()
        lable.frame = CGRect(x: 10, y: 10, width: lable.frame.size.width, height: lable.frame.size.height)
        field.frame = CGRect(x: 10, y: 20+lable.frame.size.height, width: view.frame.size.width-20, height: 50)
        let tableBottom: CGFloat = field.frame.origin.y+field.frame.size.height+5
        tableView.frame = CGRect(x: 0, y: tableBottom, width: view.frame.size.width, height: view.frame.size.height-tableBottom)
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        if let text = field.text, !text.isEmpty {
            LocationManager.shared.findLocation(with: text) { [weak self] location in
                DispatchQueue.main.async {
                    self?.location = location
                    self?.tableView.reloadData()
                    print("location we are under main thread")
                }
            }
        }
        return true
    }

}

extension SearchViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = location[indexPath.row].title
   //     cell.textLabel?.text = "hello"
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .black
        cell.backgroundColor = .black
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            //notify map controller to show pin at selected place
        let cordinate = location[indexPath.row].coordinate
        delegate?.searchViewController(self, didSelectLocationwith: cordinate)
    }
    
    
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.count
    }
    
    
}
