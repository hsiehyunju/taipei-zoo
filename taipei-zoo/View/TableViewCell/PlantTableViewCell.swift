//
//  PlantTableViewCell.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/18.
//

import UIKit
import RxSwift
import RxCocoa
import Stevia

class PlantTableViewCell: UITableViewCell {
    
    private let plantName = UILabel()
    private let plantImage = UIImageView()
    
    private let disposeBag = DisposeBag()
    var plantModel: PlantUIModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 新增 label、image view 到 TableView ContentView 內
        self.contentView.subviews(plantName, plantImage)
        plantName.centerVertically().left(0).width(80%)
        plantImage.centerVertically().right(0).height(100%).width(20%)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        
        plantName.text = plantModel?.name
        
        let url = plantModel!.picURL.replacingOccurrences(of: "http://", with: "https://")
        guard let imageURL = URL(string: url) else { return }
        
        let imageObservable = URLSession.shared.rx.data(request: URLRequest(url: imageURL))
            .flatMap { data -> Observable<UIImage?> in
                var image: UIImage?
                image = UIImage(data: data)
                image = image?.resize(to: CGSize(width: self.plantImage.bounds.width, height: self.plantImage.bounds.height))
                return .just(image)
            }
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<UIImage?> in
                print("Image download error: \(error)")
                return .just(UIImage(systemName: "photo.fill"))
            }

        // 將下載的圖片綁定到imageView
        imageObservable
            .bind(to: plantImage.rx.image)
            .disposed(by: disposeBag)
    }
}
