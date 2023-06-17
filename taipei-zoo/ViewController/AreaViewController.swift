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
                            return UIImage(data: data)
                        }
                        .observe(on: MainScheduler.instance) // 確保更新UI的程式碼在主線程運行

                    // 將下載的圖片綁定到imageView
                    imageObservable
                .bind(to: cell.areaImage.rx.image)
                .disposed(by: self.disposeBag)
            
/*
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.areaImage.image = image
                    }
                }
            }

            task.resume()
             
*/
            
        }.disposed(by: disposeBag)
    }
}

extension AreaViewController: UITableViewDelegate {}
