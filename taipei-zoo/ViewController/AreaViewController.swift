//
//  ViewController.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/16.
//

import UIKit
import RxSwift
import RxCocoa

class AreaViewController: UIViewController {
    
    
    @IBOutlet var areaTableView: UITableView!
    
    private var viewModel = AreaViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableData()
        viewModel.fetchData()
    }
    
    func bindTableData() {
        
        areaTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.items.bind(
            to: areaTableView.rx.items(
                cellIdentifier: "AreaTableViewCell", cellType: AreaTableViewCell.self)
        ) { row, model, cell in
            
            cell.areaName?.text = model.name
            
        }.disposed(by: disposeBag)
    }
}

extension AreaViewController: UITableViewDelegate {}
