//
//  TvPageExtractor.h
//  TvPageExtractor
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, TvPageExtractorAttemptType) {
    TvPageExtractorAttemptTypeEmbedded = 0,
    TvPageExtractorAttemptTypeDetailPage,
    TvPageExtractorAttemptTypeVevo,
    TvPageExtractorAttemptTypeBlank,
    TvPageExtractorAttemptTypeError
};

typedef NS_ENUM (NSUInteger, TvPageExtractorVideoQuality) {
    TvPageExtractorVideoQualityFLV244  = 5,
    TvPageExtractorVideoQualitySmall144  = 17,
    TvPageExtractorVideoQualitySmall240  = 36,
    TvPageExtractorVideoQualityMedium360 = 43,
    TvPageExtractorVideoQualityMedium360WEBM = 18,
    TvPageExtractorVideoQualityHD720     = 22
    
};

@interface TvPageExtractor : NSObject

+(TvPageExtractor*)sharedInstance;

-(void)extractVideoForIdentifier:(NSString*)videoIdentifier completion:(void (^)(NSDictionary *videoDictionary, NSError *error))completion;

-(NSArray*)preferredVideoQualities;

@end
