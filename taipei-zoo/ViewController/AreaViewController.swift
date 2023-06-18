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
    
    var viewModel: AreaViewModel!
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
        ) { _, model, cell in
            cell.areaModel = model
            cell.setupUI()
        }.disposed(by: disposeBag)
        
        areaTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let cell = self.areaTableView.cellForRow(at: indexPath) as! AreaTableViewCell
                self.viewModel.goAreaInfoPage(data: cell.areaModel!)
            })
            .disposed(by: self.disposeBag)
    }
}

extension AreaViewController: UITableViewDelegate {}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        self.draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
