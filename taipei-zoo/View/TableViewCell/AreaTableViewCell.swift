//
//  AreaTableViewCell.swift
//  taipei-zoo
//
//  Created by hsiehyunju on 2023/6/17.
//

import UIKit
import RxSwift
import RxCocoa

class AreaTableViewCell: UITableViewCell {

    @IBOutlet var areaName: UILabel!
    @IBOutlet weak var areaImage: UIImageView!
    
    private let disposeBag = DisposeBag()
    var areaModel: AreaModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        
        areaName.text = areaModel!.name
        
        let url = areaModel!.picURL.replacingOccurrences(of: "http", with: "https")
        guard let imageURL = URL(string: url) else { return }
        
        let imageObservable = URLSession.shared.rx.data(request: URLRequest(url: imageURL))
                    .map { data -> UIImage? in
                        var image = UIImage(data: data)
                        image = image?.resize(to: CGSize(width: self.areaImage.bounds.width, height: self.areaImage.bounds.height))
                        return image
                    }
                    .observe(on: MainScheduler.instance) // 確保更新UI的程式碼在主線程運行

                // 將下載的圖片綁定到imageView
                imageObservable
            .bind(to: areaImage.rx.image)
            .disposed(by: disposeBag)
    }
}
