//
//  FFBarrageManager.swift
//  BarrageDemo
//
//  Created by Jacqui on 16/11/2.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class FFBarrageManager: NSObject {
    var trajectoryCount: Int = 3        ///< 弹幕的轨道数
    var generateView: ((_ barrage:FFBarrageView) -> Void)?   ///< 回调
    
    fileprivate var datasource:[String] = []        ///< 弹幕的数据来源
    fileprivate var barrageComments:[String] = []   ///< 使用过程中的弹幕数组
    fileprivate var barrageViews:[FFBarrageView] = []   ///< 存储弹幕view数组
    fileprivate var isBarrageStrat:Bool = false         ///< 判断当前弹幕的状态
    
    
    /// 初始化BarrageView，并且设置相应轨道和评论内容
    func initBarrageComment() {
        var trajectorys:[Int] = []
        for item in 0...(trajectoryCount-1) {
            trajectorys.append(item)
        }
        
        for _ in 0...(trajectorys.count-1) {
            //随机获取轨道
            let index = Int(arc4random())%trajectorys.count
            let trajectory = trajectorys[index]
            trajectorys.remove(at: index)
            
            //获取评论内容
            let comment = barrageComments.first!
            barrageComments.removeFirst()
            createBarrageView(comment: comment, trajectory: trajectory)
            
        }
    }
    
    func initWithComments(comments: [String]) -> FFBarrageManager{
        datasource = comments
    
        return self
    }
    
    
    /// 根据轨道和评论内容创建view
    ///
    /// - parameter comment:    评论内容
    /// - parameter trajectory: 当前轨道位置
    func createBarrageView( comment:String, trajectory:Int) {
        guard !isBarrageStrat else {
            let barrageView: FFBarrageView = FFBarrageView().initWithComment(comment: comment)
            barrageView.trajectory = trajectory
            barrageView.moveStatusBlock = { [weak self](status) in
                guard !(self?.isBarrageStrat)! else {
                    switch status {
                        ////弹幕开始进入屏幕，将弹幕view加入到弹幕管理变量中的barrageViews中
                    case .moveStart:
                        self?.barrageViews.append(barrageView)
                        
                    case .moveEnter:
                        //弹幕完全进入屏幕，判断是否还有其他内容，如果有，则在弹幕轨迹中创建弹幕
                        if let comment = self?.nextComment() {
                            self?.createBarrageView(comment: comment, trajectory: trajectory)
                        }
                    case .moveEnd:
                        //弹幕完全飞出屏幕后，从barrageViews释放资源
                        if (self?.barrageViews.contains(barrageView))! {
                            barrageView.stopAnimation()
                            let index = self?.barrageViews.index(of: barrageView)
                            self?.barrageViews.remove(at: index!)
                        }
                        
                        //说明屏幕上已经没有弹幕，开始循环滚动
                        if self?.barrageViews.count == 0 {
                            self?.isBarrageStrat = false
                            self?.start()
                        }
                    }
                    
                    return
                }
            }
            
            generateView?(barrageView)
            return
        }
    }
    
    func nextComment() -> String? {
        if barrageComments.count == 0 {
            return nil
        }
        
        let comment = barrageComments.first
        if (comment != nil) {
            barrageComments.removeFirst()
        }
        return comment
    }
    
    func start() {
        if isBarrageStrat {
            return;
        }
        
        isBarrageStrat = true
        barrageComments.removeAll()
        barrageComments = datasource
        self.initBarrageComment()
    }
    
    func stop() {
        guard !isBarrageStrat else {
            isBarrageStrat = false
            for barrageView in barrageViews {
                barrageView.stopAnimation()
                
            }
            barrageViews.removeAll()
            
            return
        }
    }
    
    func appendComments(appendComments: [String]) {
        datasource += appendComments
        barrageComments += appendComments
    }
}
