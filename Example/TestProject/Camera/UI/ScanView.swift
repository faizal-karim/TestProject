//
//  ScanView.swift
//  TestProject_Example
//
//  Created by Faizal on 2/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import AVKit
protocol ScanViewDelegate: AnyObject {
    func proceedNextScreen()
}

class ScanView: BaseView {
    // MARK: Helper Types
    
    private struct Constants {
        static let buttonTitle = "Next"
        static let backgroundImage = "introductionBackground"
    }
    
    weak var delegate: ScanViewDelegate?
    
    // MARK: Properties
    let viewModel: ScanViewModel
    //Camera Capture requiered properties
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    var currentFrame: CIImage!
    var done = false
    
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        title.textColor = .white
        title.textAlignment = .center
        return title
    }()
    
    let subTitleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        title.textColor = .white
        title.textAlignment = .center
        title.numberOfLines = 3
        return title
    }()
    
    let cameraView: UIView = {
        let cameraView = UIView()
        cameraView.frame = UIScreen.main.bounds
        return cameraView
    }()
    
    let mainView: UIView = {
        let cameraView = UIView()
        cameraView.frame = UIScreen.main.bounds
        return cameraView
    }()
    
    let gradientView: UIView = {
        let cameraView = UIView()
        cameraView.frame = UIScreen.main.bounds
        return cameraView
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "61AF2B")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: Init Methods
    init(viewModel: ScanViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    override func constructSubviewHierarchy() {
        gradientView.addSubViews(views: [titleLabel, subTitleLabel])
        mainView.addSubViews(views: [cameraView, gradientView])
        addSubViews(views: [mainView, continueButton])
    }
    
    override func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 65),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 60),

            
            cameraView.topAnchor.constraint(equalTo: topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),

            gradientView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.3),

            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 56),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)

        ])
    }
    
    override func configureView() {
        setupAVCapture()
        addGradient()
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
    }
    
    func willAppear() {
        if !done {
            session.startRunning()
        }
    }
    
    // MARK: Button Action
    @objc func nextAction() {
        self.delegate?.proceedNextScreen()
    }
}


// AVCaptureVideoDataOutputSampleBufferDelegate protocol and related methods
extension ScanView:  AVCaptureVideoDataOutputSampleBufferDelegate{
    func setupAVCapture(){
        session.sessionPreset = AVCaptureSession.Preset.vga640x480
        guard let device = getDevice(position: viewModel.scanType == .selfie ? .front : .back) else{
                    return
                }
        captureDevice = device
        beginSession()
        done = true
    }
    
    func beginSession(){
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("error: cant get deviceInput")
                return
            }
            
            if self.session.canAddInput(deviceInput){
                self.session.addInput(deviceInput)
            }
            
            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.alwaysDiscardsLateVideoFrames=true
            videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
            videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue)
            
            if session.canAddOutput(self.videoDataOutput){
                session.addOutput(self.videoDataOutput)
            }
            
            videoDataOutput.connection(with: AVMediaType.video)?.isEnabled = true
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            
            let rootLayer: CALayer = self.cameraView.layer
            rootLayer.masksToBounds = true
            self.previewLayer.frame = rootLayer.bounds
            rootLayer.addSublayer(self.previewLayer)
            session.startRunning()
        } catch let error as NSError {
            deviceInput = nil
            print("error: \(error.localizedDescription)")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        currentFrame =   self.convertImageFromCMSampleBufferRef(sampleBuffer)
    }
    
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let captureDevices = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position).devices
        for de in captureDevices {
            let deviceConverted = de
            if(deviceConverted.position == position){
               return deviceConverted
            }
        }
       return nil
    }
    
    // clean up AVCapture
    func stopCamera(){
        session.stopRunning()
        done = false
    }
    
    func convertImageFromCMSampleBufferRef(_ sampleBuffer:CMSampleBuffer) -> CIImage{
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciImage:CIImage = CIImage(cvImageBuffer: pixelBuffer)
        return ciImage
    }
}

extension ScanView {
    func addGradient() {
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0.104, green: 0.104, blue: 0.104, alpha: 1).cgColor,
          UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer0.bounds = gradientView.bounds.insetBy(dx: -0.5*gradientView.bounds.size.width, dy: -0.5*gradientView.bounds.size.height)
        layer0.position = gradientView.center
        gradientView.layer.addSublayer(layer0)
    }
}
