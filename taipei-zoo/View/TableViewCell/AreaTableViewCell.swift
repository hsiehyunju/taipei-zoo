//
//  AreaTableViewCell.swift
//  taipei-zoo
//
//  Created by hsiehyunju on 2023/6/17.
//

import UIKit
import RxSwift
import RxCocoa
import Stevia

class AreaTableViewCell: UITableViewCell {
    
    private let areaName = UILabel()
    private let areaImage = UIImageView()
    private let disposeBag = DisposeBag()
    
    var areaModel: AreaModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 新增 label、image view 到 TableView ContentView 內
        self.contentView.subviews(areaName, areaImage)
        areaName.centerVertically().left(0).width(80%)
        areaImage.centerVertically().right(0).height(100%).width(20%)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        
        areaName.text = areaModel!.name
        
        let url = areaModel!.picURL.replacingOccurrences(of: "http", with: "https")
        guard let imageURL = URL(string: url) else { return }
        
        let imageObservable = URLSession.shared.rx.data(request: URLRequest(url: imageURL))
            .flatMap { data -> Observable<UIImage?> in
                var image: UIImage?
                image = UIImage(data: data)
                image = image?.resize(to: CGSize(width: self.areaImage.bounds.width, height: self.areaImage.bounds.height))
                return .just(image)
            }
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<UIImage?> in
                print("Image download error: \(error)")
                return .just(UIImage(systemName: "photo.fill"))
            }

        // 將下載的圖片綁定到imageView
        imageObservable
            .bind(to: areaImage.rx.image)
            .disposed(by: disposeBag)
    }
}
