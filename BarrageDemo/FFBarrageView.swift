//
//  FFBarrageView.swift
//  BarrageDemo
//
//  Created by Fan on 16/10/31.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

enum MoveStatus {
    case moveStart
    case moveEnter
    case moveEnd
}

class FFBarrageView: UIView {

    var duration:TimeInterval = 5.0  ///<   动画时间
    var moveStatusBlock:((_ status:MoveStatus) -> ())?  ///< 弹幕移动过程回调，开始，进入屏幕，结束
    var trajectory: Int = 0     ///< 所属弹道
    
    fileprivate let defaultViewHeight = 30.0    ///< 弹道高度
    fileprivate let padding = 10.0              ///< 间距
    fileprivate let headHeight = 30.0           ///< 头像高度

    fileprivate var lblComment:UILabel?
    fileprivate var headImage:UIImageView?
    
    
    /// 初始化BarrageView：包括显示评论的label以及头像UIImageView
    ///
    /// - parameter comment: 传入评论内容
    ///
    /// - returns: 返回FFBarrageView对象
    func initWithComment(comment: String) -> FFBarrageView {
        backgroundColor = UIColor.red
        layer.cornerRadius = CGFloat(defaultViewHeight / 2)
        
        lblComment = UILabel()
        lblComment?.textAlignment = .center
        lblComment?.textColor = UIColor.white
        addSubview(lblComment!)
        
        let width = comment.size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0)]).width
        lblComment?.text = comment
        lblComment?.font = UIFont.systemFont(ofSize: 14.0)
        lblComment?.frame = CGRect(x: CGFloat(headHeight+padding), y: 0, width: width, height: CGFloat(defaultViewHeight))
        
        headImage = UIImageView()
        headImage?.frame = CGRect(x: -padding, y: -padding, width: headHeight+padding, height: headHeight+padding)
        headImage?.layer.cornerRadius = CGFloat((headHeight+padding)/2.0)
        headImage?.layer.masksToBounds = true
        headImage?.layer.borderColor = UIColor.gray.cgColor
        headImage?.image = UIImage(named: "head.jpg")
        addSubview(headImage!)
        
        //根据头像的宽度和label的宽度设置弹幕的总宽度
        bounds = CGRect(x: 0, y: 0, width: Double(Double(width) + 2 * Double(padding) + Double(headHeight)), height: defaultViewHeight)
        
        return self
    }
    
    
    /// 开始动画
    func startAnimation() {
        //获取屏幕宽度
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        //获取弹幕一定距离：屏幕宽度 + 弹幕的总宽度
        let totaolWidth = screenWidth + bounds.size.width
        
        //动画开始回调当前状态为开始
        moveStatusBlock?(MoveStatus.moveStart)
        
        //速度：弹幕匀速滚动，因此时间T固定，通过移动的总距离S计算出速度V
        let speed: CGFloat = totaolWidth / CGFloat(duration)
        //计算当前弹幕完全进入到屏幕中的时间
        let enterDuration = (bounds.size.width + CGFloat(padding * 2)) / speed
        
        //延迟执行：当弹幕完全进入屏幕时才执行该方法，通过回调告知当前弹幕状态为正在进入屏幕中
        perform(#selector(FFBarrageView.enterScreen), with: nil, afterDelay: TimeInterval(enterDuration))
        
        var frame = self.frame
        
        //执行动画，动画为从右向左匀速运动
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            frame.origin.x -= totaolWidth
            self.frame = frame
            }) { (finished) in
                
                ///执行完成，返回动画回调状态为：结束
                self.moveStatusBlock?(MoveStatus.moveEnd)
        }
        
    }
    
    ///停止动画
    func stopAnimation() {
        //移除所有动画
        layer.removeAllAnimations()
        //取消perform方法
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        removeFromSuperview()
    }
    
    func enterScreen() {
        moveStatusBlock?(MoveStatus.moveEnter)
    }
}
