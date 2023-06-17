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
            
            let url = model.picURL.replacingOccurrences(of: "http", with: "https")
            guard let imageURL = URL(string: url) else { return }
            
            let imageObservable = URLSession.shared.rx.data(request: URLRequest(url: imageURL))
                        .map { data -> UIImage? in
                            var image = UIImage(data: data)
                            image = image?.resize(to: CGSize(width: cell.areaImage.bounds.width, height: cell.areaImage.bounds.height))
                            return image
                        }
                        .observe(on: MainScheduler.instance) // 確保更新UI的程式碼在主線程運行

                    // 將下載的圖片綁定到imageView
                    imageObservable
                .bind(to: cell.areaImage.rx.image)
                .disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
        
        areaTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print("你點了第\(indexPath)行")
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
