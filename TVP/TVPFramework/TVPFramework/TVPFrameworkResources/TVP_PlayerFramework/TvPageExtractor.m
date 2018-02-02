//
//  TvPageExtractor.h,
//  TvPageExtractor
//
#import "TvPageExtractor.h"
@import AVFoundation;

@interface TvPageExtractor ()

@property (nonatomic, assign) TvPageExtractorAttemptType attemptType;

@end

static NSDictionary *DictionaryWithQueryString(NSString *string, NSStringEncoding encoding) {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    NSArray *fields = [string componentsSeparatedByString:@"&"];
    for (NSString *field in fields) {
        NSArray *pair = [field componentsSeparatedByString:@"="];
        if ([pair count] == 2) {
            NSString *key = pair[0];
            NSString *value = [pair[1] stringByReplacingPercentEscapesUsingEncoding:encoding];
            value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            dictionary[key] = value;
        }
    }
    return dictionary;
}

static NSString *ApplicationLanguageIdentifier(void)
{
    static NSString *applicationLanguageIdentifier;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        applicationLanguageIdentifier = @"en";
        NSArray *preferredLocalizations = [[NSBundle mainBundle] preferredLocalizations];
        if (preferredLocalizations.count > 0)
            applicationLanguageIdentifier = [NSLocale canonicalLanguageIdentifierFromString:preferredLocalizations[0]] ?: applicationLanguageIdentifier;
    });
    return applicationLanguageIdentifier;
}

@implementation TvPageExtractor

+ (TvPageExtractor *)sharedInstance {
    static TvPageExtractor *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [TvPageExtractor new];
    });
    return _sharedInstance;
}

-(NSArray*)preferredVideoQualities {
    return @[ @(TvPageExtractorVideoQualityHD720),
              @(TvPageExtractorVideoQualityMedium360),
              @(TvPageExtractorVideoQualitySmall240),@(TvPageExtractorVideoQualitySmall144),@(TvPageExtractorVideoQualityMedium360WEBM)];
    
}

-(void)extractVideoForIdentifier:(NSString*)videoIdentifier completion:(void (^)(NSDictionary *videoDictionary, NSError *error))completion {
    if (videoIdentifier && [videoIdentifier length] > 0) {
        if (self.attemptType == TvPageExtractorAttemptTypeError) {
            NSError *error = [NSError errorWithDomain:@"com.TvPageExtractor.extractor" code:404 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"Unable to find playable content" }];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            self.attemptType = TvPageExtractorAttemptTypeEmbedded;
            return;
        }
        NSMutableDictionary *parameters = [@{} mutableCopy];
        switch (self.attemptType) {
            case TvPageExtractorAttemptTypeEmbedded:
                parameters[@"el"] = @"embedded";
                break;
            case TvPageExtractorAttemptTypeDetailPage:
                parameters[@"el"] = @"detailpage";
                break;
            case TvPageExtractorAttemptTypeVevo:
                parameters[@"el"] = @"vevo";
                break;
            case TvPageExtractorAttemptTypeBlank:
                parameters[@"el"] = @"";
                break;
            default:
                break;
        }
        parameters[@"video_id"] = videoIdentifier;
        parameters[@"ps"] = @"default";
        parameters[@"eurl"] = @"";
        parameters[@"gl"] = @"US";
        parameters[@"hl"] = ApplicationLanguageIdentifier();
        
        NSString *urlString = [self addQueryStringToUrlString:@"https://www.youtube.com/get_video_info" withParameters:parameters];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:urlString]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (!error) {
                        NSString *videoQuery = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                        NSStringEncoding queryEncoding = NSUTF8StringEncoding;
                        NSDictionary *video = DictionaryWithQueryString(videoQuery, queryEncoding);
                        // hlsvp
                        NSMutableArray *streamQueries = [[video[@"url_encoded_fmt_stream_map"] componentsSeparatedByString:@","] mutableCopy];
                        [streamQueries addObjectsFromArray:[video[@"adaptive_fmts"] componentsSeparatedByString:@","]];
                        NSMutableDictionary *streamURLs = [NSMutableDictionary new];
                        for (NSString *streamQuery in streamQueries) {
                            NSDictionary *stream = DictionaryWithQueryString(streamQuery, queryEncoding);
                            NSString *type = stream[@"type"];
                            NSString *urlString = stream[@"url"];
                            if (urlString && [AVURLAsset isPlayableExtendedMIMEType:type]) {
                                NSURL *streamURL = [NSURL URLWithString:urlString];
                                //                               BOOL hasSignature = [[DictionaryWithQueryString(streamURL.query, queryEncoding) allKeys] containsObject:@"signature"];
                                //                               if (!hasSignature && stream[@"sig"]) {
                                //                                   streamURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&signature=%@", urlString, stream[@"sig"]]];
                                //                                   hasSignature = YES;
                                //                               }
                                //                               if (hasSignature && (   [stream[@"itag"] integerValue] == TvPageExtractorVideoQualitySmall240
                                //                                                    || [stream[@"itag"] integerValue] == TvPageExtractorVideoQualityMedium360
                                //                                                    || [stream[@"itag"] integerValue] == TvPageExtractorVideoQualityHD720
                                //                                                    || [stream[@"itag"] integerValue] == TvPageExtractorVideoQualitySmall144
                                //                                                    || [stream[@"itag"] integerValue] == TvPageExtractorVideoQualityMedium360WEBM
                                //                                                    )) {
                                if (  [stream[@"itag"] integerValue] == TvPageExtractorVideoQualitySmall240
                                    || [stream[@"itag"] integerValue] == TvPageExtractorVideoQualityMedium360
                                    || [stream[@"itag"] integerValue] == TvPageExtractorVideoQualityHD720
                                    || [stream[@"itag"] integerValue] == TvPageExtractorVideoQualitySmall144
                                    || [stream[@"itag"] integerValue] == TvPageExtractorVideoQualityMedium360WEBM
                                    ) {
                                    
                                    streamURLs[@([stream[@"itag"] integerValue])] = streamURL;
                                }
                            }
                            if ([[streamURLs allKeys] count] == 5) {
                                break;
                            }
                        }
                        
                        self.attemptType++;
                        
                        if ([[streamURLs allKeys] count] == 0) {
                            [self extractVideoForIdentifier:videoIdentifier completion:completion];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(streamURLs, nil);
                            });
                            self.attemptType = TvPageExtractorAttemptTypeEmbedded;
                        }
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(nil, error);
                        });
                        self.attemptType = TvPageExtractorAttemptTypeEmbedded;
                    }
                }
          ] resume];
    } else {
        NSError *error = [NSError errorWithDomain:@"com.theappboutique.rmyoutubeextractor" code:400 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"Invalid or missing YouTube video identifier" }];
        completion(nil, error);
    }
}

- (NSString*)urlEscapeString:(NSString *)unencodedString {
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *string = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return string;
}
- (NSString*)addQueryStringToUrlString:(NSString *)urlString withParameters:(NSDictionary *)dictionary {
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    return urlWithQuerystring;
}

@end
