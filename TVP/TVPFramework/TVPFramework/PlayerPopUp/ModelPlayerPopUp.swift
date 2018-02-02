

import UIKit

//MARK: - Model Class
class ModelProductsOnVideo {
    
    //Variable Declaration
    var OUT_OF_STOCK:String = ""
    var PS_LI_PR:String = ""
    var actionText:String = ""
    var age_group:String = ""
    var availability:String = ""
    var brand:String = ""
    var cartId:String = ""
    var category:String = ""
    var category_id_1:String = ""
    var category_id_2:String = ""
    var color:String = ""
    var conversion_score:String = ""
    var date_created:String = ""
    var date_modified:String = ""
    var description:String = ""
    var entityIdChild:String = ""
    var entityIdParent:String = ""
    var entityType:String = ""
    var gender:String = ""
    var gtin:String = ""
    var id:String = ""
    var imageUrl:String = ""
    var linkUrl:String = ""
    var loginId:String = ""
    var metrics_statistics:String = ""
    var mpn:String = ""
    var pattern:String = ""
    var pcondition:String = ""
    var price:String = ""
    var price_sale:String = ""
    var quantity:String = ""
    var referenceId:String = ""
    var relationId:String = ""
    var relationType:String = ""
    var search:String = ""
    var size:String = ""
    var sortOrder:String = ""
    var tags:String = ""
    var title:String = ""
    var tvp_profiles:String = ""
    var tvp_profiles_manual:String = ""
    var tvp_profiles_maxscore:String = ""
    var visibility:String = ""
    var dictJSON:NSDictionary = NSDictionary()
    
    //Memory Allocation
    init(dictJSON:NSDictionary) {
        
        self.dictJSON = dictJSON.mutableCopy() as! NSDictionary
        self.OUT_OF_STOCK = dictJSON.getString(key: "OUT_OF_STOCK")
        self.PS_LI_PR = dictJSON.getString(key: "PS_LI_PR")
        self.actionText = dictJSON.getString(key: "actionText")
        self.age_group = dictJSON.getString(key: "age_group")
        self.availability = dictJSON.getString(key: "availability")
        self.brand = dictJSON.getString(key: "brand")
        self.cartId = dictJSON.getString(key: "cartId")
        self.category = dictJSON.getString(key: "category")
        self.category_id_1 = dictJSON.getString(key: "category_id_1")
        self.category_id_2 = dictJSON.getString(key: "category_id_2")
        self.color = dictJSON.getString(key: "color")
        self.conversion_score = dictJSON.getString(key: "conversion_score")
        self.date_created = dictJSON.getString(key: "date_created")
        self.date_modified = dictJSON.getString(key: "date_modified")
        self.description = dictJSON.getString(key: "description")
        self.entityIdChild = dictJSON.getString(key: "entityIdChild")
        self.entityIdParent = dictJSON.getString(key: "entityIdParent")
        self.entityType = dictJSON.getString(key: "entityType")
        self.gender = dictJSON.getString(key: "gender")
        self.gtin = dictJSON.getString(key: "gtin")
        self.id = dictJSON.getString(key: "id")
        self.imageUrl = dictJSON.getString(key: "imageUrl")
        self.linkUrl = dictJSON.getString(key: "linkUrl")
        self.loginId = dictJSON.getString(key: "loginId")
        self.metrics_statistics = dictJSON.getString(key: "metrics_statistics")
        self.mpn = dictJSON.getString(key: "mpn")
        self.pattern = dictJSON.getString(key: "pattern")
        self.pcondition = dictJSON.getString(key: "pcondition")
        self.price = dictJSON.getString(key: "price")
        self.price_sale = dictJSON.getString(key: "price_sale")
        self.quantity = dictJSON.getString(key: "quantity")
        self.referenceId = dictJSON.getString(key: "referenceId")
        self.relationId = dictJSON.getString(key: "relationId")
        self.relationType = dictJSON.getString(key: "relationType")
        self.search = dictJSON.getString(key: "search")
        self.size = dictJSON.getString(key: "size")
        self.sortOrder = dictJSON.getString(key: "sortOrder")
        self.tags = dictJSON.getString(key: "tags")
        self.title = dictJSON.getString(key: "title")
        self.tvp_profiles = dictJSON.getString(key: "tvp_profiles")
        self.tvp_profiles_manual = dictJSON.getString(key: "tvp_profiles_manual")
        self.tvp_profiles_maxscore = dictJSON.getString(key: "tvp_profiles_maxscore")
        self.visibility = dictJSON.getString(key: "visibility")
    }
}
