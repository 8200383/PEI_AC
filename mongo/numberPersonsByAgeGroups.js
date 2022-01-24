db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {"$unwind": "$Members"},
    {
        "$project": {
            "age": {
                "$divide": [
                    {
                        "$subtract": [
                            new Date(),
                            {"$ifNull": ["$Members.Birthday", new Date()]}
                        ]
                    },
                    1000 * 86400 * 365
                ]
            }
        }
    },
    {
        "$group": {
            "_id": {
                "$concat": [
                    {"$cond": [{"$lte": ["$age", 0]}, "Unknown", ""]},
                    {"$cond": [{"$and": [{"$gt": ["$age", 0]}, {"$lt": ["$age", 18]}]}, "Under 18", ""]},
                    {"$cond": [{"$and": [{"$gte": ["$age", 18]}, {"$lt": ["$age", 25]}]}, "19 - 35", ""]},
                    {"$cond": [{"$and": [{"$gte": ["$age", 25]}, {"$lt": ["$age", 35]}]}, "26 - 35", ""]},
                    {"$cond": [{"$and": [{"$gte": ["$age", 35]}, {"$lt": ["$age", 45]}]}, "36 - 45", ""]},
                    {"$cond": [{"$gte": ["$age", 45]}, "Over 46", ""]}
                ]
            },
            "persons": {"$sum": 1}
        }
    },
    {"$project": {"_id": 0, "age": "$_id", "persons": 1}},
    {$out: "NumberPersonsByAgeGroups"}
])