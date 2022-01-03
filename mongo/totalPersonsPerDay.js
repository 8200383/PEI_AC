db.getSiblingDB("SantaDB").getCollection("Bookings").aggregate([
    {
        $group: {
            _id: {"ScheduleDate": "$ScheduleDate"},
            "sum(NumberOfMembers)": {$sum: "$NumberOfMembers"}
        }
    },
    {
        $project: {"Members": "$sum(NumberOfMembers)", "ScheduleDate": "$_id.ScheduleDate", "_id": 0}
    }
])