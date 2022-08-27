//
//  CryptoListViewController.swift
//  CryptoList
//
//  Created by abdul ahad  on 11/02/22.
//

import UIKit

class CryptoListViewController: UITableViewController {
    var viewModel: CryptoListViewModel?
    var select: (String) -> Void = { _ in }
    var viewIsReady: () -> Void = {}

    private var coins: [Coin] = []
        
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CryptoList"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        viewIsReady()
        
        viewModel?.onCoinsLoading = { [weak self] isloading in
            if isloading {
                self?.refreshControl?.beginRefreshing()
            }else{
                self?.refreshControl?.endRefreshing()
            }
        }
        viewModel?.add(onCoinsLoad: { [weak self] coins in
            self?.coins = coins
            self?.tableView.reloadData()
 
        })
        
        viewModel?.onCoinsError = { [weak self] error in
             self?.handle(error) {
                self?.viewModel?.fetchCoins()
            }
            
        }
        
    }
    
    @objc private func refresh(_ sender: Any) {
         viewModel?.fetchCoins()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         viewModel?.fetchCoins()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell") as! CryptoCell
        let coin = coins[indexPath.row]
        let vm = CryptoItemViewModel(coin: coin, livePrice: coin.price)
        cell.configure(vm)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        select(coins[indexPath.row].symbol)
    }
    
    
    func didRecieveNewCoinPrice(newCoinPrice:NewCoinPrice) {
        if let row: Int = self.coins.firstIndex(where: {$0.symbol == newCoinPrice.symbol}) {
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! CryptoCell?
            
            coins[row].update(with: newCoinPrice)
            let vm = CryptoItemViewModel(coin: self.coins[row], livePrice: newCoinPrice.price)
            cell?.configure(vm)
            
        }
    }
    
}

 
