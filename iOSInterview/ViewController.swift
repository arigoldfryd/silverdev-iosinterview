//
//  ViewController.swift
//  iOSInterview
//
//  Created by Ariel on 11/05/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filters: UIPickerView!
    
    private var currentChain: Chain? = nil
    private var currentPage: Int = 0
    
    private let filtersList: [Chain] = Chain.allCases
    private let api = API()
    private var nftList: [NFT] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        nftList = api.getRankings()
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distanceToBottom = scrollView.contentSize.height - ( scrollView.contentOffset.y + scrollView.frame.height )
        
        if distanceToBottom <= 0 {
            currentPage += 1
            nftList = api.getRankings(page: currentPage, chain: currentChain)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nftList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NFTCell") as? NFTTableViewCell else {
            return UITableViewCell()
        }
        
        let nft = nftList[indexPath.row]
        
        cell.rank.text = String(describing: indexPath.row)
        cell.name.text = nft.name
        cell.floorPrice.text = nft.floorPrice
        cell.floorPriceChange.text = nft.floorPriceChange
        
        cell.nftImage.layer.cornerRadius = cell.nftImage.frame.height / 2
        cell.nftImage.contentMode = .scaleAspectFill
        
        // Get Image
        if let url = URL(string: nft.imageUrl) {
            let urlSession = URLSession(configuration: .default)
            let dataTask = urlSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let _ = response, let data = data else {
                    return
                }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    cell.nftImage.image = image
                }
            }
            dataTask.resume()
        }
        
        return cell
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "ALL"
        }
        
        return filtersList[row-1].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            nftList = api.getRankings()
            currentChain = nil
            return
        }
        
        currentChain = filtersList[row-1]
        nftList = api.getRankings(chain: currentChain)
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        filtersList.count + 1
    }
}
