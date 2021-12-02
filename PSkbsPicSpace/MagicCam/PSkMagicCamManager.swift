//
//  PSkMagicCamManager.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/2.
//

import Foundation


struct CamFilterItem {
    var filterType: FilterType
    var thumbImgStr: String
    
}
/*
 ColorMatrix
 RGBA
 Hue
 Vibrance
 WhiteBalance
 HighlightShadow
 HighlightShadowTint
 Lookup
 ColorInversion
 Monochrome
 Luminance
 ZoomBlur
 tiltShift
 Pixellate
 polkaDot
 Halftone
 Crosshatch
 Sketch
 Toon
 Vignette
 Kuwahara
 Swirl
 Bulge
 Pinch
 SobelEdgeDetection
 BilateralBlur
 
 */
class PSkMagicCamManager {
    
    static let `default` = PSkMagicCamManager()
    var camFilterList: [CamFilterItem] = []
    
    init() {
        loadFilter()
    }
    
    func loadFilter() {
        let filter1 = CamFilterItem(filterType: .colorMatrix, thumbImgStr: "colorMatrix")
        let filter2 = CamFilterItem(filterType: .rgba, thumbImgStr: "rgba")
        let filter3 = CamFilterItem(filterType: .hue, thumbImgStr: "hue")
        let filter4 = CamFilterItem(filterType: .vibrance, thumbImgStr: "vibrance")
        let filter5 = CamFilterItem(filterType: .whiteBalance, thumbImgStr: "whiteBalance")
        let filter6 = CamFilterItem(filterType: .highlightShadow, thumbImgStr: "highlightShadow")
        let filter7 = CamFilterItem(filterType: .highlightShadowTint, thumbImgStr: "highlightShadowTint")
        let filter8 = CamFilterItem(filterType: .lookup, thumbImgStr: "lookup")
        let filter9 = CamFilterItem(filterType: .colorInversion, thumbImgStr: "colorInversion")
        let filter10 = CamFilterItem(filterType: .monochrome, thumbImgStr: "monochrome")
        let filter11 = CamFilterItem(filterType: .luminance, thumbImgStr: "luminance")
        let filter12 = CamFilterItem(filterType: .zoomBlur, thumbImgStr: "zoomBlur")
        let filter13 = CamFilterItem(filterType: .tiltShift, thumbImgStr: "tiltShift")
        let filter14 = CamFilterItem(filterType: .pixellate, thumbImgStr: "pixellate")
        let filter15 = CamFilterItem(filterType: .polkaDot, thumbImgStr: "polkaDot")
        let filter16 = CamFilterItem(filterType: .halftone, thumbImgStr: "halftone")
        let filter17 = CamFilterItem(filterType: .crosshatch, thumbImgStr: "crosshatch")
        let filter18 = CamFilterItem(filterType: .sketch, thumbImgStr: "sketch")
        let filter19 = CamFilterItem(filterType: .toon, thumbImgStr: "toon")
        let filter20 = CamFilterItem(filterType: .vignette, thumbImgStr: "vignette")
        let filter21 = CamFilterItem(filterType: .kuwahara, thumbImgStr: "kuwahara")
        let filter22 = CamFilterItem(filterType: .swirl, thumbImgStr: "swirl")
        let filter23 = CamFilterItem(filterType: .bulge, thumbImgStr: "bulge")
        let filter24 = CamFilterItem(filterType: .pinch, thumbImgStr: "pinch")
        let filter25 = CamFilterItem(filterType: .sobelEdgeDetection, thumbImgStr: "sobelEdgeDetection")
        let filter26 = CamFilterItem(filterType: .bilateralBlur, thumbImgStr: "bilateralBlur")
        
        camFilterList = [filter1, filter2, filter3, filter4, filter5, filter6, filter7, filter8, filter9, filter10, filter11, filter12, filter13, filter4, filter15, filter16, filter17, filter18, filter19, filter20, filter21, filter22, filter23, filter24, filter25, filter26]
    }
    
    
}







enum FilterType {
    case brightness
    case exposure
    case contrast
    case saturation
    case gamma
    case levels
    case colorMatrix
    case rgba
    case hue
    case vibrance
    case whiteBalance
    case highlightShadow
    case highlightShadowTint
    case lookup
    case colorInversion
    case monochrome
    case falseColor
    case haze
    case luminance
    case luminanceThreshold
    case erosion
    case rgbaErosion
    case dilation
    case rgbaDilation
    case chromaKey
    case crop
    case resize
    case rotate
    case flip
    case transform
    case sharpen
    case unsharpMask
    case gaussianBlur
    case boxBlur
    case zoomBlur
    case motionBlur
    case tiltShift
    case normalBlend
    case chromaKeyBlend
    case dissolveBlend
    case addBlend
    case subtractBlend
    case multiplyBlend
    case divideBlend
    case overlayBlend
    case darkenBlend
    case lightenBlend
    case colorBlend
    case colorBurnBlend
    case colorDodgeBlend
    case screenBlend
    case exclusionBlend
    case differenceBlend
    case hardLightBlend
    case softLightBlend
    case alphaBlend
    case sourceOverBlend
    case hueBlend
    case saturationBlend
    case luminosityBlend
    case linearBurnBlend
    case maskBlend
    case pixellate
    case polarPixellate
    case polkaDot
    case halftone
    case crosshatch
    case sketch
    case thresholdSketch
    case toon
    case posterize
    case vignette
    case kuwahara
    case swirl
    case bulge
    case pinch
    case convolution3x3
    case emboss
    case sobelEdgeDetection
    case bilateralBlur
    case beauty
}
