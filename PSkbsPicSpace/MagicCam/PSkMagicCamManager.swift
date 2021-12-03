//
//  PSkMagicCamManager.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/2.
//

import Foundation
import BBMetalImage

class CamFilterItem: NSObject {
    var filterType: FilterType
    var thumbImgStr: String
    var filter: BBMetalBaseFilter?
    
    init(filterType: FilterType, thumbImgStr: String) {
        self.filterType = filterType
        self.thumbImgStr = thumbImgStr
        filter = nil
    }
    
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
        
        let filter1 = CamFilterItem(filterType: .beauty, thumbImgStr: "beauty")
        let beautyF = BBMetalBeautyFilter()
        filter1.filter = beautyF
        //
        let filter2 = CamFilterItem(filterType: .rgba, thumbImgStr: "rgba")
        let rgba_r = BBMetalRGBAFilter(red: 1.2, green: 1, blue: 1, alpha: 1)
        filter2.filter = rgba_r
        //
        let filter2_1 = CamFilterItem(filterType: .rgba, thumbImgStr: "rgba1")
        let rgba_g = BBMetalRGBAFilter(red: 1, green: 1.2, blue: 1, alpha: 1)
        filter2_1.filter = rgba_g
        //
        let filter2_2 = CamFilterItem(filterType: .rgba, thumbImgStr: "rgba2")
        let rgba_b = BBMetalRGBAFilter(red: 1, green: 1, blue: 1.2, alpha: 1)
        filter2_2.filter = rgba_b
        //
        let filter2_3 = CamFilterItem(filterType: .rgba, thumbImgStr: "rgba3")
        let rgba_y = BBMetalRGBAFilter(red: 1.2, green: 1.2, blue: 1, alpha: 1)
        filter2_3.filter = rgba_y
        //
        let filter3 = CamFilterItem(filterType: .hue, thumbImgStr: "hue")
        let hue_r = BBMetalHueFilter(hue: 40)
        filter3.filter = hue_r
        //
        let filter3_1 = CamFilterItem(filterType: .hue, thumbImgStr: "hue1")
        let hue_g = BBMetalHueFilter(hue: 80)
        filter3_1.filter = hue_g
        //
        let filter3_2 = CamFilterItem(filterType: .hue, thumbImgStr: "hue2")
        let hue_b = BBMetalHueFilter(hue: 110)
        filter3_2.filter = hue_b
        
        //
        let filter4 = CamFilterItem(filterType: .vibrance, thumbImgStr: "vibrance")
        let vibranceF = BBMetalVibranceFilter(vibrance: 1)
        filter4.filter = vibranceF
        //
        let filter5 = CamFilterItem(filterType: .whiteBalance, thumbImgStr: "whiteBalance")
        let wbF = BBMetalWhiteBalanceFilter(temperature: 7000, tint: 0)
        filter5.filter = wbF
        
        //
        let filter6 = CamFilterItem(filterType: .highlightShadow, thumbImgStr: "highlightShadow")
        let highlightShadowF = BBMetalHighlightShadowFilter(shadows: 0.5, highlights: 0.5)
        filter6.filter = highlightShadowF
        //
        let filter7 = CamFilterItem(filterType: .highlightShadowTint, thumbImgStr: "highlightShadowTint")
        let highlightShadowTintF = BBMetalHighlightShadowTintFilter(shadowTintColor: .blue,
                                             shadowTintIntensity: 0.5,
                                             highlightTintColor: .red,
                                             highlightTintIntensity: 0.5)
        filter7.filter = highlightShadowTintF
        
        //
        let filter8 = CamFilterItem(filterType: .lookup, thumbImgStr: "lookup")
        let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lookup1", withExtension: "png")!).bb_metalTexture!, intensity: 1)
        filter8.filter = lookupF
        
        //
        let filter8_1 = CamFilterItem(filterType: .lookup, thumbImgStr: "lookup1")
        let lookup1F = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lookup1", withExtension: "png")!).bb_metalTexture!, intensity: 1)
        filter8_1.filter = lookup1F
        //
        let filter8_2 = CamFilterItem(filterType: .lookup, thumbImgStr: "lookup2")
        let lookup2F = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lookup1", withExtension: "png")!).bb_metalTexture!, intensity: 1)
        filter8_2.filter = lookup2F
        //
        let filter8_3 = CamFilterItem(filterType: .lookup, thumbImgStr: "lookup3")
        let lookup3F = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lookup1", withExtension: "png")!).bb_metalTexture!, intensity: 1)
        filter8_3.filter = lookup3F
        //
        let filter8_4 = CamFilterItem(filterType: .lookup, thumbImgStr: "lookup4")
        let lookup4F = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lookup1", withExtension: "png")!).bb_metalTexture!, intensity: 1)
        filter8_4.filter = lookup4F
        
        //
        let filter9 = CamFilterItem(filterType: .colorInversion, thumbImgStr: "colorInversion")
        let colorInversionF = BBMetalColorInversionFilter()
        filter9.filter = colorInversionF
        
        //
        let filter10 = CamFilterItem(filterType: .monochrome, thumbImgStr: "monochrome")
        let monochrome = BBMetalMonochromeFilter(color: BBMetalColor(red: 0.7, green: 0.6, blue: 0.5), intensity: 1)
        filter10.filter = monochrome
        //
        let filter10_1 = CamFilterItem(filterType: .monochrome, thumbImgStr: "monochrome")
        let monochrome_1 = BBMetalMonochromeFilter(color: BBMetalColor(red: 0.3, green: 0.6, blue: 0.4), intensity: 1)
        filter10_1.filter = monochrome_1
        //
        let filter10_2 = CamFilterItem(filterType: .monochrome, thumbImgStr: "monochrome")
        let monochrome_2 = BBMetalMonochromeFilter(color: BBMetalColor(red: 0.3, green: 0.5, blue: 0.7), intensity: 1)
        filter10_2.filter = monochrome_2
        
        //
        let filter11 = CamFilterItem(filterType: .luminanceThreshold, thumbImgStr: "luminanceThreshold")
        let luminanceThreshold =  BBMetalLuminanceThresholdFilter(threshold: 0.6)
        filter11.filter = luminanceThreshold
        
        //
        let filter12 = CamFilterItem(filterType: .zoomBlur, thumbImgStr: "zoomBlur")
        let zoomBlur = BBMetalZoomBlurFilter(blurSize: 3, blurCenter: BBMetalPosition(x: 0.5, y: 0.5))
        filter12.filter = zoomBlur
        
        // ---
        let filter13 = CamFilterItem(filterType: .tiltShift, thumbImgStr: "tiltShift")
        let tiltShift = BBMetalTiltShiftFilter(sigma: 10, topFocusLevel: 2.6, bottomFocusLevel: 2.8, focusFallOffRate: 3.5)
        filter13.filter = tiltShift
        
        // ---
        let filter14 = CamFilterItem(filterType: .pixellate, thumbImgStr: "pixellate")
        let pixellate = BBMetalPixellateFilter(fractionalWidth: 0.02)
        filter14.filter = pixellate
        
        //
        let filter15 = CamFilterItem(filterType: .polkaDot, thumbImgStr: "polkaDot")
        let polkaDot = BBMetalPolkaDotFilter(fractionalWidth: 0.02, dotScaling: 0.9)
        filter15.filter = polkaDot
        
        //
        let filter16 = CamFilterItem(filterType: .halftone, thumbImgStr: "halftone")
        let halftone = BBMetalHalftoneFilter(fractionalWidth: 0.01)
        filter16.filter = halftone
        
        // ---
        let filter17 = CamFilterItem(filterType: .crosshatch, thumbImgStr: "crosshatch")
        let crosshatch = BBMetalCrosshatchFilter(crosshatchSpacing: 0.005, lineWidth: 0.003)
        filter17.filter = crosshatch
        
        // ---
        let filter18 = CamFilterItem(filterType: .sketch, thumbImgStr: "sketch")
        let sketch = BBMetalSketchFilter(edgeStrength: 0.85)
        filter18.filter = sketch
        
        // ---
        let filter19 = CamFilterItem(filterType: .toon, thumbImgStr: "toon")
        let toon = BBMetalToonFilter(threshold: 0.8, quantizationLevels: 15)
        filter19.filter = toon
        
        // ---
        let filter20 = CamFilterItem(filterType: .vignette, thumbImgStr: "vignette")
        let vignette = BBMetalVignetteFilter(center: .center, color: .black, start: 0.1, end: 0.5)
        filter20.filter = vignette
        
        // ---
        let filter21 = CamFilterItem(filterType: .kuwahara, thumbImgStr: "kuwahara")
        let kuwahara = BBMetalKuwaharaFilter(radius: 4)
        filter21.filter = kuwahara
        
        // ---
        let filter22 = CamFilterItem(filterType: .swirl, thumbImgStr: "swirl")
        let swirl = BBMetalSwirlFilter(center: BBMetalPosition(x: 0.5, y: 0.5), radius: 0.25, angle: 0.12)
        filter22.filter = swirl
        
        //
        let filter23 = CamFilterItem(filterType: .bulge, thumbImgStr: "bulge")
        let bulge = BBMetalBulgeFilter(center: BBMetalPosition(x: 0.5, y: 0.5))
        filter23.filter = bulge
        
        //
        let filter24 = CamFilterItem(filterType: .pinch, thumbImgStr: "pinch")
        let pinch = BBMetalPinchFilter(center: BBMetalPosition(x: 0.5, y: 0.5))
        filter24.filter = pinch
        
        //
        let filter25 = CamFilterItem(filterType: .sobelEdgeDetection, thumbImgStr: "sobelEdgeDetection")
        let sobelEdgeDetection = BBMetalSobelEdgeDetectionFilter()
        filter25.filter = sobelEdgeDetection
        
        //
        let filter26 = CamFilterItem(filterType: .bilateralBlur, thumbImgStr: "bilateralBlur")
        let bilateralBlur = BBMetalBilateralBlurFilter()
        filter26.filter = bilateralBlur
        
        //
        let filter27 = CamFilterItem(filterType: .hueBlend, thumbImgStr: "hueBlend") // 生化危机那种感觉的图 红色和绿色的血迹
        let hueBlend = BBMetalHueBlendFilter()
        filter27.filter = hueBlend
        
        //
        camFilterList = [filter1, filter2, filter2_1, filter2_2, filter2_3, filter3, filter3_1, filter3_2, filter4, filter5, filter6, filter7, filter8, filter8_1, filter8_2, filter8_3, filter8_4, filter9, filter10, filter10_1, filter10_2, filter11, filter12, filter13, filter14, filter15, filter16, filter17, filter18, filter19, filter20, filter21, filter22, filter23, filter24, filter25, filter26, filter27]
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
