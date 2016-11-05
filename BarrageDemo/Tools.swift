//
//  Tools.swift
//  BarrageDemo
//
//  Created by Fan on 16/11/2.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class Tools: NSObject {

}


extension String {
    func getTestWidth(_ size: CGFloat) -> CGFloat {
        let comment = self as NSString
        let width = comment.size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: size)]).width
        return width

    }
}
