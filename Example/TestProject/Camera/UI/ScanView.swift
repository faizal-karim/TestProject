//
//  ScanView.swift
//  TestProject_Example
//
//  Created by Faizal on 2/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import AVKit

typealias Scene = ScanView.Navigation

protocol ScanViewDelegate: AnyObject {
    func saveAndContinue(toNext type: ScanType)
    func moveToNextScreen(scene: Scene)

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
    enum Navigation {
        case documentList, profile
    }

    enum ButtonType {
        case capture, retake, save
    }
    
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
        
    let hStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 40
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let captchaLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Zapfino-Regular", size: 20)
        label.text = "MMw124"
        label.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.setCornerRadius(5)
        return label
    }()
    
    let captchaHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Type the characters above"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.init(hexString: "929292")
        label.textAlignment = .left
        return label
    }()
    
    let captchaTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let captchaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.setCornerRadius(5)
        return view
    }()
    
    let captchaContinueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.init(hexString: "61AF2B")
        button.setCornerRadius(8)
        button.setImage(UIImage(named: "arrow"), for: .normal)
        button.addTarget(self, action: #selector(captchaContinueAction), for: .touchUpInside)
        return button
    }()
    
    let captureButton: UIButton = {
        let button = prepareCameraButton(type: .capture)
        button.addTarget(self, action: #selector(captureAction), for: .touchUpInside)
        return button
    }()
    
    let retakeButton: UIButton = {
        let button = prepareCameraButton(type: .retake)
        button.addTarget(self, action: #selector(retakeAction), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = prepareCameraButton(type: .save)
        button.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return button
    }()
    
    let livenessStackView: UIStackView = {
       let stack = UIStackView()
       stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 15
       return stack
    }()

    let cameraView = prepareView()
    let mainView = prepareView()
    let gradientView = prepareView()
    
    // MARK: Init Methods
    init(viewModel: ScanViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    override func constructSubviewHierarchy() {
        captchaView.addSubViews(views: [captchaHeaderLabel, captchaTextField, captchaContinueButton])
        livenessStackView.addAddrrangedSubViews(views: [captchaLabel, captchaView])
        hStackView.addAddrrangedSubViews(views: [captureButton, retakeButton, saveButton])
        gradientView.addSubViews(views: [titleLabel, subTitleLabel])
        mainView.addSubViews(views: [cameraView, gradientView])
        addSubViews(views: [mainView, hStackView, livenessStackView])
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
            
            mainView.topAnchor.constraint(equalTo: safeTopAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: safeBottomAnchor),

            
            cameraView.topAnchor.constraint(equalTo: mainView.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),


            gradientView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.2),
            
            livenessStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            livenessStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            livenessStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            livenessStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            
            hStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStackView.heightAnchor.constraint(equalToConstant: 70),
            hStackView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -40),
                    
            captchaLabel.heightAnchor.constraint(equalToConstant: 50),
            captchaView.heightAnchor.constraint(equalToConstant: 65),

            captchaHeaderLabel.topAnchor.constraint(equalTo: captchaView.topAnchor, constant: 3),
            captchaHeaderLabel.leadingAnchor.constraint(equalTo: captchaView.leadingAnchor, constant: 5),
            
            captchaContinueButton.trailingAnchor.constraint(equalTo: captchaView.trailingAnchor, constant: -5),
            captchaContinueButton.centerYAnchor.constraint(equalTo: captchaView.centerYAnchor),
            captchaContinueButton.heightAnchor.constraint(equalToConstant: 43),
            captchaContinueButton.widthAnchor.constraint(equalToConstant: 43),

            
            captchaTextField.topAnchor.constraint(equalTo: captchaHeaderLabel.bottomAnchor, constant: 10),
            captchaTextField.leadingAnchor.constraint(equalTo: captchaView.leadingAnchor, constant: 5),
            captchaTextField.bottomAnchor.constraint(equalTo: captchaView.bottomAnchor, constant: -10),

            captchaTextField.trailingAnchor.constraint(equalTo: captchaContinueButton.leadingAnchor, constant: -10),

            
            
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            retakeButton.heightAnchor.constraint(equalToConstant: 70),
            saveButton.heightAnchor.constraint(equalToConstant: 70),

            captureButton.widthAnchor.constraint(equalToConstant: 70),
            retakeButton.widthAnchor.constraint(equalToConstant: 70),
            saveButton.widthAnchor.constraint(equalToConstant: 70)

            
        ])
    }
    
    
    override func configureView() {
        setupAVCapture()
        addGradient()
        livenessStackView.isHidden = viewModel.scanType != .liveness
        hStackView.isHidden = viewModel.scanType == .liveness
        configureButtons(isCaptured: false)
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
    }
    
    func willAppear() {
        if !done {
            session.startRunning()
        }
    }
    
    func configureButtons(isCaptured: Bool) {
        guard viewModel.scanType != .liveness else {
            self.captureButton.isHidden = true
            self.saveButton.isHidden = true
            self.retakeButton.isHidden = true
            return
        }
        
        self.captureButton.isHidden = isCaptured
        self.saveButton.isHidden = !isCaptured
        self.retakeButton.isHidden = !isCaptured
    }
    
    // MARK: Button Action
    @objc func saveAction() {
        guard let type = ScanType(rawValue: viewModel.scanType.rawValue + 1), type != .liveness else {
            self.delegate?.moveToNextScreen(scene: .documentList)
            return
        }
        self.delegate?.saveAndContinue(toNext: type)
    }
    
    @objc func captureAction() {
        session.stopRunning()
        configureButtons(isCaptured: true)
    }
    
    @objc func retakeAction() {
        configureButtons(isCaptured: false)
    setupAVCapture()
    }
    
    @objc func captchaContinueAction() {
        self.delegate?.moveToNextScreen(scene: .profile)
    }
}


// AVCaptureVideoDataOutputSampleBufferDelegate protocol and related methods
extension ScanView:  AVCaptureVideoDataOutputSampleBufferDelegate{
    func setupAVCapture(){
        session.sessionPreset = AVCaptureSession.Preset.vga640x480
        let isFrontCamera = viewModel.scanType == .selfie  || viewModel.scanType == .liveness
        guard let device = getDevice(position: isFrontCamera ? .front : .back) else{
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
            self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
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
            UIColor.black.withAlphaComponent(0.85).cgColor,
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
