//
//  PrPopView.swift
//  SSui
//
//  Created by ifly_Perry on 2021/4/14.
//

import UIKit

///contentView 展示方式
enum PopContentShowStyle {
    case center  ///展示在中部
    case bottomPresent ///从底部弹出
    case togetherKeyboard ///和键盘一起弹出 在键盘顶部
}

class PrPopView: UIView {
    
    /// 次属性用于 popview 多次使用时候不重复添加
    var isShow : Bool = false
    ///是否点击空白处消失
    var iscanTopBgv : Bool = true
    ///展示方式
    private var showStyle : PopContentShowStyle = .center
    
    private var tap : UITapGestureRecognizer?

    var bgv : UIView = UIView()
    var contenView:UIView?
    {
        didSet{
           setUpContent()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpContent(){
        self.addSubview(bgv)
        bgv.backgroundColor = .clear
        bgv.frame = self.bounds

        if self.contenView != nil {
            self.contenView?.y = self.height
            self.contenView?.centerX = self.centerX
            self.addSubview(self.contenView!)
        }
        self.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        bgv.isUserInteractionEnabled = true
        //为view添加手势。
        bgv.addGestureRecognizer(tap!)
    }


    @objc func tapAction(top : UITapGestureRecognizer){
        guard let v = contenView else { return }
        let point = top.location(in: self)
        let bl = v.frame.contains(point)
        if !bl && iscanTopBgv {
            dismissView()
        }
    }

    /// dismiss
    /// - Parameter isAnimations: 是否从底部收起动画
    @objc func dismissView(isAnimations : Bool = false){
        
        switch showStyle {
        case .center:
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }) { (true) in
                self.contenView?.removeFromSuperview()

                self.removeFromSuperview()
            }
        case .bottomPresent:
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundColor = .clear
                self.contenView?.y = self.height
                
            }) { (true) in
                self.contenView?.removeFromSuperview()

                self.removeFromSuperview()
            }
        case .togetherKeyboard:
            dismissViewWithkeyboard()
            
            NotificationCenter.default.removeObserver(self)
        }
    }
    private func dismissViewWithkeyboard(){
        endEditing(true)

        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (true) in
            NotificationCenter.default.removeObserver(self)
            self.contenView?.removeFromSuperview()

            self.removeFromSuperview()
        }
    }
    
    /// 从底部收起动画的消失 不移除视图
    func packUpView(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.contenView?.y = self.height
        }) { (true) in
            self.alpha = 0
        }
    }
    
    /// 从view的底部展示
    /// - Parameter view: view
    func showInView(view:UIView?,canTopBgv:Bool = false){
        if (contenView == nil) {
            return
        }
        iscanTopBgv = canTopBgv
        if !canTopBgv {
            if let tp = tap {
                self.removeGestureRecognizer(tp)
            }
        }
        if let v = view{
           showStyle = .bottomPresent
          
            if !isShow {
                v.addSubview(self)
                isShow = true
            }
           UIView.animate(withDuration: 0.25, animations: {
                 self.alpha = 1.0
                self.contenView?.y = self.height-(self.contenView?.height)!
            }, completion: nil)
        }
    }
    /// 从Windows的底部展示
    /// - Parameter view: window
    func showInWindow(canTopBgv:Bool = false){
        showStyle = .bottomPresent

        iscanTopBgv = canTopBgv
        
        if !canTopBgv {
            if let tp = tap {
                self.removeGestureRecognizer(tp)
            }
        }
        
        if !isShow {
            UIApplication.shared.keyWindow?.addSubview(self)
            isShow = true
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.contenView?.y = self.height-(self.contenView?.height)!
        }, completion: nil)
    }
    
    /// 展示在view的中部
    /// - Parameters:
    ///   - canTopBgv: 是否允许点击空白部分dismiss
    ///   - view: view
    func showCenterViewInView(canTopBgv:Bool = false,view : UIView){
        
        iscanTopBgv = canTopBgv
        
        if !canTopBgv {
            if let tp = tap {
                self.removeGestureRecognizer(tp)
            }
        }
        
        view.addSubview(self)
        self.contenView?.centerY = self.centerY
        self.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    /// 展示在vindows的中部
    /// - Parameters:
    ///   - canTopBgv: 是否允许点击空白部分dismiss
    ///   - view: view
    func showCenterViewInWindow(canTopBgv:Bool = false){

        iscanTopBgv = canTopBgv
        
        if !canTopBgv {
            if let tp = tap {
                self.removeGestureRecognizer(tp)
            }
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.contenView?.centerY = self.centerY
        self.alpha = 0

        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    ///键盘的监听
    func showInWindowAndOpenKeyKVO(){
        iscanTopBgv = true

        UIApplication.shared.keyWindow?.addSubview(self)
        showStyle = .togetherKeyboard
        addkeyKVO()
        
    }
    func addkeyKVO(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(node:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChangeFrame(node : Notification){
            // 1.获取动画执行的时间
            let duration = node.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            
            // 2.获取键盘最终 Y值
            let endFrame = (node.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let y = endFrame.origin.y
            
            //3计算工具栏距离底部的间距
//            let margin = UIScreen.main.bounds.height - y
            
            //4.执行动画
            UIView.animate(withDuration: duration) {
                self.contenView?.y = y - (self.contenView?.height)!
            }
        }
}

extension UIView {
 
    
    var x: CGFloat {
        get { return frame.origin.x }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    var bottom : CGFloat {
        get { return frame.origin.y +  frame.size.height }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y = newValue - frame.size.height;
            self.frame = tempFrame;
        }
    }
    

    var y: CGFloat {
        get { return frame.origin.y }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    var height: CGFloat {
        get { return frame.size.height }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    var width: CGFloat {
        get { return frame.size.width }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width  = newValue
            frame = tempFrame
        }
    }
    
    var size: CGSize {
        get { return frame.size }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size        = newValue
            frame                 = tempFrame
        }
    }
    
    var centerX: CGFloat {
        get { return center.x }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x            = newValue
            center                  = tempCenter
        }
    }
    
    var centerY: CGFloat {
        get { return center.y }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y            = newValue
            center                  = tempCenter;
        }
    }
    
    var centerRect: CGRect {
        return CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
    }
    
}
