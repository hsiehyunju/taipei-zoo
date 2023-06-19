//
//  AreaInfoViewController.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/17.
//

import UIKit
import RxSwift
import RxCocoa
import Stevia

class AreaInfoViewController: UIViewController {
    
    var viewModel: AreaInfoViewModel!
    private var disposeBag = DisposeBag()
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let areaIntro = UITextView()
    private let plantTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    func setupUI() {
        self.view.subviews(titleLabel, imageView, areaIntro, plantTableView)
        
        // 標題定義
        titleLabel.Top == view.safeAreaLayoutGuide.Top
        titleLabel.width(80%)
        titleLabel.centerHorizontally()
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 17.0)
        
        // 圖片定義
        imageView.Top == titleLabel.Bottom + 10
        imageView.width(80%)
        imageView.centerHorizontally()
        imageView.height(30%)
        
        // 介紹定義
        areaIntro.Top == imageView.Bottom + 10
        areaIntro.width(80%)
        areaIntro.centerHorizontally()
        areaIntro.height(20%)
        
        // Table View
        plantTableView.Top == areaIntro.Bottom + 10
        plantTableView.Bottom == view.safeAreaLayoutGuide.Bottom
        plantTableView.width(80%)
        plantTableView.centerHorizontally()
        plantTableView.register(PlantTableViewCell.self, forCellReuseIdentifier: "PlantTableViewCell")
        
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
