import UIKit
import SwiftUI


struct Response: Codable {
    let preference: String?
    let pagination: Pagination
    let data: [Artwork]
    let info: Info
    let config: Config
}

struct Pagination: Codable {
    let total: Int
    let limit: Int
    let offset: Int
    let totalPages: Int
    let currentPage: Int

    enum CodingKeys: String, CodingKey {
        case total, limit, offset
        case totalPages = "total_pages"
        case currentPage = "current_page"
    }
}

struct Artwork: Codable {
    let score: Double
    let id: Int
    let imageID: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case score = "_score"
        case id, imageID = "image_id", title
    }
}

struct Info: Codable {
    let licenseText: String
    let licenseLinks: [String]
    let version: String

    enum CodingKeys: String, CodingKey {
        case licenseText = "license_text"
        case licenseLinks = "license_links"
        case version
    }
}

struct Config: Codable {
    let iiifURL: String
    let websiteURL: String

    enum CodingKeys: String, CodingKey {
        case iiifURL = "iiif_url"
        case websiteURL = "website_url"
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let loadedImage = UIImage(data: data) {
                    self?.image = loadedImage
                }
            }
        }
        task.resume()
    }
}


class TableViewController: UITableViewController {

    private static let tableViewCellReuseIdentifier = "weeeeeee"
    
    var artworks = [Artwork]()
    var iiifURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            TableViewCell.self, forCellReuseIdentifier: TableViewController.tableViewCellReuseIdentifier
        )

        makeAPIcall()
    }
    
    
    func makeAPIcall(){
            
            print("Start api call")
            
            let domain = "https://api.artic.edu/api/v1/artworks/search?query[term][is_public_domain]=true&fields=id,title,image_id"
            let limit = 15
            guard let url = URL(string: "\(domain)&limit=\(limit)") else { return }
            print(url)
            let task = URLSession.shared.dataTask(with: url) {
                data, response, error in print("Done with call")
                if let error = error {
                    print("Error with API call: \(error)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response(\(String(describing:response))")
                    return
                }

                if let data = data,
                   let response = try? JSONDecoder().decode(Response.self, from: data){

                    let artworks = response.data
                    self.artworks = artworks
                    let iiifURL = response.config.iiifURL
                    self.iiifURL = iiifURL
                    print(artworks[0].title)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                } else {
                    print("something is wrong")
                }
                
            }
            task.resume()
        }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewController.tableViewCellReuseIdentifier,
            for: indexPath
        ) as? TableViewCell
        else { return UITableViewCell() }

        let artwork = artworks[indexPath.row]
        cell.titleLabel.text = artwork.title
        print(indexPath.row)
        let imageURL = "\(iiifURL ?? "")/\(artwork.imageID)/full/843,/0/default.jpg"
        print(imageURL)
        cell.artworkImageView.loadFrom(URLAddress: imageURL)

        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artworks.count
    }

}

