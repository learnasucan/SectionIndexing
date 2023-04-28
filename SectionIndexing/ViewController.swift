//
//  ViewController.swift
//  SectionIndexing
//
//  Created by Prachit on 28/04/23.
//

import UIKit

// Struct to hold country name and phone code
struct Country {
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
        let countries = [
            Country(name: "USA", phoneCode: "+1"),
            Country(name: "Afghanistan", phoneCode: "+93"),
            Country(name: "Albania", phoneCode: "+355"),
            Country(name: "Algeria", phoneCode: "+213"),
            Country(name: "Andorra", phoneCode: "+376"),
            Country(name: "Angola", phoneCode: "+244"),
            Country(name: "Antigua and Barbuda", phoneCode: "+12"),
            Country(name: "Argentina", phoneCode: "+54"),
            Country(name: "Armenia", phoneCode: "+374"),
            Country(name: "Australia", phoneCode: "+61"),
            Country(name: "Austria", phoneCode: "+43"),
            Country(name: "Azerbaijan", phoneCode: "+994"),
            Country(name: "Bahamas", phoneCode: "+1"),
            Country(name: "Bahrain", phoneCode: "+973"),
            Country(name: "Bangladesh", phoneCode: "+880"),
            Country(name: "Barbados", phoneCode: "+12F+"),
            Country(name: "Belarus", phoneCode: "+375"),
            Country(name: "Belgium", phoneCode: "+32"),
            Country(name: "Belize", phoneCode: "+501"),
            Country(name: "Benin", phoneCode: "+229"),
            Country(name: "Bhutan", phoneCode: "+975"),
            Country(name: "Bolivia", phoneCode: "+591"),
            Country(name: "Bosnia and Herzegovina", phoneCode: "+387"),
            Country(name: "Botswana", phoneCode: "+267"),
            Country(name: "Brazil", phoneCode: "+55"),
            Country(name: "Brunei", phoneCode: "+673"),
            Country(name: "Bulgaria", phoneCode: "+359"),
            Country(name: "Burkina Faso", phoneCode: "+226"),
            Country(name: "Burundi", phoneCode: "+257"),
            Country(name: "Cabo Verde", phoneCode: "+238"),
            Country(name: "Cambodia", phoneCode: "+855"),
            Country(name: "Cameroon", phoneCode: "+237"),
            Country(name: "Canada", phoneCode: "+13"),
            Country(name: "Central African Republic (CAR)", phoneCode: "+236"),
            Country(name: "Chad", phoneCode: "+235"),
            Country(name: "Chile", phoneCode: "+56"),
            Country(name: "China", phoneCode: "+86"),
            Country(name: "Colombia", phoneCode: "+57"),
            Country(name: "Comoros", phoneCode: "+269"),
            Country(name: "Congo, Democratic Republic of the", phoneCode: "+243"),
            Country(name: "Congo, Republic of the", phoneCode: "+242"),
            Country(name: "Costa Rica", phoneCode: "+506"),
            Country(name: "Cote d'Ivoire", phoneCode: "+225"),
            Country(name: "Croatia", phoneCode: "+385"),
            Country(name: "Cuba", phoneCode: "+53"),
            Country(name: "Cyprus", phoneCode: "+357"),
            Country(name: "Czech Republic (Czechia)", phoneCode: "+420"),
            Country(name: "Denmark", phoneCode: "+45"),
            Country(name: "Djibouti", phoneCode: "+253"),
            Country(name: "Dominica", phoneCode: "+1-767"),
            Country(name: "Dominican Republic", phoneCode: "+1-809, +1-829, +1-849"),
            Country(name: "Ecuador", phoneCode: "+593"),
            Country(name: "Egypt", phoneCode: "+20"),
            Country(name: "El Salvador", phoneCode: "+503"),
            Country(name: "Equatorial Guinea", phoneCode: "+240"),
            Country(name: "Eritrea", phoneCode: "+291"),
            Country(name: "Estonia", phoneCode: "+372"),
            Country(name: "Eswatini (formerly Swaziland)", phoneCode: "+268"),
            Country(name: "Ethiopia", phoneCode: "+251"),
            Country(name: "Fiji", phoneCode: "+679"),
            Country(name: "Finland", phoneCode: "+358"),
            Country(name: "France", phoneCode: "+33"),
            Country(name: "Gabon", phoneCode: "+241"),
            Country(name: "Gambia", phoneCode: "+220"),
            Country(name: "Georgia", phoneCode: "+995"),
            Country(name: "Germany", phoneCode: "+49"),
            Country(name: "Ghana", phoneCode: "+233"),
            Country(name: "Greece", phoneCode: "+30"),
            Country(name: "Grenada", phoneCode: "+1-473"),
            Country(name: "Guatemala", phoneCode: "+502"),
            Country(name: "Guinea", phoneCode: "+224"),
            Country(name: "Guinea-Bissau", phoneCode: "+245"),
            Country(name: "Guyana", phoneCode: "+592"),
            Country(name: "Haiti", phoneCode: "+509"),
            Country(name: "Honduras", phoneCode: "+504"),
            Country(name: "Hungary", phoneCode: "+36"),
            Country(name: "Iceland", phoneCode: "+354"),
            Country(name: "India", phoneCode: "+91"),
            Country(name: "Indonesia", phoneCode: "+62"),
            Country(name: "Iran", phoneCode: "+98"),
            Country(name: "Iraq", phoneCode: "+964"),
            Country(name: "Ireland", phoneCode: "+353"),
            Country(name: "Israel", phoneCode: "+972"),
            Country(name: "Italy", phoneCode: "+39"),
            Country(name: "Jamaica", phoneCode: "+1-876"),
            Country(name: "Japan", phoneCode: "+81"),
            Country(name: "Jordan", phoneCode: "+962"),
            Country(name: "Kazakhstan", phoneCode: "+7"),
            Country(name: "Kenya", phoneCode: "+254"),
            Country(name: "Kiribati", phoneCode: "+686"),
            Country(name: "Kosovo", phoneCode: "+383"),
            Country(name: "Kuwait", phoneCode: "+965"),
            Country(name: "Kyrgyzstan", phoneCode: "+996"),
            Country(name: "Laos", phoneCode: "+856"),
            Country(name: "Latvia", phoneCode: "+371"),
            Country(name: "Lebanon", phoneCode: "+961"),
            Country(name: "Lesotho", phoneCode: "+266"),
            Country(name: "Liberia", phoneCode: "+231"),
            Country(name: "Libya", phoneCode: "+218"),
            Country(name: "Liechtenstein", phoneCode: "+423"),
            Country(name: "Lithuania", phoneCode: "+370"),
        ]
        
        return countries
    }
    
}
