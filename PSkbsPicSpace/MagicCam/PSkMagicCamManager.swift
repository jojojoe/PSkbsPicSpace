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
    
    init(filterType: FilterType) {
        self.filterType = filterType
        self.thumbImgStr = filterType.rawValue
        super.init()
        self.filter = makeFilter()
    }
    
    
    func makeFilter() -> BBMetalBaseFilter {
        switch filterType {
        case .beauty:
            return BBMetalBeautyFilter()
        case .rgba1:
            return BBMetalRGBAFilter(red: 1.2, green: 1, blue: 1, alpha: 1)
        case .rgba2:
            return BBMetalRGBAFilter(red: 1, green: 1.2, blue: 1, alpha: 1)
        case .rgba3:
            return BBMetalRGBAFilter(red: 1, green: 1, blue: 1.2, alpha: 1)
        case .rgba4:
            return BBMetalRGBAFilter(red: 1.2, green: 1.2, blue: 1, alpha: 1)
        case .rgba5:
            return BBMetalRGBAFilter(red: 1.2, green: 1.2, blue: 1.2, alpha: 1)
        case .hue1:
            return BBMetalHueFilter(hue: 40)
        case .hue2:
            return BBMetalHueFilter(hue: 80)
        case .hue3:
            return BBMetalHueFilter(hue: 120)
        case .hue4:
            return BBMetalHueFilter(hue: 180)
        case .vibrance:
            return BBMetalVibranceFilter(vibrance: 1)
        case .highlightShadowTint:
            return BBMetalHighlightShadowTintFilter(shadowTintColor: .blue,
                                                         shadowTintIntensity: 0.5,
                                                         highlightTintColor: .red,
                                                         highlightTintIntensity: 0.5)
        case .lookup1:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lookup1", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .lookup2:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "曼谷", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .lookup3:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "棉花糖", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .lookup4:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "日光", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .lookup5:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "藤蔓", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .lookup6:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lookup_002", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .lookup7:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lut3", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .lookup8:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lut7", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .lookup9:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lut10", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .lookup10:
            let lookupF = try! BBMetalLookupFilter(lookupTable: Data(contentsOf: Bundle.main.url(forResource: "lut15", withExtension: "png")!).bb_metalTexture!, intensity: 1)
            return lookupF
        case .monochrome1:
            return BBMetalMonochromeFilter(color: BBMetalColor(red: 0.7, green: 0.6, blue: 0.5), intensity: 1)
        case .monochrome2:
            return BBMetalMonochromeFilter(color: BBMetalColor(red: 0.3, green: 0.6, blue: 0.4), intensity: 1)
        case .monochrome3:
            return BBMetalMonochromeFilter(color: BBMetalColor(red: 0.3, green: 0.5, blue: 0.7), intensity: 1)
        case .monochrome4:
            return BBMetalMonochromeFilter(color: BBMetalColor(red: 0.8, green: 0.5, blue: 0.7), intensity: 1)
        case .monochrome5:
            return BBMetalMonochromeFilter(color: BBMetalColor(red: 0.3, green: 0.9, blue: 0.4), intensity: 1)
        case .zoomBlur:
            return BBMetalZoomBlurFilter(blurSize: 3, blurCenter: BBMetalPosition(x: 0.5, y: 0.5))
        case .tiltShift:
            return BBMetalTiltShiftFilter(sigma: 30, topFocusLevel: 14.6, bottomFocusLevel: 55.8, focusFallOffRate: 25.5)
        case .pixellate:
            return BBMetalPixellateFilter(fractionalWidth: 0.02)
        case .polkaDot:
            return BBMetalPolkaDotFilter(fractionalWidth: 0.02, dotScaling: 0.9)
        case .halftone:
            return BBMetalHalftoneFilter(fractionalWidth: 0.01)
        case .crosshatch:
            return BBMetalCrosshatchFilter(crosshatchSpacing: 0.005, lineWidth: 0.003)
        case .sketch:
            return BBMetalSketchFilter(edgeStrength: 0.85)
        case .vignette:
            return BBMetalVignetteFilter(center: .center, color: .black, start: 0.1, end: 0.5)
        case .kuwahara:
            return BBMetalKuwaharaFilter(radius: 4)
        case .swirl:
            return BBMetalSwirlFilter(center: BBMetalPosition(x: 0.5, y: 0.5), radius: 0.25, angle: 0.12)
        case .bulge:
            return BBMetalBulgeFilter(center: BBMetalPosition(x: 0.5, y: 0.5), radius: 0.5, scale: 0.5)
        case .pinch:
            return BBMetalPinchFilter(center: BBMetalPosition(x: 0.5, y: 0.5), radius: 0.5, scale: 0.5)
        case .sobelEdgeDetection:
            return BBMetalSobelEdgeDetectionFilter()
        }
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
    
        
        let beauty = CamFilterItem(filterType: .beauty)
        let rgba1 = CamFilterItem(filterType: .rgba1)
        let rgba2 = CamFilterItem(filterType: .rgba2)
        let rgba3 = CamFilterItem(filterType: .rgba3)
        let rgba4 = CamFilterItem(filterType: .rgba4)
        let rgba5 = CamFilterItem(filterType: .rgba5)
        let hue1 = CamFilterItem(filterType: .hue1)
        let hue2 = CamFilterItem(filterType: .hue2)
        let hue3 = CamFilterItem(filterType: .hue3)
        let hue4 = CamFilterItem(filterType: .hue4)
        let vibrance = CamFilterItem(filterType: .vibrance)
        let highlightShadowTint = CamFilterItem(filterType: .highlightShadowTint)
        let lookup1 = CamFilterItem(filterType: .lookup1)
        let lookup2 = CamFilterItem(filterType: .lookup2)
        let lookup3 = CamFilterItem(filterType: .lookup3)
        let lookup4 = CamFilterItem(filterType: .lookup4)
        let lookup5 = CamFilterItem(filterType: .lookup5)
        let lookup6 = CamFilterItem(filterType: .lookup6)
        let lookup7 = CamFilterItem(filterType: .lookup7)
        let lookup8 = CamFilterItem(filterType: .lookup8)
        let lookup9 = CamFilterItem(filterType: .lookup9)
        let lookup10 = CamFilterItem(filterType: .lookup10)
        let monochrome1 = CamFilterItem(filterType: .monochrome1)
        let monochrome2 = CamFilterItem(filterType: .monochrome2)
        let monochrome3 = CamFilterItem(filterType: .monochrome3)
        let monochrome4 = CamFilterItem(filterType: .monochrome4)
        let monochrome5 = CamFilterItem(filterType: .monochrome5)
        let zoomBlur = CamFilterItem(filterType: .zoomBlur)
        let tiltShift = CamFilterItem(filterType: .tiltShift)
        let pixellate = CamFilterItem(filterType: .pixellate)
        let polkaDot = CamFilterItem(filterType: .polkaDot)
        let halftone = CamFilterItem(filterType: .halftone)
        let crosshatch = CamFilterItem(filterType: .crosshatch)
        let sketch = CamFilterItem(filterType: .sketch)
        let vignette = CamFilterItem(filterType: .vignette)
        let kuwahara = CamFilterItem(filterType: .kuwahara)
        let swirl = CamFilterItem(filterType: .swirl)
        let bulge = CamFilterItem(filterType: .bulge)
        let pinch = CamFilterItem(filterType: .pinch)
        let sobelEdgeDetection = CamFilterItem(filterType: .sobelEdgeDetection)
          
        
        //
        camFilterList = [beauty,
                         rgba1,
                         rgba2,
                         rgba3,
                         rgba4,
                         rgba5,
                         hue1,
                         hue2,
                         hue3,
                         hue4,
                         vibrance,
                         highlightShadowTint,
                         lookup1,
                         lookup2,
                         lookup3,
                         lookup4,
                         lookup5,
                         lookup6,
                         lookup7,
                         lookup8,
                         lookup9,
                         lookup10,
                         monochrome1,
                         monochrome2,
                         monochrome3,
                         monochrome4,
                         monochrome5,
                         zoomBlur,
                         tiltShift,
                         pixellate,
                         polkaDot,
                         halftone,
                         crosshatch,
                         sketch,
                         vignette,
                         kuwahara,
                         swirl,
                         bulge,
                         pinch,
                         sobelEdgeDetection]
    }
    
       
    
    
}







enum FilterType: String {
    case beauty
    case rgba1
    case rgba2
    case rgba3
    case rgba4
    case rgba5
    case hue1
    case hue2
    case hue3
    case hue4
    case vibrance
    case highlightShadowTint
    case lookup1
    case lookup2
    case lookup3
    case lookup4
    case lookup5
    case lookup6
    case lookup7
    case lookup8
    case lookup9
    case lookup10
    case monochrome1
    case monochrome2
    case monochrome3
    case monochrome4
    case monochrome5
    case zoomBlur
    case tiltShift
    case pixellate
    case polkaDot
    case halftone
    case crosshatch
    case sketch
    case vignette
    case kuwahara
    case swirl
    case bulge
    case pinch
    case sobelEdgeDetection
}





/*
{
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
*/



