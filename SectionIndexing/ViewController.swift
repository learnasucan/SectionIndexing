//
//  ViewController.swift
//  SectionIndexing
//
//  Created by Prachit on 28/04/23.
//

import UIKit

// Struct to hold country name and phone code
struct Country: Codable {
    let name: String
    let phoneCode: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var countries = [Country]()
    var countryDict = [String: [Country]]()
    
    var sectionTitle = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries = getData()
        
        //"A", "B"......
        sectionTitle = Array(Set(countries.compactMap{ String($0.name.prefix(1))})).sorted()
        
        // ["A": [Country](), "B": [Country](), ...]
        for stitle in sectionTitle {
            countryDict[stitle] = [Country]()
        }
        
        // ["A": [Country], "B": [Country], ...]
        for country in countries {
            let firstLetter = String(country.name.prefix(1))
            countryDict[firstLetter]?.append(country)
        }
        
        
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryDict[sectionTitle[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = myTable.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        
        let sectionLetter = sectionTitle[indexPath.section]
        let country = countryDict[sectionLetter]?[indexPath.row]
        
        cell.textLabel?.text = country?.name ?? ""
        cell.detailTextLabel?.text = country?.phoneCode
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    //Right side titlelist
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitle
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Reset table to show all countries
            countries = getData()// Add more countries here...
        } else {
            // Filter countries based on search text and case sensitivity
            let isCaseSensitive = searchBar.selectedScopeButtonIndex == 1
            countries = countries.filter { country in
                if isCaseSensitive {
                    return country.name.contains(searchText) ||
                    country.phoneCode.contains(searchText)
                } else {
                    return country.name.lowercased().contains(searchText.lowercased()) ||
                    country.phoneCode.contains(searchText)
                }
            }
            
            countries.sort { (a, b) -> Bool in
                let aContains = a.name.lowercased().contains(searchText.lowercased()) || a.phoneCode.contains(searchText)
                let bContains = b.name.lowercased().contains(searchText.lowercased()) || b.phoneCode.contains(searchText)
                
                if aContains && bContains {
                    if a.phoneCode.contains(searchText) && !b.phoneCode.contains(searchText) {
                        return true
                    } else if !a.phoneCode.contains(searchText) && b.phoneCode.contains(searchText) {
                        return false
                    } else
                    if a.name.lowercased().contains(searchText.lowercased()) && b.name.lowercased().contains(searchText.lowercased()) {
                        // Both countries contain the search text in their name
                        return a.name.lowercased().range(of: searchText.lowercased())!.lowerBound < b.name.lowercased().range(of: searchText.lowercased())!.lowerBound
                    } else if a.name.lowercased().contains(searchText.lowercased()) {
                        // Only a contains the search text in its name
                        return true
                    } else if b.name.lowercased().contains(searchText.lowercased()) {
                        // Only b contains the search text in its name
                        return false
                    } else {
                        // Neither contains the search text in their name, so sort by phone code
                        return a.phoneCode < b.phoneCode
                    }
                } else if aContains {
                    // Only a contains the search text
                    return true
                } else {
                    // Only b contains the search text
                    return false
                }
            }
            
        }
        // Rebuild dictionary based on filtered countries
        countryDict.removeAll()
        sectionTitle.removeAll()
        for country in countries {
            let firstLetter = String(country.name.prefix(1))
            if var countryList = countryDict[firstLetter] {
                countryList.append(country)
                countryDict[firstLetter] = countryList
            } else {
                countryDict[firstLetter] = [country]
                sectionTitle.append(firstLetter)
            }
        }
        
        // Sort section titles in alphabetical order
        //        sectionTitle = sectionTitle.sorted()
        
        // Refresh table with new data
        myTable.reloadData()
    }
}



extension ViewController {
    func getData() -> [Country] {
        guard let path = Bundle.main.path(forResource: "countries", ofType: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let countries = try JSONDecoder().decode([Country].self, from: data)
            return countries
        } catch {
            return []
        }
    }
}
