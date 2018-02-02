
import UIKit

//MARK: - Model Class
public class ModelVideoList {
    
    //Variable Declaration
    var CVV_VI:String = ""
    var VIDEO_LENGTH:String = ""
    var VV_VI:String = ""
    var asset = ModelVideoAsset(dictJSON: NSDictionary())
    var category:String = ""
    var category_id_1:String = ""
    var category_id_2:String = ""
    var conversion_score:String = ""
    var date_created:String = ""
    var date_modified:String = ""
    var description:String = ""
    var duration:String = ""
    var engagement_score:String = ""
    var entityIdParent:String = ""
    var entityType:String = ""
    var id:String = ""
    var loginId:String = ""
    var merchandised:String = ""
    var metrics_statistics = ModelVideoMetricsStatistics(dictJSON: NSDictionary())
    var product_category:String = ""
    var published:String = ""
    var referenceId:String = ""
    var settings:String = ""
    var sortOrder:String = ""
    var sourceId:String = ""
    var status:String = ""
    var tags:String = ""
    var title:String = ""
    var titleTextEncoded:String = ""
    var transcripts:String = ""
    var tvp_profiles = NSArray()
    var tvp_profiles_manual:String = ""
    var tvp_profiles_maxscore:String = ""
    var video_type:String = ""
    var visibility:String = ""
    var dictJSON:NSDictionary = NSDictionary()
    
    //Memory Allocation
    init(dictJSON:NSDictionary) {
        
        self.dictJSON = dictJSON.mutableCopy() as! NSDictionary
        self.CVV_VI = dictJSON.getString(key: "CVV_VI")
        self.VIDEO_LENGTH = dictJSON.getString(key: "VIDEO_LENGTH")
        self.VV_VI = dictJSON.getString(key: "VV_VI")
        self.asset = ModelVideoAsset(dictJSON: dictJSON.getDictionary(key: "asset"))
        self.category = dictJSON.getString(key: "category")
        self.category_id_1 = dictJSON.getString(key: "category_id_1")
        self.category_id_2 = dictJSON.getString(key: "category_id_2")
        self.conversion_score = dictJSON.getString(key: "conversion_score")
        self.date_created = dictJSON.getString(key: "date_created")
        self.date_modified = dictJSON.getString(key: "date_modified")
        self.description = dictJSON.getString(key: "description")
        self.duration = dictJSON.getString(key: "duration")
        self.engagement_score = dictJSON.getString(key: "engagement_score")
        self.entityIdParent = dictJSON.getString(key: "entityIdParent")
        self.entityType = dictJSON.getString(key: "entityType")
        self.id = dictJSON.getString(key: "id")
        self.loginId = dictJSON.getString(key: "loginId")
        self.merchandised = dictJSON.getString(key: "merchandised")
        self.metrics_statistics = ModelVideoMetricsStatistics(dictJSON: dictJSON.getDictionary(key: "metrics_statistics"))
        self.product_category = dictJSON.getString(key: "product_category")
        self.published = dictJSON.getString(key: "published")
        self.referenceId = dictJSON.getString(key: "referenceId")
        self.settings = dictJSON.getString(key: "settings")
        self.sortOrder = dictJSON.getString(key: "sortOrder")
        self.sourceId = dictJSON.getString(key: "sourceId")
        self.status = dictJSON.getString(key: "status")
        self.tags = dictJSON.getString(key: "tags")
        self.title = dictJSON.getString(key: "title")
        self.titleTextEncoded = dictJSON.getString(key: "titleTextEncoded")
        self.transcripts = dictJSON.getString(key: "transcripts")
        self.tvp_profiles = dictJSON.getArray(key: "tvp_profiles")
        self.tvp_profiles_manual = dictJSON.getString(key: "tvp_profiles_manual")
        self.tvp_profiles_maxscore = dictJSON.getString(key: "tvp_profiles_maxscore")
        self.video_type = dictJSON.getString(key: "video_type")
        self.visibility = dictJSON.getString(key: "visibility")
    }
}
//MARK: - Model Video Asset
class ModelVideoAsset {
    
    //Variable Declaration
    var author:String = ""
    var description:String = ""
    var mediaDuration:String = ""
    var prettyDuration:String = ""
    var sources = [ModelVideoAssetSources]()
    var quality:String = ""
    var thumbnailUrl:String = ""
    var title:String = ""
    var type:String = ""
    var uploadAsset:String = ""
    var uploadDate:String = ""
    var videoId:String = ""
    var views:String = ""
    
    //Memory Allocation
    init(dictJSON:NSDictionary) {
        
        self.author = dictJSON.getString(key: "author")
        self.description = dictJSON.getString(key: "description")
        self.mediaDuration = dictJSON.getString(key: "mediaDuration")
        self.prettyDuration = dictJSON.getString(key: "prettyDuration")
        self.quality = dictJSON.getString(key: "quality")
        
        let arrSources = dictJSON.getArray(key: "sources")
        for dataSources in arrSources {
            
            let dictSources = dataSources as! NSDictionary
            let objSources = ModelVideoAssetSources.init(dictJSON: dictSources)
            self.sources.append(objSources)
        }
        
        var imageURL = dictJSON.getString(key: "thumbnailUrl")
        if imageURL.length > 0 && imageURL.lowercased().hasPrefix("http") == false {
            
            if imageURL.lowercased().hasPrefix("//") == false {
                
                imageURL = "http://" + imageURL
            } else {
                
                imageURL = "http:" + imageURL
            }
        }
        self.thumbnailUrl = imageURL
        self.title = dictJSON.getString(key: "title")
        self.type = dictJSON.getString(key: "type")
        self.uploadAsset = dictJSON.getString(key: "uploadAsset")
        self.uploadDate = dictJSON.getString(key: "uploadDate")
        self.videoId = dictJSON.getString(key: "videoId")
        self.views = dictJSON.getString(key: "views")
    }
}
//MARK: - Model Video Asset Sources
class ModelVideoAssetSources {
    
    //Variable Declaration
    var file:String = ""
    var height:String = ""
    var mime:String = ""
    var quality:String = ""
    var qualityActual:String = ""
    var width:String = ""
    var url:String = ""
    
    //Memory Allocation
    init(dictJSON:NSDictionary) {
        
        self.file = dictJSON.getString(key: "file")
        self.height = dictJSON.getString(key: "height")
        self.mime = dictJSON.getString(key: "mime")
        self.quality = dictJSON.getString(key: "quality")
        self.qualityActual = dictJSON.getString(key: "qualityActual")
        self.width = dictJSON.getString(key: "width")
        self.url = dictJSON.getString(key: "url")
        
    }
}
//MARK: - Model Video metrics_statistics
class ModelVideoMetricsStatistics {
    
    //Variable Declaration
    var VV_VI = ModelVideoVV_VI(dictJSON: NSDictionary())
    
    //Memory Allocation
    init(dictJSON:NSDictionary) {
        
        self.VV_VI = ModelVideoVV_VI(dictJSON: dictJSON.getDictionary(key: "VV_VI"))
        
    }
}
//MARK: - Model Video VV_VI
class ModelVideoVV_VI {
    
    //Variable Declaration
    var engagement_score = ModelVideoEngagementScore(dictJSON: NSDictionary())
    var lastUpdatedDate:String = ""
    
    //Memory Allocation
    init(dictJSON:NSDictionary) {
        
        self.lastUpdatedDate = dictJSON.getString(key: "lastUpdatedDate")
        self.engagement_score = ModelVideoEngagementScore(dictJSON: dictJSON.getDictionary(key: "engagement_score"))
        
    }
}
//MARK: - Model Video engagement_score
class ModelVideoEngagementScore {
    
    //Variable Declaration
    var lastUpdatedDate:String = ""
    
    //Memory Allocation
    init(dictJSON:NSDictionary) {
        
        self.lastUpdatedDate = dictJSON.getString(key: "lastUpdatedDate")
        
    }
}

