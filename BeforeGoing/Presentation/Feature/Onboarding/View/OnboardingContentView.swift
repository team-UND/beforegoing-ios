//
//  OnboardingContentView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/6/25.
//

import UIKit

final class OnboardingContentView: BaseView {
    
    private let firstStepGIFName = "hi_worry"
    private let endStepGIFName = "jump_worry"
    private let gifExtension = "gif"
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    
    override func setStyle() {
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.headingH4)
            $0.textAlignment = .center
        }
        descriptionLabel.do {
            $0.textColor = .gray400
            $0.font = .custom(.bodyLGMedium)
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            descriptionLabel,
            imageView
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

extension OnboardingContentView {
    
    func updateUI(step: OnboardingStep) {
        let component = step.component
        
        titleLabel.text = component.title
        descriptionLabel.text = component.description
        
        if step == .first {
            playGIF(name: firstStepGIFName)
        } else if step == .end {
            playGIF(name: endStepGIFName)
        } else {
            imageView.stopAnimating()
            imageView.image = component.image
        }
        
        setLayout(step: step)
    }
    
    private func setLayout(step: OnboardingStep) {
        switch step {
        case .first:
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(50.adjustedH)
                $0.centerX.equalToSuperview()
            }
            descriptionLabel.snp.remakeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
                $0.centerX.equalToSuperview()
            }
            imageView.snp.remakeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(94.adjustedH)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(260.adjustedH)
            }
        case .second, .third, .fourth, .fifth:
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.height.equalTo(26.adjustedH)
            }
            descriptionLabel.snp.remakeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(44.adjustedH)
            }
            imageView.snp.remakeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(34.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(322.adjustedW)
                $0.height.equalTo(596.adjustedH)
            }
        case .end:
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
            descriptionLabel.snp.remakeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
                $0.centerX.equalToSuperview()
            }
            imageView.snp.remakeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(94.adjustedH)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(260.adjustedH)
            }
        }
    }
    
    private func playGIF(name: String) {
        guard let gifSource = fetchGIF(name: name) else {
            return
        }

        imageView.do {
            $0.animationImages = gifSource.images
            $0.animationDuration = TimeInterval(gifSource.frameCount) * 0.1
            $0.animationRepeatCount = 0
            $0.startAnimating()
        }
    }
    
    private func fetchGIF(name: String) -> (images: [UIImage], frameCount: Int)? {
        guard
            let gifData = NSDataAsset(name: name)?.data,
            let source = CGImageSourceCreateWithData(gifData as CFData, nil)
        else { return nil }
        
        let frameCount = CGImageSourceGetCount(source)
        var images = [UIImage]()

        (0..<frameCount)
            .compactMap { CGImageSourceCreateImageAtIndex(source, $0, nil) }
            .forEach { images.append(UIImage(cgImage: $0)) }

        return (images, frameCount)
    }
}
