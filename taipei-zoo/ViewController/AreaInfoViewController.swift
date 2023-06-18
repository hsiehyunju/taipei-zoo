//
//  AreaInfoViewController.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/17.
//

import UIKit
import RxSwift
import RxCocoa

class AreaInfoViewController: UIViewController {
    
    var viewModel: AreaInfoViewModel!
    private var disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var areaIntro: UITextView!
    @IBOutlet var plantTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        
        viewModel.plantModelArray.bind(
            to: plantTableView.rx.items(
                cellIdentifier: "PlantTableViewCell", cellType: PlantTableViewCell.self)
        ) { _, model, cell in
            cell.plantModel = model
            cell.setupUI()
        }.disposed(by: disposeBag)
        
        viewModel.fetchData()
    }
    
    func bindUI() {
        
        self.titleLabel.text = viewModel.getName()
        self.areaIntro.text = viewModel.getIntro()
        
        let imageObservable = URLSession.shared.rx.response(request: URLRequest(url: viewModel.getImageURL()))
            .map{ response, data -> UIImage? in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    return UIImage(systemName: "photo.fill")
                }
                
                print("status code = \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 404 {
                    print("enter")
                    return UIImage(systemName: "photo.fill")
                }
                
                var image = UIImage(data: data)
                image = image?.resize(to: CGSize(width: self.imageView.bounds.width, height: self.imageView.bounds.height))
                return image
            }.observe(on: MainScheduler.instance)
        
        // 將下載的圖片綁定到imageView
        imageObservable
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
                
    }
}
