//
//  MainViewModel.swift
//  CodeTest
//
//  Created by Thomas Romay on 26/10/2020.
//  Copyright © 2020 Thomas Romay. All rights reserved.
//

import Foundation
class MainViewModel {
    // MARK: - Parametres
    var sampleAPIHelper = SampleAPIHelper()
    var address: DynamicValue<String> = DynamicValue(String())
    var texCount: DynamicValue<String> = DynamicValue(String())
    var confrimedRecieved: DynamicValue<String> = DynamicValue(String())
    var confrimedUnspent: DynamicValue<String> = DynamicValue(String())
    
    var searchString = DynamicValue(String())
    // MARK: - ViewModel Action Methods:
    
    func onViewLoaded() {
        self.fetchDataFor(address: "tb1q9q8mmlwuxy75utn6v0dr72n3s5pec436dzkchu")
    }
    
    func onSearchStringUpdated(to value: String) {
        self.searchString.value = value
        self.fetchDataFor(address: value)
    }
    
    // MARK: - Private Funcs:
    func fetchDataFor(address: String) {
        self.sampleAPIHelper.getApiFeed(address: address) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let payload):
                if let address = payload?.address {
                    self.address.value = String(address)
                }
                if let txCount = payload?.chainStats.txCount {
                    self.texCount.value = String(txCount)
                }
                if let recieved = payload?.chainStats.fundedTxoSum {
                    let updated = Double(recieved) / 100000000
                    //2 outputs (0.00106102 tBTC)
                    self.confrimedRecieved.value = "\(self.texCount.value) outputs (\(updated) tBTC)"
                }
                if let spent = payload?.chainStats.spentTxoSum, let recieved = payload?.chainStats.fundedTxoSum {
                    let updated = Double(recieved - spent) / 100000000
                    self.confrimedUnspent.value = "\(self.texCount.value) outputs (\(updated) tBTC)"
                }
                //self.list = payload ?? []
                
            case .failure(let erro):
                print(erro)
            }
        }
    }
}
