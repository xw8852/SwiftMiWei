//
//  AlarmPreviewView.swift
//  MiWeiApp
//
//  Created by 肖伟 on 2018/2/2.
//  Copyright © 2018年 肖伟. All rights reserved.
//

import UIKit

 class AlarmPreviewView: UIView {

    var timer:Timer? = nil
        
   func createTimer() {
    print("createTimer")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clockRunning), userInfo: nil, repeats: true)
        timer?.fireDate = NSDate.distantPast
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
 @objc func clockRunning()  {
    
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        
        hour = comps.hour!
        minute = comps.minute!
        second = comps.second!
       self.setNeedsDisplay()
    
    }
    

    override func draw(_ rect: CGRect) {
        if(timer == nil){
            createTimer()
        }
        drawCircle(rect)
        drawDegreeScale(rect)
        drawHourLine(rect)
        drawMinuteLine(rect)
        drawSecondLine(rect)
    }
    
    
    func getCircleStrokeWidth() -> CGFloat {
        return 4
    }
    func  getCircleRadius() -> CGFloat {
        return min(frame.width/2, frame.height/2) - getCircleStrokeWidth()
    }
    
     func drawCircle(_ rect : CGRect){
        let ctx = UIGraphicsGetCurrentContext()
        
        let path = CGMutablePath.init()
        
        let centerPoint = CGPoint.init(
            x: frame.width/2,
            y: frame.height/2)
        
        path.addArc(
            center: centerPoint,
            radius: getCircleRadius(),
            startAngle: 0,
            endAngle: CGFloat.pi*2,
            clockwise: true
        )
        ctx?.addPath(path)
        ctx?.setLineWidth(getCircleStrokeWidth())
        ctx?.setStrokeColor(UIColor.darkGray.cgColor)
        ctx?.drawPath(using: .stroke)
        
    }
    
    
    // 获取刻度小圆点的半径
    func getDegreeScaleCircleRadius() -> CGFloat{
        let radius = getCircleRadius() - getCircleStrokeWidth()*2
        return 2*CGFloat.pi*radius / (192 - 2*CGFloat.pi)
    }
    
    // 获取刻度所在圆的半径
    func getDegreeCircleRadius() -> CGFloat{
        return getCircleRadius() - getCircleStrokeWidth()*2
    }
    
    /**
     * 画刻度，刻度计算，整点的刻度大小为非整点刻度的2倍 刻度之间的间隔为 整点刻度的大小
     * 旋转矩阵公式：     x'-x0=(x-x0)cosa-(y-y0)sina      y'-y0=(x-x0)sina+(y-y0)cosa
     *
     */
    private func drawDegreeScale(_ rect : CGRect){
        let radius = getCircleRadius() - getCircleStrokeWidth()*2
        let  r = 2*CGFloat.pi*radius / (192 - 2*CGFloat.pi)
        let ctx = UIGraphicsGetCurrentContext()
        
        for index in (0...59){
            let path = CGMutablePath.init()
            // 起始点 即 零点
            let originPoint = CGPoint.init(
                x: frame.width/2,
                y: frame.height/2-radius)
            let originCenterPoint = CGPoint.init(
                x:frame.width/2,
                y:frame.height/2)
            // 旋转角度
            
            let degree = 0-Double(index)*(Double.pi*2/60)
            let centerPoint = CGPoint.init(
                x: originCenterPoint.x + (originPoint.x-originCenterPoint.x)*CGFloat(cos(degree)) - (originPoint.y - originCenterPoint.y)*CGFloat(sin(degree)),
                y: originCenterPoint.y + (originPoint.x-originCenterPoint.x)*CGFloat(sin(degree)) + (originPoint.y - originCenterPoint.y)*CGFloat(cos(degree))
            )
            var _r = r
            if( index%5 != 0){
                _r = _r/2
            }
            path.addArc(
                center: centerPoint,
                radius: _r,
                startAngle: 0,
                endAngle: CGFloat.pi*2,
                clockwise: true
            )
            ctx?.addPath(path)
            ctx?.setStrokeColor(UIColor.darkGray.cgColor)
            ctx?.drawPath(using: .fill)
        }
        
    }
    
    func getSecondLength()->CGFloat{
        return getDegreeCircleRadius() - 2*getDegreeScaleCircleRadius()
    }
    
    var hour = 1
    var minute = 12
    var second = 45
    
    // 秒针最长 ，分针取秒针的0.7 时针取秒针的0.3
    private func  drawHourLine(_ rect : CGRect){
        drawLine(rect, hour, 12, 0.7,getDegreeScaleCircleRadius())
    }
    
    private func  drawMinuteLine(_ rect : CGRect){
       drawLine(rect, minute, 60, 0.9,getDegreeScaleCircleRadius()*2/3)
    }
    
    private func  drawSecondLine(_ rect : CGRect){
      drawLine(rect, second, 60, 1,getDegreeScaleCircleRadius()/2)
    }
    //  degree 当前刻度   countDegree 一圈总刻度 ，时针12 ，分针秒针为60  length 相对于 秒针的长度比 0 ~ 1.0 with  指针宽度
    public func drawLine(_ rect :CGRect,_ degree: Int,_ countDegree :Double ,_ length :CGFloat,_ with:CGFloat){
        let ctx = UIGraphicsGetCurrentContext()
        let degree =  Double(degree)*(Double.pi*2/countDegree)
        let path = CGMutablePath.init();
        
        let originCenterPoint = CGPoint.init(
            x:frame.width/2,
            y:frame.height/2)
        let originEndPoint = CGPoint.init(x: frame.width/2, y: frame.height/2 - getSecondLength()*length)
        
        let endPoint = CGPoint.init(
            x: originCenterPoint.x + (originEndPoint.x-originCenterPoint.x)*CGFloat(cos(degree)) - (originEndPoint.y - originCenterPoint.y)*CGFloat(sin(degree)),
            y: originCenterPoint.y + (originEndPoint.x-originCenterPoint.x)*CGFloat(sin(degree)) + (originEndPoint.y - originCenterPoint.y)*CGFloat(cos(degree))
        )
        path.move(to: originCenterPoint)
        path.addLine(to: endPoint)
        ctx?.addPath(path)
        ctx?.setLineWidth(with)
        ctx?.setLineCap(.round)
        ctx?.setStrokeColor(UIColor.darkGray.cgColor)
        ctx?.drawPath(using: .stroke)
    }
}
