//
//  Filter.swift
//  FunctionalSwift
//
//  Created by Haoyipeng on 16/10/13.
//  Copyright © 2016年 chunyu. All rights reserved.
//

import Foundation
import UIKit

typealias Filter = (CIImage) -> CIImage

func blur(radius: Double) -> Filter {
    return { image in
        let parameters = [kCIInputRadiusKey: radius,
                         kCIInputImageKey: image] as [String : Any]
        
        guard let filter = CIFilter(name:"CIGaussianBlur",
                                    withInputParameters: parameters) else {
                                        fatalError()
        }
        
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

func colorGenerator(color: UIColor) -> Filter {
    return { _ in
        
        let c = CIColor(color: color)
            
        let parameters = [kCIInputColorKey: c]
        
        guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters) else {
            fatalError()
        }
        
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        
        return outputImage
        
    }
}


func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [ kCIInputBackgroundImageKey: image,
                           kCIInputImageKey: overlay]
        guard let  lter = CIFilter (name: "CISourceOverCompositing",
                                withInputParameters: parameters) else {
                                    fatalError()
        }
        guard let outputImage =  lter.outputImage else {
            fatalError()
        }
        
        let cropRect = image.extent
        
        return outputImage.cropping(to: cropRect)
    }
}


func coverOverlay (color: UIColor) -> Filter {
    
    return { image in
        
        let overlay = colorGenerator(color: color)(image)
        
        return compositeSourceOver(overlay: overlay)(image)
        
    }
}

infix operator >>> { associativity left }

func >>> (filer1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in filter2(filer1(image))
        
    }
}


















