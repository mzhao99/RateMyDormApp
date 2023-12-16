//
//  StoreUniversity'.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/13/23.
//

import SwiftUI
import Firebase

// Define a struct for decoding JSON data
struct SchoolResponse: Codable {
    let results: [School]
}

struct School: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "school.name"
    }
}

// ViewModel to manage fetching and storing university data
class UniversityListViewModel: ObservableObject {
    @Published var universities: [String] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private var dbRef = Database.database().reference()
    
    init() {
        fetchUniversityDataIfNeeded()
    }
    
    func fetchUniversityDataIfNeeded() {
        isLoading = true
        dbRef.child("university").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self else { return }
            
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                self.fetchUniversityData()
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    // If data exists, use it to populate the universities array
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                           let value = snapshot.value as? [String: Any],
                           let name = value["name"] as? String {
                            self.universities.append(name)
                        }
                    }
                }
            }
        }) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.error = error
            }
        }
    }
    
    func fetchUniversityData() {
        let urlString = "https://api.data.gov/ed/collegescorecard/v1/schools.json?fields=school.name&api_key=0GybFNBBZr9kyVFq9WCcb8uZPxLJVxdzZAXCyebq"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.error = error
                }
                return
            }

            do {
                let schoolResponse = try JSONDecoder().decode(SchoolResponse.self, from: data)
                for school in schoolResponse.results {
                    self?.storeUniversityInFirebase(name: school.name)
                }
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.error = error
                }
            }
        }.resume()
    }
    
    private func storeUniversityInFirebase(name: String) {
        dbRef.child("university").childByAutoId().setValue(["name": name])
    }
}


// SwiftUI View

   

//// Check if data already exists in Firebase
//    func checkDataAndFetchIfNeeded() {
//        let ref = Database.database().reference()
//        ref.child("universities").observeSingleEvent(of: .value, with: { snapshot in
//            if !snapshot.exists() {
//                // Data not found, proceed to fetch and store data
//                fetchUniversityData()
//            } else {
//                // Data already exists, no need to fetch
//                print("Data already exists in Firebase, no need to fetch.")
//            }
//        })
//    }

//func fetchUniversityData() {
//    let urlString = "https://api.data.gov/ed/collegescorecard/v1/schools.json?fields=school.name&api_key=0GybFNBBZr9kyVFq9WCcb8uZPxLJVxdzZAXCyebq"
//    guard let url = URL(string: urlString) else { return }
//
//    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//        guard let data = data, error == nil else { return }
//
//        do {
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//               let results = json["results"] as? [[String: Any]] {
//                for school in results {
//                    if let schoolName = school["school.name"] as? String {
//                        storeUniversityInFirebase(name: schoolName)
//                    }
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }
//
//    task.resume()
//}
//
//func storeUniversityInFirebase(name: String) {
//        let ref = Database.database().reference()
//        ref.child("universities").childByAutoId().setValue(["name": name])
//    }
//let urlString = "https://api.data.gov/ed/collegescorecard/v1/schools.json?fields=school.name&api_key=0GybFNBBZr9kyVFq9WCcb8uZPxLJVxdzZAXCyebq"
