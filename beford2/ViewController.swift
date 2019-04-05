//
//  ViewController.swift
//  beford2
//
//  Created by 許光毅 on 2017/1/16.
//  Copyright © 2017年 GuangYihSheu. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var usertextfield: UITextField!
    @IBOutlet weak var userbutton1: UIButton!
    @IBOutlet weak var userbutton2: UIButton!
    @IBOutlet weak var userimageview: UIImageView!
    
    @IBOutlet weak var userbutton3: UIButton!
    @IBOutlet weak var usersegment: UISegmentedControl!
    
    var topx = 65.0
    var topy = 40.0
    var bottomx = 350.0
    var bottomy = 620.0
    var chicrt1=13.362
    var chicrt2=106.469
    var kscrt=1.22
    var kucrt=1.62
    
    var output = 0
    var outputmessage: String = ""
    
    @IBAction func indexchanged(_ sender: Any) {
        switch usersegment.selectedSegmentIndex
        {
        case 0:
            self.chicrt1=13.362
            self.chicrt2=106.469
            self.kscrt=1.22
            self.kucrt=1.62
        case 1:
            self.chicrt1=15.507
            self.chicrt2=112.022
            self.kscrt=1.36
            self.kucrt=1.747
        case 2:
            self.chicrt1=20.090
            self.chicrt2=122.942
            self.kscrt=1.63
            self.kucrt=2.001
        case 3:
            self.chicrt1=26.124
            self.chicrt2=135.978
            self.kscrt=1.95
            self.kucrt=2.303
        default:
            self.chicrt1=13.362
            self.chicrt2=106.469
            self.kscrt=1.22
            self.kucrt=1.62
        }
    }
    @IBAction func button3_press(_ sender: Any) {
        let alert = UIAlertController(title: "E-mail Address", message: "Input an e-mail address", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.text = "xsheu@hotmail.com"
            textField.isSecureTextEntry = false // for password input
        })
        let textemail=alert.textFields![0]
        if(MFMailComposeViewController.canSendMail()) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([textemail.text!])
            mailComposer.setSubject("Conformity Evaluation Result")
            mailComposer.setMessageBody(self.outputmessage, isHTML: false)
            let imageData: NSData = UIImagePNGRepresentation(userimageview.image!)! as NSData
            mailComposer.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "Conformity Evaluation Result")
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    @IBAction func button2_press(_ sender: Any) {
        output=1
        userimageview.image=nil
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        userimageview.image?.draw(in: view.bounds)
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x:topx,y:topy))
        context?.addLine(to: CGPoint(x:topx,y:bottomy))
        context?.addLine(to: CGPoint(x:bottomx,y:bottomy))
        context?.addLine(to: CGPoint(x:bottomx,y:topy))
        context?.addLine(to: CGPoint(x:topx,y:topy))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(3.0)
        context?.setStrokeColor(red: 0.0, green: 0.0, blue: 100.0, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        let textFontAttributes = [
        NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: UIColor.blue,
        ]
        let textFontAttributes1 = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: UIColor.purple,
            ]
        let textFontAttributes2 = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: UIColor.blue,
            ]
        let yaxis = String("P") as NSString
        let m1 = String("Purple ＝ Actual") as NSString
        let m2 = String("Blue ＝ Theoretical") as NSString
        let gtitle = String("Conformity Evaluation Result") as NSString
        yaxis.draw(at: CGPoint(x:topx-60.0,y: (topy+bottomy)*0.5+5.0), withAttributes: textFontAttributes)
        m1.draw(at: CGPoint(x:(topx+bottomx)*0.2,y:(topy+30)), withAttributes: textFontAttributes1)
        m2.draw(at: CGPoint(x:(topx+bottomx)*0.2,y:(topy+47)), withAttributes: textFontAttributes)
        gtitle.draw(at: CGPoint(x:(topx+40),y:(topy-25)), withAttributes: textFontAttributes2)
        let xaxis = String("Digit") as NSString
        xaxis.draw(at: CGPoint(x: (topx+bottomx)*0.5-20,y: bottomy+30), withAttributes: textFontAttributes)
        let columnperline = ((bottomx-topx)/90.0).rounded()
        var startx = topx+(columnperline*0.5).rounded()
        for i in 10...99 {
            let label = String(i) as NSString
            if((i==10) || (i==50) || (i==99)) {
                label.draw(at: CGPoint(x: startx, y:bottomy+10), withAttributes: textFontAttributes)
            }
            startx += columnperline*0.92
        }
        var j = 10.0
        let columnperline1 = ((bottomx-topx)/1040.0)
        var starty = topx+(columnperline*0.5).rounded()
        context?.move(to: CGPoint(x: starty+8.0, y:(bottomy-self.benford_theoretical(digit: Double(10.0))*(bottomy-topy)/0.3)))
        while (j<99.0) {
            let value = self.benford_theoretical(digit: Double(j))*(bottomy-topy)/0.3
            context?.addLine(to: CGPoint(x: starty+8.0, y: (bottomy-value)))
            context?.move(to: CGPoint(x: starty+8.0, y: (bottomy-value)))
            context?.addLine(to: CGPoint(x: starty+8.0,y:bottomy))
            context?.move(to: CGPoint(x: starty+8.0, y:(bottomy-value)))
            j += 0.1
            starty += columnperline1
        }
        var II = bottomy.rounded()
        var label=0.0
        while (II>=topy.rounded()) {
            let text = String(label) as NSString
            label += 0.3/4.0
            text.draw(at: CGPoint(x: topx-38.0, y: II-8.0), withAttributes: textFontAttributes)
            context?.move(to: CGPoint(x: topx,y: II))
            context?.addLine(to: CGPoint(x: topx+5.0,y: II))
            context?.move(to: CGPoint(x: bottomx,y: II))
            context?.addLine(to: CGPoint(x: bottomx-5.0,y: II))
            II -= (bottomy-topy)/4.0
        }
        if usertextfield.text=="http://" {
            let alert = UIAlertController(title: "Error", message: "The URL of an XBRL instance document is not input.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            var pdf = Array(repeating: 0.0, count: 99)
            var cumu = Array(repeating: 0.0, count: 99)
            var cumu_benford = Array(repeating: 0.0, count: 99)
            var total = 0.0
            var MAD2d = 0.0
            var chi2d = 0.0
            var KolmogorovSmirnov2d = 0.0
            var Kuiper_f2d = 0.0
            var Kuiper_s2d = 0.0
            let url=usertextfield.text
            let file = NSURL(string: url!)
            let request = NSMutableURLRequest(url:(file!) as URL);
            request.httpMethod="GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data,response,error in
                if error != nil
                {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: error as! String?, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let seperated = responseString?.components(separatedBy: "<")
                for lines in seperated! {
                    if(lines.contains(">") && !lines.contains("identifier")){
                        let piece=lines.components(separatedBy: ">")
                        for datatosearch in piece {
                            let digitdata = Float32(datatosearch)
                            if(digitdata != nil) {
                                if (abs(digitdata!)>10.0) {
                                    total += 1
                                    if(digitdata! > 0) {
                                        let first=String(datatosearch[datatosearch.startIndex])
                                        let firsttwo=String(datatosearch[..<datatosearch.index(datatosearch.startIndex, offsetBy: 2)])
                                        let firsti = Int(first)
                                        pdf[firsti!-1] += 1.0
                                        let firsttwoi = Int(firsttwo)
                                        pdf[firsttwoi!-1] += 1.0
                                        
                                    }
                                    else {
                                        let stringtodigit=String(datatosearch[datatosearch.index(datatosearch.startIndex, offsetBy: 1)...])
                                        if(stringtodigit.startIndex != stringtodigit.endIndex) {
                                            let first=String(stringtodigit[stringtodigit.startIndex])
                                            let firsttwo=String(stringtodigit[..<stringtodigit.index(stringtodigit.startIndex, offsetBy: 2)])
                                            let firsti = Int(first)
                                            pdf[firsti!-1] += 1.0
                                            let firsttwoi = Int(firsttwo)
                                            pdf[firsttwoi!-1] += 1.0
                                        }
                                    }
                                }
                            
                            }
                        }
                    }
                }
                for n in 1...99 {
                    pdf[n-1] /= total
                }
                self.outputmessage = self.outputmessage + "First-two digits" + "\n"
                for m in 10...99 {
                    self.outputmessage = self.outputmessage + "Digit " + String(m) + " = " + String(pdf[m-1]) + "\n"
                    for n in 10...m {
                        let cumub=self.benford_theoretical(digit: Double(n))
                        cumu[m-1] += pdf[n-1]
                        cumu_benford[m-1] += cumub
                    }
                    let diff=self.benford_theoretical(digit: Double(m))-pdf[m-1]
                    let diffb=cumu_benford[m-1]-cumu[m-1]
                    MAD2d += Swift.abs(diff)
                    chi2d += diff*diff*total/self.benford_theoretical(digit: Double(m))
                    KolmogorovSmirnov2d = max(abs(diffb),Double(KolmogorovSmirnov2d))
                    Kuiper_f2d = max(diffb,Double(Kuiper_f2d))
                    Kuiper_s2d = max(-diffb,Double(Kuiper_s2d))
                }
                MAD2d=MAD2d/90
                let evaluation3=self.MADoutput2d(mad2d: MAD2d)
                var pos1=String(MAD2d).endIndex
                if(String(MAD2d).count>5) {
                    pos1=String(MAD2d).index((String(MAD2d)).startIndex, offsetBy: 5)
                }
                self.outputmessage = self.outputmessage + "Mean Absolute Deviation Test Statistics ＝ " + String(String(MAD2d)[..<pos1]) + "(" + evaluation3 + ")"+"\n"
                var pos2 = String(chi2d).endIndex
                if(String(chi2d).count>5) {
                    pos2=String(chi2d).index((String(chi2d)).startIndex, offsetBy: 5)
                }
                if chi2d>self.chicrt2 {
                    self.outputmessage = self.outputmessage + "Chi-square Test Statistics ＝ " + String(String(chi2d)[..<pos2])+" (Unacceptable)" + "\n"
                }
                else {
                    self.outputmessage = self.outputmessage + "Chi-square Test Statistics ＝ " + String(String(chi2d)[..<pos2])+" (Acceptable)" + "\n"
                }
                var pos4 = String(Kuiper_f2d+Kuiper_s2d).endIndex
                if(String(Kuiper_f2d+Kuiper_s2d).count>5) {
                    pos4=String(Kuiper_f2d+Kuiper_s2d).index((String(Kuiper_f2d+Kuiper_s2d)).startIndex, offsetBy: 5)
                }
                if (Kuiper_f2d+Kuiper_s2d)>self.kucrt/sqrt(total) {
                    self.outputmessage = self.outputmessage + "Kuiper Test Statistics ＝ " + String(String(Kuiper_f2d+Kuiper_s2d)[..<pos4])+" (Unacceptable)" + "\n"
                }
                else {
                    self.outputmessage = self.outputmessage + "Kuiper Test Statistics ＝ " + String(String(Kuiper_f2d+Kuiper_s2d)[..<pos4])+" (Acceptable)" + "\n"
                }
                var pos3 = String(KolmogorovSmirnov2d).endIndex
                if(String(KolmogorovSmirnov2d).count>5) {
                    pos3 = String(KolmogorovSmirnov2d).index((String(KolmogorovSmirnov2d)).startIndex, offsetBy: 5)
                }
                if KolmogorovSmirnov2d>self.kscrt/sqrt(total) {
                    self.outputmessage = self.outputmessage + "Kolmogorov_Smirnov Test Statistics ＝ " + String(String(KolmogorovSmirnov2d)[..<pos3])+" (Unacceptable)" + "\n"
                }
                else {
                    self.outputmessage = self.outputmessage + "Kolmogorov_Smirnov Test Statistics ＝ " + String(String(KolmogorovSmirnov2d)[..<pos3])+" (Acceptable)" + "\n"
                }
                DispatchQueue.main.async {
                    context?.strokePath()
                    self.userimageview.image = UIGraphicsGetImageFromCurrentImageContext()
                    self.userimageview.alpha = 1.0
                    UIGraphicsEndImageContext()
                    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0)
                    self.userimageview.image?.draw(in: self.view.bounds)
                    let context2 = UIGraphicsGetCurrentContext()
                    context2?.setLineCap(CGLineCap.round)
                    context2?.setLineWidth(3.0)
                    context2?.setStrokeColor(red: 128.0, green: 0.0, blue: 128.0, alpha: 1.0)
                    context2?.setBlendMode(CGBlendMode.normal)
                    let columnperline2 = ((self.bottomx-self.topx)/104.0)
                    var startz = self.topx+(columnperline2*0.5).rounded()
                    context2?.move(to: CGPoint(x: startz+8.0, y:(self.bottomy-pdf[9]*(self.bottomy-self.topy)/0.3)))
                    for m in 10...99 {
                        context2?.addLine(to: CGPoint(x: startz+8.0, y:(self.bottomy-pdf[m-1]*(self.bottomy-self.topy)/0.3)))
                        
                        context2?.move(to: CGPoint(x: startz+8.0, y:(self.bottomy-pdf[m-1]*(self.bottomy-self.topy)/0.3)))
                        startz += columnperline2
                    }
                    context2?.strokePath()
                    let textFontAttributes31 = [
                        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
                        NSAttributedStringKey.foregroundColor: UIColor.green,
                        ]
                    let textFontAttributes32 = [
                        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
                        NSAttributedStringKey.foregroundColor: UIColor.blue,
                        ]
                    let textFontAttributes33 = [
                        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
                        NSAttributedStringKey.foregroundColor: UIColor.yellow,
                        ]
                    let textFontAttributes35 = [
                        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
                        NSAttributedStringKey.foregroundColor: UIColor.red,
                        ]
                    var pos11=String(MAD2d).endIndex
                    if(String(MAD2d).count>5) {
                        pos11=String(MAD2d).index((String(MAD2d)).startIndex, offsetBy: 5)
                    }
                    let evaluation4=self.MADoutput2d(mad2d: MAD2d)
                    let n3 = String("MAD ＝")+String(String(MAD2d)[..<pos11]) as NSString
                    if(evaluation4 == "Close") {
                        n3.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+64)), withAttributes: textFontAttributes31)
                    }
                    else {
                        if(evaluation4 == "Acceptable") {
                            n3.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+64)), withAttributes: textFontAttributes32)
                        }
                        else {
                            if(evaluation4 == "Marginally Acceptable") {
                                n3.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+64)), withAttributes: textFontAttributes33)
                            }
                            else {
                                n3.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+64)), withAttributes: textFontAttributes35)
                            }
                        }
                    }
                    var pos15 = String(chi2d).endIndex
                    if(String(chi2d).count>5) {
                        pos15=String(chi2d).index((String(chi2d)).startIndex, offsetBy: 5)
                    }
                    let n4 = String("Chi-square ＝ "+String(String(chi2d)[..<pos15])) as NSString
                    if chi2d>self.chicrt2 {
                        n4.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+76)), withAttributes: textFontAttributes35)
                    }
                    else {
                        n4.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+76)), withAttributes: textFontAttributes31)
                    }
                    var pos14 = String(Kuiper_f2d+Kuiper_s2d).endIndex
                    if(String(Kuiper_f2d+Kuiper_s2d).count>5) {
                        pos14=String(Kuiper_f2d+Kuiper_s2d).index((String(Kuiper_f2d+Kuiper_s2d)).startIndex, offsetBy: 5)
                    }
                    let n5 = String("Kuiper ＝ "+String(Kuiper_f2d+Kuiper_s2d)[..<pos14]) as NSString
                    if (Kuiper_f2d+Kuiper_s2d)>self.kucrt/sqrt(total) {
                        n5.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+88)), withAttributes: textFontAttributes35)
                    }
                    else {
                        n5.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+88)), withAttributes: textFontAttributes31)
                    }
                    var pos16 = String(KolmogorovSmirnov2d).endIndex
                    if(String(KolmogorovSmirnov2d).count>5) {
                        pos16 = String(KolmogorovSmirnov2d).index((String(KolmogorovSmirnov2d)).startIndex, offsetBy: 5)
                    }
                    let n6 = String("Kolmogorov_Smirnov ＝ "+String(KolmogorovSmirnov2d)[..<pos16]) as NSString
                    if (KolmogorovSmirnov2d)>self.kscrt/sqrt(total) {
                        n6.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+100)), withAttributes: textFontAttributes35)
                    }
                    else {
                        n6.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+100)), withAttributes: textFontAttributes31)
                    }
                    self.userimageview.image = UIGraphicsGetImageFromCurrentImageContext()
                    self.userimageview.alpha = 1.0
                    UIGraphicsEndImageContext()
                }
            }
            task.resume()
        }
    }
    @IBAction func button1_press(_ sender: Any) {
        userimageview.image=nil
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        
        userimageview.image?.draw(in: view.bounds)
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x:topx,y:topy))
        context?.addLine(to: CGPoint(x:topx,y:bottomy))
        context?.addLine(to: CGPoint(x:bottomx,y:bottomy))
        context?.addLine(to: CGPoint(x:bottomx,y:topy))
        context?.addLine(to: CGPoint(x:topx,y:topy))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(3.0)
        context?.setStrokeColor(red: 0.0, green: 0.0, blue: 100.0, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let textFontAttributes31 = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: UIColor.blue,
            ]
        let textFontAttributes32 = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: UIColor.purple,
            ]
        let textFontAttributes33 = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: UIColor.blue,
            ]
        let yaxis = String("P") as NSString
        let m1 = String("Purple ＝ Actual") as NSString
        let m2 = String("Blue ＝ Theoretical") as NSString
        let gtitle = String("Conformity Evaluation Result") as NSString
        yaxis.draw(at: CGPoint(x:topx-55.0,y: (topy+bottomy)*0.5), withAttributes : textFontAttributes31)
        m1.draw(at: CGPoint(x:(topx+bottomx)*0.2,y:(topy+30)), withAttributes : textFontAttributes32)
        m2.draw(at: CGPoint(x:(topx+bottomx)*0.2,y:(topy+47)), withAttributes : textFontAttributes31)
        gtitle.draw(at: CGPoint(x:(topx+40),y:(topy-25)), withAttributes : textFontAttributes33)


        let xaxis = String("Digit") as NSString
        xaxis.draw(at: CGPoint(x: (topx+bottomx)*0.5-20,y: bottomy+30), withAttributes : textFontAttributes31)
        let columnperline = ((bottomx-topx)/9.0).rounded()
        var startx = topx+(columnperline*0.5).rounded()
        for i in 1...9 {
            let label = String(i) as NSString
            if((i==1) || (i==5) || (i==9)) {
                label.draw(at: CGPoint(x: startx, y:bottomy+5), withAttributes: textFontAttributes31)
            }
            startx += columnperline*0.92
        }
        var j = 1.0
        let columnperline1 = ((bottomx-topx)/85.0).rounded()
        var starty = topx+(columnperline*0.5).rounded()
        context?.move(to: CGPoint(x: starty+5.0, y:(bottomy-self.benford_theoretical(digit: Double(1.0))*(bottomy-topy)/0.6)))
        while (j<8.9) {
            let value = self.benford_theoretical(digit: Double(j))*(bottomy-topy)/0.6
            context?.addLine(to: CGPoint(x: starty+5.0, y: (bottomy-value)))
            context?.move(to: CGPoint(x: starty+5.0, y: (bottomy-value)))
            context?.addLine(to: CGPoint(x: starty+5.0,y:bottomy))
            context?.move(to: CGPoint(x: starty+5.0, y:(bottomy-value)))
            j += 0.1
            starty += columnperline1
        }
        var II = bottomy.rounded()
        var label=0.0
        while (II>=topy.rounded()) {
            let text = String(label) as NSString
            label += 0.6/4.0
            text.draw(at: CGPoint(x: topx-30.0, y: II-8.0), withAttributes : textFontAttributes31)
            context?.move(to: CGPoint(x: topx,y: II))
            context?.addLine(to: CGPoint(x: topx+5.0,y: II))
            context?.move(to: CGPoint(x: bottomx,y: II))
            context?.addLine(to: CGPoint(x: bottomx-5.0,y: II))
            II -= (bottomy-topy)/4.0
        }
        if usertextfield.text=="http://" {
            let alert = UIAlertController(title: "Error", message: "The URL of an XBRL instance document is not input.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            var pdf = Array(repeating: 0.0, count: 99)
            var cumu = Array(repeating: 0.0, count: 99)
            var cumu_benford = Array(repeating: 0.0, count: 99)
            var total = 0.0
            var MAD = 0.0
            var chi = 0.0
            var KolmogorovSmirnov = 0.0
            var Kuiper_f = 0.0
            var Kuiper_s = 0.0
            let url=usertextfield.text
            let file = NSURL(string: url!)
            let request = NSMutableURLRequest(url:file! as URL);
            request.httpMethod="GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data,response,error in
                if error != nil
                {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: error as! String?, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let seperated = responseString?.components(separatedBy: "<")
                for lines in seperated! {
                    if(lines.contains(">") && !lines.contains("identifier")){
                        let piece=lines.components(separatedBy: ">")
                        for datatosearch in piece {
                            let digitdata = Float32(datatosearch)
                            if(digitdata != nil) {
                                if (abs(digitdata!)>10.0) {
                                    total += 1
                                    if(digitdata! > 0) {
                                        let first=String(datatosearch[datatosearch.startIndex])
                                        let firsttwo=String(datatosearch[..<datatosearch.index(datatosearch.startIndex, offsetBy: 2)])
                                        let firsti = Int(first)
                                        pdf[firsti!-1] += 1.0
                                        let firsttwoi = Int(firsttwo)
                                        pdf[firsttwoi!-1] += 1.0
                                        
                                    }
                                    else {
                                        let stringtodigit=String(datatosearch[datatosearch.index(datatosearch.startIndex, offsetBy: 1)...])
                                        if(stringtodigit.startIndex != stringtodigit.endIndex) {
                                            let first=String(stringtodigit[stringtodigit.startIndex])
                                            let firsttwo=String(stringtodigit[..<stringtodigit.index(stringtodigit.startIndex, offsetBy: 2)])
                                            let firsti = Int(first)
                                            pdf[firsti!-1] += 1.0
                                            let firsttwoi = Int(firsttwo)
                                            pdf[firsttwoi!-1] += 1.0
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                for n in 1...99 {
                    pdf[n-1] /= total
                }
                self.outputmessage = self.outputmessage + "Leading digits" + "\n"
                for m in 1...9 {
                    self.outputmessage = self.outputmessage + "Digit " + String(m) + " = " + String(pdf[m-1]) + "\n"
                    for n in 1...m {
                        let cumub=self.benford_theoretical(digit: Double(n))
                        cumu[m-1] += pdf[n-1]
                        cumu_benford[m-1] += cumub
                    }
                    let diff=self.benford_theoretical(digit: Double(m))-pdf[m-1]
                    let diffb=cumu_benford[m-1]-cumu[m-1]
                    MAD += Swift.abs(diff)
                    chi += diff*diff*total/self.benford_theoretical(digit: Double(m))
                    KolmogorovSmirnov=max(abs(diffb),Double(KolmogorovSmirnov))
                    Kuiper_f=max(diffb,Double(Kuiper_f))
                    Kuiper_s=max(-diffb,Double(Kuiper_s))
                }
                MAD=MAD/9.0
                let evaluation=self.MADoutput(mad1d: MAD)
                var pos1=String(MAD).endIndex
                if(String(MAD).count>5) {
                    pos1=String(MAD).index((String(MAD)).startIndex, offsetBy: 5)
                }
                self.outputmessage = self.outputmessage + "Mean Absolute Deviation Test Statistics ＝ " + String(String(MAD)[..<pos1]) + "(" + evaluation + ")"+"\n"
                var pos2 = String(chi).endIndex
                if(String(chi).count>5) {
                    pos2=String(chi).index((String(chi)).startIndex, offsetBy: 5)
                }
                if chi>self.chicrt1 {
                    self.outputmessage = self.outputmessage + "Chi-square Test Statistics ＝ " + String(String(chi)[..<pos2])+"(Unacceptable)" + "\n"
                }
                else {
                    self.outputmessage = self.outputmessage + "Chi-square Test Statistics ＝ " + String(String(chi)[..<pos2])+"(Acceptable)" + "\n"
                }
                var pos4 = String(Kuiper_f+Kuiper_s).endIndex
                if(String(Kuiper_f+Kuiper_s).count>5) {
                    pos4=String(Kuiper_f+Kuiper_s).index((String(Kuiper_f+Kuiper_s)).startIndex, offsetBy: 5)
                }
                if (Kuiper_f+Kuiper_s)>self.kucrt/sqrt(total) {
                    self.outputmessage = self.outputmessage + "Kuiper Test Statistics ＝ " + String(String(Kuiper_f+Kuiper_s)[..<pos4])+"(Unacceptable)" + "\n"
                }
                else {
                    self.outputmessage = self.outputmessage + "Kuiper Test Statistics ＝ " + String(String(Kuiper_f+Kuiper_s)[..<pos4])+"(Acceptable)" + "\n"
                }
                var pos3 = String(KolmogorovSmirnov).endIndex
                if(String(KolmogorovSmirnov).count>5) {
                    pos3 = String(KolmogorovSmirnov).index((String(KolmogorovSmirnov)).startIndex, offsetBy: 5)
                }
                if KolmogorovSmirnov>self.kscrt/sqrt(total) {
                    self.outputmessage = self.outputmessage + "Kolmogorov_Smirnov Test Statistics ＝ " + String(String(KolmogorovSmirnov)[..<pos3])+"(Unacceptable)" + "\n"
                }
                else {
                    self.outputmessage = self.outputmessage + "Kolmogorov_Smirnov Test Statistics ＝ " + String(String(KolmogorovSmirnov)[..<pos3])+"(Acceptable)" + "\n"
                }
                DispatchQueue.main.async {
                    context?.strokePath()
                    self.userimageview.image = UIGraphicsGetImageFromCurrentImageContext()
                    self.userimageview.alpha = 1.0
                    UIGraphicsEndImageContext()
                    
                    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0)
                    self.userimageview.image?.draw(in: self.view.bounds)
                    let context1 = UIGraphicsGetCurrentContext()
                    context1?.setLineCap(CGLineCap.round)
                    context1?.setLineWidth(3.0)
                    context1?.setStrokeColor(red: 128.0, green: 0.0, blue: 128.0, alpha: 1.0)
                    context1?.setBlendMode(CGBlendMode.normal)
                    let columnperline2 = ((self.bottomx-self.topx)/9.0).rounded()
                    var startz = self.topx+(columnperline2*0.5).rounded()
                    context1?.move(to: CGPoint(x: startz+5.0, y:(self.bottomy-pdf[0]*(self.bottomy-self.topy)/0.6)))
                    for m in 1...9 {
                        context1?.addLine(to: CGPoint(x: startz+5.0, y:(self.bottomy-pdf[m-1]*(self.bottomy-self.topy)/0.6)))
                        
                        context1?.move(to: CGPoint(x: startz+5.0, y:(self.bottomy-pdf[m-1]*(self.bottomy-self.topy)/0.6)))
                        startz += columnperline2*0.92
                    }
                    context1?.strokePath()
                    let evaluation1=self.MADoutput(mad1d: MAD)
                    var pos5 = String(MAD).endIndex
                    if(String(MAD).count>5) {
                        pos5=String(MAD).index((String(MAD)).startIndex, offsetBy: 5)
                    }
                    let textFontAttributes202 = [
                        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
                        NSAttributedStringKey.foregroundColor: UIColor.cyan,
                        ]
                    let textFontAttributes203 = [
                        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
                        NSAttributedStringKey.foregroundColor: UIColor.yellow,
                        ]
                    let textFontAttributes204 = [
                        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
                        NSAttributedStringKey.foregroundColor: UIColor.red,
                        ]
                    let textFontAttributes205 = [
                        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
                        NSAttributedStringKey.foregroundColor: UIColor.green,
                        ]
                    let m3 = String("MAD ＝")+String(String(MAD)[..<pos5]) as NSString
                    if(evaluation1 == "Close") {
                        m3.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+64)), withAttributes :  textFontAttributes205)
                    }
                    else {
                        if(evaluation1 == "Acceptable") {
                            UIFont.boldSystemFont(ofSize: 12.0)
                            UIColor.cyan.setStroke()
                            m3.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+64)), withAttributes :  textFontAttributes202)
                        }
                        else {
                            if(evaluation1 == "Marginally Acceptable") {
                                m3.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+64)), withAttributes : textFontAttributes203)
                            }
                            else {
                                m3.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+64)), withAttributes: textFontAttributes204)
                            }
                        }
                    }
                    var pos6=String(chi).endIndex
                    if(String(chi).count>5) {
                        pos6=String(chi).index((String(chi)).startIndex, offsetBy: 5)
                    }
                    let result1=String(String(chi)[..<pos6])
                    let m4 = String("Chi-square ＝ "+result1) as NSString
                    if chi>self.chicrt1 {
                        m4.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+76)), withAttributes: textFontAttributes204)
                    }
                    else {
                        m4.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+76)), withAttributes : textFontAttributes205)
                    }
                    var pos7 = String(Kuiper_f+Kuiper_s).endIndex
                    if(String(Kuiper_f+Kuiper_s).count>5) {
                        pos7=String(Kuiper_f+Kuiper_s).index((String(Kuiper_f+Kuiper_s)).startIndex, offsetBy: 5)
                    }
                    let result2=String(String(Kuiper_f+Kuiper_s)[..<pos7])
                    let m5 = String("Kuiper ＝ "+result2) as NSString
                    if (Kuiper_f+Kuiper_s)>self.kucrt/sqrt(total) {
                        m5.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+88)), withAttributes: textFontAttributes204)
                    }
                    else {
                        m5.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+88)), withAttributes: textFontAttributes205)
                    }
                    var pos8 = String(KolmogorovSmirnov).endIndex
                    if(String(KolmogorovSmirnov).count>5) {
                        pos8 = String(KolmogorovSmirnov).index((String(KolmogorovSmirnov)).startIndex, offsetBy: 5)
                    }
                    let result3=String(String(KolmogorovSmirnov)[..<pos8])
                    let m6 = String("Kolmogorov_Smirnov ＝ "+result3) as NSString
                    if (KolmogorovSmirnov)>self.kscrt/sqrt(total) {
                        m6.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+100)), withAttributes: textFontAttributes204)
                    }
                    else {
                        m6.draw(at: CGPoint(x:(self.topx+self.bottomx)*0.2,y:(self.topy+100)), withAttributes: textFontAttributes205)
                    }
                    self.userimageview.image = UIGraphicsGetImageFromCurrentImageContext()
                    self.userimageview.alpha = 1.0
                    UIGraphicsEndImageContext()
                }

            }
            task.resume()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        usertextfield.text="http://xbrl.squarespace.com/storage/examples/HelloWorld.xml"
//        usertextfield.text="https://www.xbrl.org/taxonomy/int/fr/ias/ci/pfs/2002-11-15/Novartis-2002-11-15.xml"
 //       usertextfield.text="http://wwwimages.adobe.com/content/dam/acom/en/investor-relations/xbrl/adbe-20100305.xml"
//        usertextfield.text="http://wwwimages.adobe.com/content/dam/acom/en/investor-relations/xbrl/adbe-20100604.xml"
//        usertextfield.text="http://wwwimages.adobe.com/content/dam/acom/en/investor-relations/xbrl/adbe-20100903.xml"
//        usertextfield.text="http://wwwimages.adobe.com/content/dam/acom/en/investor-relations/xbrl/adbe-20101203.xml"
        
        usertextfield.text="http://freexsheu.droppages.com/2015Q11.xml"
  //      usertextfield.text="http://xsheu.kissr.com/2015Q12.xml"
  //      usertextfield.text="http://xsheu.kissr.com/2015Q13.xml"
 //       usertextfield.text="http://freexsheu.droppages.com/2015Q14.xml"
        
   //      usertextfield.text="http://freexsheu.droppages.com/2013Q1.xml"
        //  usertextfield.text="http://freexsheu.droppages.com/2013Q2.xml"
        //        usertextfield.text="http://freexsheu.droppages.com/2013Q3.xml"
      //   usertextfield.text="http://freexsheu.droppages.com/2013Q4.xml"



        outputmessage="Conformity Evaluation Result" + "\n" + "Digital Probability" + "\n"
        userbutton1.layer.cornerRadius = 4
        userbutton3.layer.cornerRadius = 4
        userbutton2.layer.cornerRadius = 4


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func benford_theoretical(digit: Double)->Double {
        return log10(1.0 + 1.0/digit)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    func MADoutput(mad1d: Double)->String {
        var outputstring: String = ""
        if mad1d<=0.006 {
            outputstring="Close"
        }
        else {
            if mad1d<=0.012 {
                outputstring="Acceptable"
            }
            else {
                if mad1d<=0.015 {
                    outputstring="Marginally acceptable"
                }
                else {
                    outputstring="Unacceptable"
                }
            }
        }
        return outputstring
    }
    @objc func MADoutput2d(mad2d: Double)->String {
        var outputstring: String = ""
        if mad2d<=0.012 {
            outputstring="Close"
        }
        else {
            if mad2d<=0.018 {
                outputstring="Acceptable"
            }
            else {
                if mad2d<=0.022 {
                    outputstring="Marginally acceptable"
                }
                else {
                    outputstring="Unacceptable"
                }
            }
        }
        return outputstring
    }
}

