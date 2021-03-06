//
//  BarcodeViewController.swift
//  CoreDataScratch
//
//  Created by syed farrukh Qamar on 30/12/15.
//  Copyright © 2015 Be My Competence AB. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeDelegate {
    func barcodeReaded(barcode: String)
}

class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var test: UIButton!
    
    @IBOutlet weak var exit: UIButton!
    
    var delegate: BarcodeDelegate?
    var captureSession: AVCaptureSession!
    var code: String?
    
    override func viewDidLoad() {
         print("bar code view loaded")
        super.viewDidLoad()
               
        self.captureSession = AVCaptureSession();
        print("toold bar items\( self.view.subviews.count)")
        
        print("toold bar items\(self.view.subviews[0].sendSubviewToBack(self.view))")
        self.view.subviews[2].bringSubviewToFront(exit)
        
     //   print("toold bar items\( self.view.subviews[1].)")
        
        
        let videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            if self.captureSession.canAddInput(videoInput) {
                self.captureSession.addInput(videoInput)
            } else {
                print("Could not add video input")
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            if self.captureSession.canAddOutput(metadataOutput) {
                self.captureSession.addOutput(metadataOutput)
                // MARK Code type of barcodes it can read
                metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]
                
            } else {
                print("Could not add metadata output")
            }
            
            
            // MARK setting preview layer size
            let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
      
            
           
           
            
           
           // self.view.layer.bounds.size.width = 400
       
           // self.view.layer.bounds.s
            
            //self.view.layer.bounds.size.height = 450
           
            
            previewLayer.frame = self.view.layer.bounds
          //  previewLayer.anchorPoint.x = 0
          //  previewLayer.anchorPoint.y = 0

          //  previewLayer.position.x = 230
            previewLayer.position.y = previewLayer.position.y - 30
//            
//            
            previewLayer.bounds.size.width = previewLayer.bounds.size.width - 40
            previewLayer.bounds.size.height =  previewLayer.bounds.size.height - 120
            
            
            print("current Width is  \(previewLayer.bounds.size.width )")
             print("current height is  \(previewLayer.bounds.size.height)")
            
            print("current x axis \(previewLayer.position.x)")
            print("current y axis \(previewLayer.position.y )")
            
            self.view.layer .addSublayer(previewLayer)
            self.captureSession.startRunning()
        } catch let error as NSError {
            print("Error while creating vide input device: \(error.localizedDescription)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for metadata in metadataObjects {
            let readableObject = metadata as! AVMetadataMachineReadableCodeObject
            let code = readableObject.stringValue
            if !code.isEmpty {
                self.captureSession.stopRunning()
                self.dismissViewControllerAnimated(true, completion: nil)
                self.delegate?.barcodeReaded(code)
            }
        }
    }

// MARK: Segues
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print("Segue!")
//        
//        
//        print("segue.identifier:::inside barCodeController:::\(segue.identifier)")
//        
//        
//        
//        
//    }

}
