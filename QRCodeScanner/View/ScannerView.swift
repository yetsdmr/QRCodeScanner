//
//  ScannerView.swift
//  QRCodeScanner
//
//  Created by Yunus Emre Taşdemir on 18.09.2023.
//

import SwiftUI
import AVKit

struct ScannerView: View {
    // QR Code Scanner Properties
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    // QR Scanner AV Output
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    // Error Properties
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Place the QR code inside the area")
                .font(.title3)
                .foregroundColor(.black.opacity (0.8))
                .padding(.top, 20)
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundColor(.gray)
            
            Spacer(minLength: 0)
            
            // Scanner
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    CameraView(frameSize: size, session: $session)
                    
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double (index) * 90
                        
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            // Trimming to get Scanner like Edges
                            .trim(from: 0.61, to: 0.64)
                            .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                    }
                    
                }
                // Sqaure Shape
                .frame(width: size.width, height: size.width)
                // Scanner Animation
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(.blue)
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? size.width : 0)
                })
                // To Make it Center
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Spacer(minLength: 15)
            
            Button {
                
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            
            Spacer (minLength: 45)

        }
        .padding(15)
        // Checking Camera Permission, when the View is Visible
        .onAppear(perform: checkCameraPermission)
        .alert(errorMessage, isPresented: $showError) {
            // Showing Setting's Button, if permission is denied
            if cameraPermission == .denied {
                Button("Settings") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settingsString) {
                        // Opening App's Setting, Using openURL SwiftUI API
                        openURL(settingsURL)
                    }
                }
                
                // Along with Cancel Button
                Button("Cancel", role: .cancel) {
                    
                }
            }
        }
        // For UI Demo
        //.onAppear {
        //    activateScannerAnimation()
        //}
    }
    
    // Activating Scanner Animation Method
    func activateScannerAnimation() {
        // Adding Delay for Each Reversal
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    // Checking Camera Permission
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                setupCamera()
            case .notDetermined:
                // Requesting Camera Access
                if await AVCaptureDevice.requestAccess(for: .video) {
                    // Permission Granted
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    // Permission Denied
                    cameraPermission = .denied
                    // Presenting Error Message
                    presentError("Please Provide Access to Camera for scanning codes")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to Camera for scanning codes")
            default: break
            }
        }
    }
    
    // Setting Up Camera
    func setupCamera() {
        do {
            // Finding Back Camera
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN ERROR")
                return
            }
            
            // Camera Input
            let input = try AVCaptureDeviceInput(device: device)
            // For Extra Saftey
            // Checking Whether input & output can be added to the session
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNKNOWN ERROR")
                return
            }
            
            // Adding Input & ouptut to Camera Session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            // Setting Ouput config to read QR Codes
            qrOutput.metadataObjectTypes = [.qr]
            
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    // Presenting Error
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
